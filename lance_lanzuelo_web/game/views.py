from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.contrib.admin.views.decorators import staff_member_required
from django.views.decorators.http import require_http_methods
from django.db import models
from django.utils import timezone
from .models import *
from . import game_logic
from datetime import datetime, timedelta


def _get_company_for_login(nombre, password, juego_id):
    if not nombre or not password:
        raise Compania.DoesNotExist

    if juego_id:
        try:
            return Compania.objects.get(nombre=nombre, password=password, juego_id=juego_id)
        except Compania.DoesNotExist:
            pass

    try:
        return Compania.objects.get(nombre=nombre, password=password)
    except Compania.DoesNotExist:
        pass

    if juego_id:
        try:
            return Compania.objects.get(nombre=nombre, juego_id=juego_id, password=nombre)
        except Compania.DoesNotExist:
            pass

    return Compania.objects.get(nombre=nombre, password=nombre)

def login_view(request):
    if request.method == 'POST':
        nombre = (request.POST.get('nombre') or '').strip()
        password = (request.POST.get('password') or '').strip()
        juego_id = request.POST.get('juego_id')
        try:
            compania = _get_company_for_login(nombre, password, juego_id)
            request.session['compania_id'] = compania.id
            request.session['juego_id'] = compania.juego_id
            return redirect('golfo')
        except Compania.DoesNotExist:
            return render(request, 'login.html', {'error': 'Credenciales inválidas'})
    return render(request, 'login.html')

def logout_view(request):
    request.session.flush()
    return redirect('login')


def home_view(request):
    return redirect('login')


@staff_member_required
def admin_panel(request):
    juegos = Juego.objects.all().order_by('-id')
    companias = Compania.objects.select_related('juego').all().order_by('juego_id', 'nombre')
    ultimo_turno = Turno.objects.order_by('-turno_id').first()
    contexto = {
        'juegos': juegos,
        'companias': companias,
        'ultimo_turno': ultimo_turno,
        'total_juegos': juegos.count(),
        'total_companias': companias.count(),
    }
    return render(request, 'admin_panel.html', contexto)


def juego_produccion(request):
    if 'compania_id' not in request.session:
        return redirect('login')

    compania = Compania.objects.get(id=request.session['compania_id'])
    turno_actual = Turno.objects.filter(juego=compania.juego).order_by('-turno_id').first()
    barcos = BarcosXCompania.objects.filter(compania=compania).select_related('tipo_barco', 'ubicacion')
    resumen = []
    for barco in barcos:
        resumen.append({
            'tipo': barco.tipo_barco.nombre,
            'cantidad': barco.cantidad,
            'ubicacion': barco.ubicacion.nombre,
            'capacidad': barco.tipo_barco.capacidad,
        })

    contexto = {
        'compania': compania,
        'turno_actual': turno_actual.turno_id if turno_actual else 0,
        'barcos': resumen,
        'balance': compania.estado_resultados,
    }
    return render(request, 'juego_produccion.html', contexto)


def golfo_view(request):
    if 'compania_id' not in request.session:
        return redirect('login')
    compania = Compania.objects.get(id=request.session['compania_id'])
    return render(request, 'golfo.html', {'compania': compania})

def _get_decision_actual(compania, turno_actual):
    if turno_actual is None:
        return None
    return Decision.objects.filter(compania=compania, turno=turno_actual).order_by('-id').first()


