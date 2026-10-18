from .models import *
from .consumers import broadcast_turno_actualizado
import json


def debe_generar_noticias(turno_numero):
    return turno_numero % 2 == 0 or turno_numero % 3 == 0


def generar_noticias_turno(turno):
    if not debe_generar_noticias(turno.turno_id):
        return []

    mensajes = [
        f'La pesca en Costa está en tendencia alta durante el turno {turno.turno_id}.',
        f'Los operarios reportan mejorías en Mar Profundo y mayor riesgo operativo.',
        f'La subasta del turno {turno.turno_id} concentra interés por flotas modernas y más capacidad.',
    ]

    creadas = []
    for texto in mensajes:
        obj = Mensaje.objects.create(turno=turno, texto=texto)
        creadas.append(obj.texto)
    return creadas


def generar_noticias_si_corresponde(turno):
    if turno is None:
        return []
    return generar_noticias_turno(turno)


def calcular_captura(turno, juego):
    resultados = []
    for compania in Compania.objects.filter(juego=juego):
        decision = Decision.objects.filter(compania=compania, turno=turno).order_by('-id').first()
        reporte = Reporte.objects.filter(compania=compania, turno=turno).first()
        if reporte is None:
            reporte = Reporte.objects.create(compania=compania, turno=turno)
        if decision is None:
            resultados.append({'compania': compania.nombre, 'captura_total': 0, 'balance_general': 0})
            continue

        total = 0
        total += decision.chalupas_costa * 120 + decision.chalupas_mar_profundo * 230
        total += decision.pangas_costa * 320 + decision.pangas_mar_profundo * 520
        total += decision.pesqueros_costa * 610 + decision.pesqueros_mar_profundo * 910

        reporte.balance_general = int(total * 4500)
        reporte.captura_robalo_costa = decision.chalupas_costa * 30 + decision.pangas_costa * 45 + decision.pesqueros_costa * 70
        reporte.captura_robalo_mar_profundo = decision.chalupas_mar_profundo * 45 + decision.pangas_mar_profundo * 80 + decision.pesqueros_mar_profundo * 120
        reporte.captura_sierra_costa = decision.chalupas_costa * 18 + decision.pangas_costa * 27 + decision.pesqueros_costa * 40
        reporte.captura_sierra_mar_profundo = decision.chalupas_mar_profundo * 25 + decision.pangas_mar_profundo * 45 + decision.pesqueros_mar_profundo * 70
        reporte.captura_pargo_costa = decision.chalupas_costa * 12 + decision.pangas_costa * 20 + decision.pesqueros_costa * 34
        reporte.captura_pargo_mar_profundo = decision.chalupas_mar_profundo * 16 + decision.pangas_mar_profundo * 30 + decision.pesqueros_mar_profundo * 60
        reporte.save()

        compania.estado_resultados += reporte.balance_general
        compania.save(update_fields=['estado_resultados'])
        resultados.append({'compania': compania.nombre, 'captura_total': total, 'balance_general': reporte.balance_general})

    return resultados


def calcular_captura_zona(barcos_cantidad, tipo_barco_id, nombre_compania, turno, zona_id, reporte, peces_dict):
    tipo = TipoBarco.objects.get(id=tipo_barco_id)
    zona = Ubicacion.objects.get(id=zona_id)
    factor_zona = {'COSTA': 1.0, 'MAR PROFUNDO': 1.7, 'PUERTO': 0.15}.get(zona.nombre, 1.0)
    factor_tipo = {'Chalupa': 1.0, 'Panga': 1.8, 'Barco Pesquero': 3.2}.get(tipo.nombre, 1.0)
    poblacion_total = sum(peces_dict.values()) if peces_dict else 1
    base = barcos_cantidad * tipo.capacidad * factor_zona * factor_tipo
    captura = int((base / max(poblacion_total, 1)) * 220)

    if zona.nombre == 'COSTA':
        reporte.captura_robalo_costa += captura
        reporte.captura_sierra_costa += int(captura * 0.55)
        reporte.captura_pargo_costa += int(captura * 0.35)
    elif zona.nombre == 'MAR PROFUNDO':
        reporte.captura_robalo_mar_profundo += captura
        reporte.captura_sierra_mar_profundo += int(captura * 0.62)
        reporte.captura_pargo_mar_profundo += int(captura * 0.48)
    else:
        reporte.captura_pargo_costa += int(captura * 0.12)

    reporte.save(update_fields=['captura_robalo_costa', 'captura_robalo_mar_profundo', 'captura_sierra_costa', 'captura_sierra_mar_profundo', 'captura_pargo_costa', 'captura_pargo_mar_profundo'])
    return captura


