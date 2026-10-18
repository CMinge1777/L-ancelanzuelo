from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand
from game.models import *

class Command(BaseCommand):
    help = 'Configura datos iniciales del juego'

    def handle(self, *args, **kwargs):
        User = get_user_model()
        User.objects.filter(username='admin').delete()
        User.objects.create_superuser(username='admin', email='admin@lance-lanzuelo.local', password='admin123')

        chalupa, _ = TipoBarco.objects.get_or_create(nombre='Chalupa', defaults={'precio': 3000000, 'capacidad': 900})
        panga, _ = TipoBarco.objects.get_or_create(nombre='Panga', defaults={'precio': 30000000, 'capacidad': 2000})
        pesquero, _ = TipoBarco.objects.get_or_create(nombre='Barco Pesquero', defaults={'precio': 80000000, 'capacidad': 9000})

        robalo, _ = TipoPez.objects.get_or_create(nombre='Robalo', defaults={'precio': 3800})
        sierra, _ = TipoPez.objects.get_or_create(nombre='Sierra', defaults={'precio': 3000})
        pargo, _ = TipoPez.objects.get_or_create(nombre='Pargo', defaults={'precio': 6000})

        puerto, _ = Ubicacion.objects.get_or_create(id=0, defaults={'nombre': 'PUERTO'})
        costa, _ = Ubicacion.objects.get_or_create(id=1, defaults={'nombre': 'COSTA'})
        mar_profundo, _ = Ubicacion.objects.get_or_create(id=2, defaults={'nombre': 'MAR PROFUNDO'})

        for ubicacion, tipo_barco, valor in [
            (puerto, chalupa, 100000),
            (puerto, panga, 300000),
            (puerto, pesquero, 500000),
            (costa, chalupa, 2000000),
            (costa, panga, 5000000),
            (costa, pesquero, 10000000),
            (mar_profundo, chalupa, 100000000),
            (mar_profundo, panga, 10000000),
            (mar_profundo, pesquero, 25000000),
        ]:
            CostoOperativo.objects.get_or_create(ubicacion=ubicacion, tipo_barco=tipo_barco, defaults={'valor': valor})

        juego, _ = Juego.objects.get_or_create(descripcion='Juego Principal', defaults={'duracion_turnos': 5, 'max_turnos': 11})
        turno, created = Turno.objects.get_or_create(turno_id=0, juego=juego)
        if created:
            Subasta.objects.create(turno=turno)

        companias_data = [
            {'nombre': 'UNO', 'password': 'UNO', 'color': 1},
            {'nombre': 'DOS', 'password': 'DOS', 'color': 2},
            {'nombre': 'TRES', 'password': 'TRES', 'color': 3},
            {'nombre': 'CUATRO', 'password': 'CUATRO', 'color': 4},
        ]

        for c in companias_data:
            compania, _ = Compania.objects.get_or_create(
                nombre=c['nombre'],
                juego=juego,
                defaults={
                    'password': c['password'],
                    'ubicacion_terrestre': c['color'],
                    'estado_resultados': 500000000,
                },
            )
            if compania.password != c['password']:
                compania.password = c['password']
                compania.save(update_fields=['password'])
            BarcosXCompania.objects.get_or_create(compania=compania, tipo_barco=chalupa, ubicacion=puerto, defaults={'cantidad': 3})
            BarcosXCompania.objects.get_or_create(compania=compania, tipo_barco=panga, ubicacion=puerto, defaults={'cantidad': 3})
            BarcosXCompania.objects.get_or_create(compania=compania, tipo_barco=pesquero, ubicacion=puerto, defaults={'cantidad': 3})

            Decision.objects.get_or_create(compania=compania, turno=turno)
            Reporte.objects.get_or_create(compania=compania, turno=turno)

        for pez in [robalo, sierra, pargo]:
            Pez.objects.get_or_create(tipo_pez=pez, ubicacion=costa, turno=turno, defaults={'poblacion': 10000})
            Pez.objects.get_or_create(tipo_pez=pez, ubicacion=mar_profundo, turno=turno, defaults={'poblacion': 20000})

        self.stdout.write(self.style.SUCCESS('Datos iniciales configurados exitosamente'))