def _calcular_resumen_posicion(compania, turno_actual):
    decision = _get_decision_actual(compania, turno_actual)
    if not decision:
        return {
            'captura_total': 0,
            'costo_operativo': 0,
            'ingresos_estimados': 0,
            'por_region': {'costa': 0, 'mar_profundo': 0, 'puerto': 0},
        }

    captura_costa = (
        decision.chalupas_costa * 120 + decision.pangas_costa * 320 + decision.pesqueros_costa * 610
    )
    captura_mar_profundo = (
        decision.chalupas_mar_profundo * 230 + decision.pangas_mar_profundo * 520 + decision.pesqueros_mar_profundo * 910
    )
    captura_puerto = (
        decision.chalupas_puerto * 15 + decision.pangas_puerto * 40 + decision.pesqueros_puerto * 80
    )

    costo_operativo = 0
    for attr, tipo, region in [
        ('chalupas_puerto', 'Chalupa', 'PUERTO'),
        ('chalupas_costa', 'Chalupa', 'COSTA'),
        ('chalupas_mar_profundo', 'Chalupa', 'MAR PROFUNDO'),
        ('pangas_puerto', 'Panga', 'PUERTO'),
        ('pangas_costa', 'Panga', 'COSTA'),
        ('pangas_mar_profundo', 'Panga', 'MAR PROFUNDO'),
        ('pesqueros_puerto', 'Barco Pesquero', 'PUERTO'),
        ('pesqueros_costa', 'Barco Pesquero', 'COSTA'),
        ('pesqueros_mar_profundo', 'Barco Pesquero', 'MAR PROFUNDO'),
    ]:
        cantidad = getattr(decision, attr)
        if cantidad <= 0:
            continue
        costo = CostoOperativo.objects.filter(ubicacion__nombre=region, tipo_barco__nombre=tipo).first()
        if costo:
            costo_operativo += cantidad * costo.valor

    captura_total = captura_costa + captura_mar_profundo + captura_puerto
    ingresos_estimados = int(captura_total * 4500)

    return {
        'captura_total': captura_total,
        'costo_operativo': costo_operativo,
        'ingresos_estimados': ingresos_estimados,
        'por_region': {
            'costa': captura_costa,
            'mar_profundo': captura_mar_profundo,
            'puerto': captura_puerto,
        },
    }


def compania_view(request):
    if 'compania_id' not in request.session:
        return redirect('login')
    compania = Compania.objects.get(id=request.session['compania_id'])
    turno_actual = Turno.objects.filter(juego=compania.juego).order_by('-turno_id').first()
    resumen_posicion = _calcular_resumen_posicion(compania, turno_actual)
    return render(request, 'compania.html', {'compania': compania, 'resumen_posicion': resumen_posicion})