def reproducir_peces(turno_nuevo, turno_anterior, juego, tasa=0.15):
    for pez in Pez.objects.filter(turno=turno_anterior):
        Pez.objects.create(
            tipo_pez=pez.tipo_pez,
            ubicacion=pez.ubicacion,
            turno=turno_nuevo,
            poblacion=int(pez.poblacion * (1 + tasa))
        )


def calcular_costos_operativos(compania, turno):
    total = 0
    decisiones = Decision.objects.filter(compania=compania, turno=turno).order_by('-id').first()
    if not decisiones:
        return 0

    for ubicacion, nombre in [('chalupas_puerto', 'PUERTO'), ('chalupas_costa', 'COSTA'), ('chalupas_mar_profundo', 'MAR PROFUNDO')]:
        cantidad = getattr(decisiones, ubicacion)
        if cantidad:
            costo = CostoOperativo.objects.filter(ubicacion__nombre=nombre, tipo_barco__nombre='Chalupa').first()
            if costo:
                total += cantidad * costo.valor

    for ubicacion, nombre in [('pangas_puerto', 'PUERTO'), ('pangas_costa', 'COSTA'), ('pangas_mar_profundo', 'MAR PROFUNDO')]:
        cantidad = getattr(decisiones, ubicacion)
        if cantidad:
            costo = CostoOperativo.objects.filter(ubicacion__nombre=nombre, tipo_barco__nombre='Panga').first()
            if costo:
                total += cantidad * costo.valor

    for ubicacion, nombre in [('pesqueros_puerto', 'PUERTO'), ('pesqueros_costa', 'COSTA'), ('pesqueros_mar_profundo', 'MAR PROFUNDO')]:
        cantidad = getattr(decisiones, ubicacion)
        if cantidad:
            costo = CostoOperativo.objects.filter(ubicacion__nombre=nombre, tipo_barco__nombre='Barco Pesquero').first()
            if costo:
                total += cantidad * costo.valor

    compania.costo_ultimo_turno = total
    compania.save(update_fields=['costo_ultimo_turno'])
    return total


def asignar_barcos_pedidos(turno_actual, juego):
    for pedido in Pedido.objects.filter(turno=turno_actual):
        compania = pedido.compania
        for ubicacion in Ubicacion.objects.all():
            if ubicacion.nombre == 'PUERTO':
                for tipo, cantidad in [
                    ('Chalupa', pedido.num_chalupas),
                    ('Panga', pedido.num_pangas),
                    ('Barco Pesquero', pedido.num_pesqueros),
                ]:
                    tipo_barco = TipoBarco.objects.filter(nombre=tipo).first()
                    if tipo_barco:
                        registro, _ = BarcosXCompania.objects.get_or_create(
                            compania=compania,
                            tipo_barco=tipo_barco,
                            ubicacion=ubicacion,
                            defaults={'cantidad': 0},
                        )
                        registro.cantidad += cantidad
                        registro.save(update_fields=['cantidad'])


def resolver_subasta(turno, juego):
    subasta = Subasta.objects.filter(turno=turno).first()
    if not subasta or not subasta.abierta:
        return {'ok': False, 'message': 'No hay subasta abierta'}

    ofertas = Oferta.objects.filter(subasta=subasta).order_by('-valor')
    if not ofertas.exists():
        subasta.abierta = False
        subasta.save(update_fields=['abierta'])
        return {'ok': False, 'message': 'La subasta no tuvo ofertas'}

    ganadora = ofertas[0]
    ganador = ganadora.compania
    barco_total = subasta.num_chalupas + subasta.num_pangas + subasta.num_pesqueros
    if barco_total <= 0:
        subasta.abierta = False
        subasta.save(update_fields=['abierta'])
        return {'ok': False, 'message': 'La subasta no tiene barcos para asignar'}

    win_cost = ganadora.valor
    ganador.estado_resultados -= win_cost
    ganador.save(update_fields=['estado_resultados'])

    for tipo, cantidad in [
        ('Chalupa', subasta.num_chalupas),
        ('Panga', subasta.num_pangas),
        ('Barco Pesquero', subasta.num_pesqueros),
    ]:
        tipo_barco = TipoBarco.objects.filter(nombre=tipo).first()
        if tipo_barco and cantidad > 0:
            registro, _ = BarcosXCompania.objects.get_or_create(
                compania=ganador,
                tipo_barco=tipo_barco,
                ubicacion=Ubicacion.objects.get(nombre='PUERTO'),
                defaults={'cantidad': 0},
            )
            registro.cantidad += cantidad
            registro.save(update_fields=['cantidad'])

    subasta.abierta = False
    subasta.save(update_fields=['abierta'])

    Mensaje.objects.create(turno=turno, texto=f'{ganador.nombre} ganó la subasta con una oferta de ${win_cost:,} y recibió {barco_total} barcos.')
    return {'ok': True, 'ganador': ganador.nombre, 'monto': win_cost}


