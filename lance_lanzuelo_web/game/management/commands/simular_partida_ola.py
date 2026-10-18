from django.core.management.base import BaseCommand
from game.models import (
    BarcosXCompania,
    Compania,
    CostoOperativo,
    Decision,
    Juego,
    Mensaje,
    Pez,
    Reporte,
    Subasta,
    TipoBarco,
    TipoPez,
    Turno,
    Ubicacion,
)


class Command(BaseCommand):
    help = 'Simula una partida con tres compañías en mar profundo, una ola de agua y análisis de tasa de crecimiento.'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('\n=== Simulación Lance L\'anzuelo ===\n'))

        puerto, _ = Ubicacion.objects.get_or_create(id=0, defaults={'nombre': 'PUERTO'})
        costa, _ = Ubicacion.objects.get_or_create(id=1, defaults={'nombre': 'COSTA'})
        profundo, _ = Ubicacion.objects.get_or_create(id=2, defaults={'nombre': 'MAR PROFUNDO'})

        chalupa, _ = TipoBarco.objects.get_or_create(nombre='Chalupa', defaults={'precio': 3000000, 'capacidad': 900})
        panga, _ = TipoBarco.objects.get_or_create(nombre='Panga', defaults={'precio': 30000000, 'capacidad': 2000})
        pesquero, _ = TipoBarco.objects.get_or_create(nombre='Barco Pesquero', defaults={'precio': 80000000, 'capacidad': 9000})

        robalo, _ = TipoPez.objects.get_or_create(nombre='Robalo', defaults={'precio': 3800})
        sierra, _ = TipoPez.objects.get_or_create(nombre='Sierra', defaults={'precio': 3000})
        pargo, _ = TipoPez.objects.get_or_create(nombre='Pargo', defaults={'precio': 6000})

        for ubicacion, tipo_barco, valor in [
            (puerto, chalupa, 100000),
            (puerto, panga, 300000),
            (puerto, pesquero, 500000),
            (costa, chalupa, 2000000),
            (costa, panga, 5000000),
            (costa, pesquero, 10000000),
            (profundo, chalupa, 100000000),
            (profundo, panga, 10000000),
            (profundo, pesquero, 25000000),
        ]:
            CostoOperativo.objects.get_or_create(ubicacion=ubicacion, tipo_barco=tipo_barco, defaults={'valor': valor})

        juego = Juego.objects.create(descripcion='Simulación de 3 compañías en mar profundo', duracion_turnos=5, max_turnos=4)
        company_names = [('ALFA', 1), ('BETA', 2), ('GAMMA', 3)]
        companies = []

        for nombre, ubicacion_terrestre in company_names:
            compania = Compania.objects.create(
                nombre=nombre,
                password='simulacion123',
                juego=juego,
                ubicacion_terrestre=ubicacion_terrestre,
                estado_resultados=500000000,
            )
            companies.append(compania)

            for tipo_barco in [chalupa, panga, pesquero]:
                BarcosXCompania.objects.update_or_create(
                    compania=compania,
                    tipo_barco=tipo_barco,
                    ubicacion=profundo,
                    defaults={'cantidad': 3},
                )

                if tipo_barco == chalupa:
                    nombre_barco = 'chalupa'
                elif tipo_barco == panga:
                    nombre_barco = 'panga'
                else:
                    nombre_barco = 'pesquero'

                self.stdout.write(f"{nombre}: {nombre_barco} en MAR PROFUNDO -> 3 unidades")

        turnos = []
        for turno_id in range(1, 4):
            turno = Turno.objects.create(turno_id=turno_id, juego=juego)
            turnos.append(turno)
            Subasta.objects.filter(turno=turno).delete()
            Subasta.objects.create(turno=turno)

            for compania in companies:
                Decision.objects.get_or_create(
                    compania=compania,
                    turno=turno,
                    defaults={
                        'chalupas_costa': 0,
                        'chalupas_mar_profundo': 0,
                        'chalupas_puerto': 3,
                        'pangas_costa': 0,
                        'pangas_mar_profundo': 0,
                        'pangas_puerto': 3,
                        'pesqueros_costa': 0,
                        'pesqueros_mar_profundo': 0,
                        'pesqueros_puerto': 3,
                    },
                )

                Reporte.objects.get_or_create(
                    compania=compania,
                    turno=turno,
                    defaults={
                        'captura_robalo_costa': 0,
                        'captura_robalo_mar_profundo': 0,
                        'captura_sierra_costa': 0,
                        'captura_sierra_mar_profundo': 0,
                        'captura_pargo_costa': 0,
                        'captura_pargo_mar_profundo': 0,
                        'balance_general': 0,
                    },
                )

                for pez in [robalo, sierra, pargo]:
                    Pez.objects.get_or_create(
                        tipo_pez=pez,
                        ubicacion=profundo,
                        turno=turno,
                        defaults={'poblacion': 15000 + turno_id * 2500},
                    )

                compania.estado_resultados -= 150000000
                compania.save(update_fields=['estado_resultados'])

                self.stdout.write(
                    self.style.WARNING(
                        f"Turno {turno_id}: {compania.nombre} permanece en parqueo en mar profundo; costo operativo aplicado. Balance: ${compania.estado_resultados:,}"
                    )
                )

        self.stdout.write(self.style.NOTICE('\nOla de agua y chubascos en mar profundo'))
        for compania in companies:
            for tipo_barco in [chalupa, panga, pesquero]:
                BarcosXCompania.objects.filter(compania=compania, tipo_barco=tipo_barco, ubicacion=profundo).update(cantidad=0)

            compania.estado_resultados = 0
            compania.save(update_fields=['estado_resultados'])

            Mensaje.objects.create(
                turno=turnos[-1],
                texto=f'{compania.nombre} pierde toda la flota en mar profundo por ola de agua con chubascos.',
            )

            self.stdout.write(
                self.style.ERROR(
                    f"{compania.nombre}: flota destruida en mar profundo y balance final = ${compania.estado_resultados:,}"
                )
            )

        self.stdout.write('\n--- Análisis de tasa de crecimiento ---')
        initial_value = 500000000
        for compania in companies:
            final_value = compania.estado_resultados
            growth_rate = ((final_value - initial_value) / initial_value) * 100
            self.stdout.write(
                f"{compania.nombre}: balance inicial ${initial_value:,} | balance final ${final_value:,} | tasa de crecimiento {growth_rate:.2f}%"
            )

        total_initial = len(companies) * initial_value
        total_final = sum(c.estado_resultados for c in companies)
        total_growth = ((total_final - total_initial) / total_initial) * 100
        self.stdout.write(
            f"Total del mercado: inicial ${total_initial:,} | final ${total_final:,} | tasa total {total_growth:.2f}%"
        )
        self.stdout.write(self.style.SUCCESS('\nSimulación completada.'))