def api_estado_golfo(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    juego = compania.juego
    turno_actual = Turno.objects.filter(juego=juego).order_by('-turno_id').first()
    
    barcos = BarcosXCompania.objects.filter(compania=compania)
    
    barcos_data = []
    for barco in barcos:
        barcos_data.append({
            'tipo': barco.tipo_barco.nombre,
            'ubicacion': barco.ubicacion.nombre,
            'cantidad': barco.cantidad,
            'capacidad': barco.tipo_barco.capacidad,
        })
    
    return JsonResponse({'barcos': barcos_data, 'turno': turno_actual.turno_id if turno_actual else 0})

def api_estado_compania(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    
    return JsonResponse({
        'nombre': compania.nombre,
        'balance': compania.estado_resultados,
        'costo_ultimo_turno': compania.costo_ultimo_turno,
    })


@require_http_methods(["POST"])
def comprar_barcos_view(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)

    compania = Compania.objects.get(id=request.session['compania_id'])
    nombre = (request.POST.get('nombre') or '').strip()
    cantidad = request.POST.get('cantidad') or 0
    resultado = game_logic.comprar_barcos(compania, nombre, cantidad)

    if not resultado['ok']:
        return JsonResponse({'ok': False, 'message': resultado['message']}, status=400)

    return JsonResponse({'ok': True, **resultado})


@require_http_methods(["POST"])
def apostar_subasta_view(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)

    compania = Compania.objects.get(id=request.session['compania_id'])
    valor = request.POST.get('valor') or 0
    turno_id = request.POST.get('turno_id')
    turno = None
    if turno_id:
        turno = Turno.objects.filter(juego=compania.juego, turno_id=int(turno_id)).first()

    resultado = game_logic.apostar_en_subasta(compania, valor, turno)
    if not resultado['ok']:
        return JsonResponse({'ok': False, 'message': resultado['message']}, status=400)

    return JsonResponse({'ok': True, **resultado})

def api_banco(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    reportes = Reporte.objects.filter(compania=compania).order_by('-turno__turno_id')[:10]
    
    historial = []
    for reporte in reportes:
        historial.append({
            'turno': reporte.turno.turno_id,
            'ingresos': reporte.balance_general,
            'fecha': reporte.turno.insercion.isoformat(),
        })
    
    return JsonResponse({'historial': historial, 'balance': compania.estado_resultados})

def api_estadisticas(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    reportes = Reporte.objects.filter(compania=compania).order_by('-turno__turno_id')[:5]
    
    stats = []
    for reporte in reportes:
        total_captura = (reporte.captura_robalo_costa + reporte.captura_robalo_mar_profundo +
                        reporte.captura_sierra_costa + reporte.captura_sierra_mar_profundo +
                        reporte.captura_pargo_costa + reporte.captura_pargo_mar_profundo)
        stats.append({
            'turno': reporte.turno.turno_id,
            'captura_total': total_captura,
            'ingresos': reporte.balance_general,
        })
    
    return JsonResponse({'stats': stats})

def api_mercado(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    tipos_barco = TipoBarco.objects.all()
    barcos = []
    for tipo in tipos_barco:
        barcos.append({
            'nombre': tipo.nombre,
            'precio': tipo.precio,
            'capacidad': tipo.capacidad,
        })
    
    return JsonResponse({'barcos': barcos})


def api_captura_por_region(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)

    compania = Compania.objects.get(id=request.session['compania_id'])
    turno_actual = Turno.objects.filter(juego=compania.juego).order_by('-turno_id').first()
    if not turno_actual:
        return JsonResponse({'costa': 0, 'mar_profundo': 0, 'total': 0, 'porcentajes': {'costa': 0, 'mar_profundo': 0}})

    resumen = game_logic.resumen_captura_por_region(compania, turno_actual)
    return JsonResponse(resumen)

@require_http_methods(["GET", "POST"])
def api_posicion(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    juego = compania.juego
    turno_actual = Turno.objects.filter(juego=juego).order_by('-turno_id').first()
    
    if request.method == 'POST':
        # Guardar nuevas decisiones de posicionamiento
        try:
            chalupas_puerto = int(request.POST.get('chalupas_puerto', 0))
            chalupas_costa = int(request.POST.get('chalupas_costa', 0))
            chalupas_mar_profundo = int(request.POST.get('chalupas_mar_profundo', 0))
            pangas_puerto = int(request.POST.get('pangas_puerto', 0))
            pangas_costa = int(request.POST.get('pangas_costa', 0))
            pangas_mar_profundo = int(request.POST.get('pangas_mar_profundo', 0))
            pesqueros_puerto = int(request.POST.get('pesqueros_puerto', 0))
            pesqueros_costa = int(request.POST.get('pesqueros_costa', 0))
            pesqueros_mar_profundo = int(request.POST.get('pesqueros_mar_profundo', 0))
            
            # Validar que los barcos existan en inventario
            chalupas_total = chalupas_puerto + chalupas_costa + chalupas_mar_profundo
            pangas_total = pangas_puerto + pangas_costa + pangas_mar_profundo
            pesqueros_total = pesqueros_puerto + pesqueros_costa + pesqueros_mar_profundo
            
            chalupas_inv = BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Chalupa').aggregate(total=models.Sum('cantidad'))['total'] or 0
            pangas_inv = BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Panga').aggregate(total=models.Sum('cantidad'))['total'] or 0
            pesqueros_inv = BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Barco Pesquero').aggregate(total=models.Sum('cantidad'))['total'] or 0
            
            if chalupas_total > chalupas_inv or pangas_total > pangas_inv or pesqueros_total > pesqueros_inv:
                return JsonResponse({'ok': False, 'message': 'Barcos insuficientes'}, status=400)
            
                    # Mantener una sola decisión vigente por turno para que la compañía vea el nuevo posicionamiento inmediatamente.
            Decision.objects.filter(compania=compania, turno=turno_actual).delete()
            decision = Decision.objects.create(
                compania=compania,
                turno=turno_actual,
                chalupas_puerto=chalupas_puerto,
                chalupas_costa=chalupas_costa,
                chalupas_mar_profundo=chalupas_mar_profundo,
                pangas_puerto=pangas_puerto,
                pangas_costa=pangas_costa,
                pangas_mar_profundo=pangas_mar_profundo,
                pesqueros_puerto=pesqueros_puerto,
                pesqueros_costa=pesqueros_costa,
                pesqueros_mar_profundo=pesqueros_mar_profundo,
            )

            resumen = _calcular_resumen_posicion(compania, turno_actual)
            return JsonResponse({'ok': True, 'message': 'Posicionamiento actualizado', 'created': True, 'resumen': resumen})
        except (ValueError, TypeError) as e:
            return JsonResponse({'ok': False, 'message': f'Error: {str(e)}'}, status=400)
    
    # GET: retornar estado actual con tasas
    decision = _get_decision_actual(compania, turno_actual)
    
    # Tasas de pesca y nacimiento por ubicación (hardcodeadas por ahora)
    tasas = {
        'costa': {'pesca': 1.0, 'nacimiento': 0.15},
        'mar_profundo': {'pesca': 1.7, 'nacimiento': 0.12},
        'puerto': {'pesca': 0.15, 'nacimiento': 0.2},
    }
    
    # Inventario de barcos
    inventario = {
        'chalupas': BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Chalupa').aggregate(total=models.Sum('cantidad'))['total'] or 0,
        'pangas': BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Panga').aggregate(total=models.Sum('cantidad'))['total'] or 0,
        'pesqueros': BarcosXCompania.objects.filter(compania=compania, tipo_barco__nombre='Barco Pesquero').aggregate(total=models.Sum('cantidad'))['total'] or 0,
    }
    
    respuesta = {
        'tasas': tasas,
        'inventario': inventario,
        'balance': compania.estado_resultados,
        'resumen': _calcular_resumen_posicion(compania, turno_actual),
    }
    
    if decision:
        respuesta.update({
            'chalupas_costa': decision.chalupas_costa,
            'chalupas_mar_profundo': decision.chalupas_mar_profundo,
            'chalupas_puerto': decision.chalupas_puerto,
            'pangas_costa': decision.pangas_costa,
            'pangas_mar_profundo': decision.pangas_mar_profundo,
            'pangas_puerto': decision.pangas_puerto,
            'pesqueros_costa': decision.pesqueros_costa,
            'pesqueros_mar_profundo': decision.pesqueros_mar_profundo,
            'pesqueros_puerto': decision.pesqueros_puerto,
        })
    else:
        respuesta.update({
            'chalupas_costa': 0, 'chalupas_mar_profundo': 0, 'chalupas_puerto': 0,
            'pangas_costa': 0, 'pangas_mar_profundo': 0, 'pangas_puerto': 0,
            'pesqueros_costa': 0, 'pesqueros_mar_profundo': 0, 'pesqueros_puerto': 0,
        })
    
    return JsonResponse(respuesta)

def api_subasta(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    juego = compania.juego
    turno_actual = Turno.objects.filter(juego=juego).order_by('-turno_id').first()
    
    subasta = Subasta.objects.filter(turno=turno_actual).first()
    
    if not subasta:
        return JsonResponse({'error': 'No hay subasta activa'}, status=404)
    
    oferta = Oferta.objects.filter(compania=compania, subasta=subasta).first()
    
    return JsonResponse({
        'abierta': subasta.abierta,
        'costo_base': subasta.costo_base,
        'num_chalupas': subasta.num_chalupas,
        'num_pangas': subasta.num_pangas,
        'num_pesqueros': subasta.num_pesqueros,
        'mi_oferta': oferta.valor if oferta else None,
    })

def api_noticias(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    juego = compania.juego
    mensajes = Mensaje.objects.filter(turno__juego=juego).order_by('-id')[:5]
    
    noticias = []
    for msg in mensajes:
        noticias.append({
            'turno': msg.turno.turno_id,
            'texto': msg.texto,
            'fecha': msg.turno.insercion.isoformat(),
        })
    
    return JsonResponse({'noticias': noticias})

def api_turno_info(request):
    if 'compania_id' not in request.session:
        return JsonResponse({'error': 'No autorizado'}, status=401)
    
    compania = Compania.objects.get(id=request.session['compania_id'])
    juego = compania.juego
    turno_actual = Turno.objects.filter(juego=juego).order_by('-turno_id').first()
    
    if not turno_actual:
        return JsonResponse({'turno': 0, 'tiempo_restante': 0, 'max_turnos': juego.max_turnos})
    
    tiempo_transcurrido = (timezone.now() - turno_actual.insercion).total_seconds()
    tiempo_total = juego.duracion_turnos * 60
    tiempo_restante = max(0, tiempo_total - tiempo_transcurrido)
    
    return JsonResponse({
        'turno': turno_actual.turno_id,
        'tiempo_restante': int(tiempo_restante),
        'tiempo_total': tiempo_total,
        'max_turnos': juego.max_turnos,
        'finalizado': juego.finalizado,
    })

@staff_member_required
@require_http_methods(["POST"])
def admin_avanzar_turno(request):
    juego_id = request.POST.get('juego_id') or request.GET.get('juego_id')
    if not juego_id:
        return JsonResponse({'status': 'error', 'message': 'Falta el juego'}, status=400)

    game_logic.avanzar_turno(int(juego_id))
    return JsonResponse({'status': 'ok', 'message': 'Turno avanzado'})


@staff_member_required
@require_http_methods(["POST"])
def admin_nuevo_juego(request):
    descripcion = request.POST.get('descripcion') or 'Juego nuevo'
    duracion = int(request.POST.get('duracion_turnos') or 5)
    max_turnos = int(request.POST.get('max_turnos') or 11)

    juego = Juego.objects.create(descripcion=descripcion, duracion_turnos=duracion, max_turnos=max_turnos)
    turno_inicial = Turno.objects.create(turno_id=0, juego=juego)
    Subasta.objects.create(turno=turno_inicial)

    return JsonResponse({'status': 'ok', 'message': 'Nuevo juego creado', 'juego_id': juego.id})


@staff_member_required
def admin_metricas(request):
    juego_id = request.GET.get('juego_id')
    if not juego_id:
        ultimo_juego = Juego.objects.order_by('-id').first()
        if not ultimo_juego:
            return JsonResponse({'turnos': [], 'series': [], 'balances': [], 'growth': [], 'regional': [], 'ranking': []})
        juego_id = ultimo_juego.id

    juego = Juego.objects.filter(id=juego_id).first()
    if not juego:
        return JsonResponse({'turnos': [], 'series': [], 'balances': [], 'growth': [], 'regional': [], 'ranking': []})

    companias = Compania.objects.filter(juego=juego).order_by('nombre')
    turnos = list(Turno.objects.filter(juego=juego).order_by('turno_id').values_list('turno_id', flat=True))
    colors = ['#3bd9ff', '#ffd166', '#70e0a5', '#ff7a59', '#c084fc']

    series = []
    balances = []
    growth_data = []
    regional_data = []
    ranking = []

    for index, compania in enumerate(companias):
        puntos = []
        acumulado = 500000000
        captura_total = 0
        costa_total = 0
        mar_total = 0
        growth_points = []
        saldo_anterior = 500000000

        for turno_id in turnos:
            reporte = Reporte.objects.filter(compania=compania, turno__turno_id=turno_id).first()
            balance_turno = reporte.balance_general if reporte else 0
            acumulado += balance_turno
            puntos.append({'x': turno_id, 'y': acumulado})

            if reporte:
                captura_turno = (reporte.captura_robalo_costa + reporte.captura_sierra_costa + reporte.captura_pargo_costa +
                                 reporte.captura_robalo_mar_profundo + reporte.captura_sierra_mar_profundo + reporte.captura_pargo_mar_profundo)
                captura_total += captura_turno
                costa = reporte.captura_robalo_costa + reporte.captura_sierra_costa + reporte.captura_pargo_costa
                mar = reporte.captura_robalo_mar_profundo + reporte.captura_sierra_mar_profundo + reporte.captura_pargo_mar_profundo
                costa_total += costa
                mar_total += mar

                tasa_crecimiento = round(((acumulado - saldo_anterior) / max(saldo_anterior, 1)) * 100, 2) if saldo_anterior else 0
                growth_points.append({'x': turno_id, 'y': tasa_crecimiento})
                saldo_anterior = acumulado

        series.append({
            'name': compania.nombre,
            'color': colors[index % len(colors)],
            'points': puntos,
        })

        balances.append({
            'name': compania.nombre,
            'balance': int(compania.estado_resultados),
            'juego': juego.id,
        })

        growth_data.append({
            'name': compania.nombre,
            'color': colors[index % len(colors)],
            'points': growth_points,
        })

        regional_data.append({
            'name': compania.nombre,
            'costa': costa_total,
            'mar': mar_total,
            'total': captura_total,
        })

        ranking.append({
            'name': compania.nombre,
            'balance': int(compania.estado_resultados),
            'captura': captura_total,
            'costa_pct': round((costa_total / max(captura_total, 1)) * 100, 1),
            'mar_pct': round((mar_total / max(captura_total, 1)) * 100, 1),
        })

    ranking.sort(key=lambda x: x['balance'], reverse=True)

    return JsonResponse({
        'turnos': turnos,
        'series': series,
        'balances': balances,
        'growth': growth_data,
        'regional': regional_data,
        'ranking': ranking,
    })