def comprar_barcos(compania, nombre_barco, cantidad):
    if not nombre_barco:
        return {'ok': False, 'message': 'Debe indicar el tipo de barco'}

    try:
        cantidad = int(cantidad)
    except (TypeError, ValueError):
        return {'ok': False, 'message': 'La cantidad debe ser un número'}

    if cantidad <= 0:
        return {'ok': False, 'message': 'La cantidad debe ser mayor a cero'}

    tipo = TipoBarco.objects.filter(nombre__iexact=nombre_barco).first()
    if not tipo:
        return {'ok': False, 'message': 'Tipo de barco no encontrado'}

    costo_total = tipo.precio * cantidad
    if compania.estado_resultados < costo_total:
        return {'ok': False, 'message': f'Saldo insuficiente para comprar {cantidad} {tipo.nombre}(s)'}

    puerto = Ubicacion.objects.get(nombre='PUERTO')
    registro, _ = BarcosXCompania.objects.get_or_create(
        compania=compania,
        tipo_barco=tipo,
        ubicacion=puerto,
        defaults={'cantidad': 0},
    )
    registro.cantidad += cantidad
    registro.save(update_fields=['cantidad'])

    compania.estado_resultados -= costo_total
    compania.save(update_fields=['estado_resultados'])
    return {'ok': True, 'message': f'{cantidad} {tipo.nombre}(s) comprados', 'costo': costo_total, 'nuevo_balance': compania.estado_resultados}


def apostar_en_subasta(compania, valor, turno=None):
    if turno is None:
        turno = Turno.objects.filter(juego=compania.juego).order_by('-turno_id').first()

    if turno is None:
        return {'ok': False, 'message': 'No hay turno activo'}

    try:
        valor = int(valor)
    except (TypeError, ValueError):
        return {'ok': False, 'message': 'La oferta debe ser un número'}

    subasta = Subasta.objects.filter(turno=turno).first()
    if not subasta:
        return {'ok': False, 'message': 'No hay subasta activa'}
    if not subasta.abierta:
        return {'ok': False, 'message': 'La subasta ya cerró'}
    if valor <= 0:
        return {'ok': False, 'message': 'La oferta debe ser mayor a cero'}

    oferta, created = Oferta.objects.update_or_create(
        compania=compania,
        subasta=subasta,
        defaults={'valor': valor},
    )
    return {'ok': True, 'message': 'Oferta registrada con éxito', 'oferta': oferta.valor, 'created': created}


def resumen_captura_por_region(compania, turno):
    reporte = Reporte.objects.filter(compania=compania, turno=turno).first()
    if not reporte:
        return {'costa': 0, 'mar_profundo': 0, 'total': 0, 'porcentajes': {'costa': 0, 'mar_profundo': 0}}

    costa = (
        reporte.captura_robalo_costa + reporte.captura_sierra_costa + reporte.captura_pargo_costa
    )
    mar = (
        reporte.captura_robalo_mar_profundo + reporte.captura_sierra_mar_profundo + reporte.captura_pargo_mar_profundo
    )
    total = costa + mar

    porcentaje_costa = round((costa / total) * 100, 2) if total else 0.0
    porcentaje_mar = round((mar / total) * 100, 2) if total else 0.0
    return {
        'costa': costa,
        'mar_profundo': mar,
        'total': total,
        'porcentajes': {'costa': porcentaje_costa, 'mar_profundo': porcentaje_mar},
    }


def avanzar_turno(juego_id):
    juego = Juego.objects.get(id=juego_id)
    if juego.finalizado:
        return

    turno_actual = Turno.objects.filter(juego=juego).order_by('-turno_id').first()
    if not turno_actual:
        turno_actual = Turno.objects.create(turno_id=0, juego=juego)

    nuevo_turno_id = turno_actual.turno_id + 1
    if nuevo_turno_id > juego.max_turnos:
        juego.finalizado = True
        juego.save()
        return

    nuevo_turno = Turno.objects.create(turno_id=nuevo_turno_id, juego=juego)
    reproducir_peces(nuevo_turno, turno_actual, juego)
    Subasta.objects.create(turno=nuevo_turno)

    for compania in Compania.objects.filter(juego=juego):
        Decision.objects.create(compania=compania, turno=nuevo_turno)
        Reporte.objects.create(compania=compania, turno=nuevo_turno)

    generar_noticias_si_corresponde(nuevo_turno)
    broadcast_turno_actualizado(juego_id, {'event': 'nuevo_turno', 'turno': nuevo_turno_id})
    return nuevo_turno
