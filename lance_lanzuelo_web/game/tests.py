from django.contrib.auth import get_user_model
from django.core.management import call_command
from django.test import TestCase
from django.urls import reverse

from . import game_logic
from .models import (
    BarcosXCompania,
    Compania,
    Juego,
    Oferta,
    Reporte,
    Subasta,
    TipoBarco,
    Turno,
    Ubicacion,
)


class GameAccessTests(TestCase):
    def test_setup_inicial_uses_default_compania_credentials(self):
        call_command('setup_inicial')

        juego = Juego.objects.first()
        compania = Compania.objects.get(nombre='UNO', juego=juego)

        response = self.client.post(
            reverse('login'),
            {'nombre': 'UNO', 'password': 'UNO', 'juego_id': str(juego.id)},
            follow=False,
        )

        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, reverse('golfo'))
        self.assertEqual(self.client.session.get('compania_id'), compania.id)

    def test_admin_panel_requires_staff_access(self):
        User = get_user_model()
        user = User.objects.create_user(username='admin', password='admin123', is_staff=True)
        self.client.force_login(user)

        response = self.client.get(reverse('admin_panel'))

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Administración del juego')

    def test_production_game_view_requires_company_session(self):
        call_command('setup_inicial')
        juego = Juego.objects.first()
        compania = Compania.objects.get(nombre='UNO', juego=juego)
        session = self.client.session
        session['compania_id'] = compania.id
        session.save()

        response = self.client.get(reverse('juego_produccion'))

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Pantalla de juego en producción')


class GameEconomyInteractionTests(TestCase):
    def setUp(self):
        call_command('setup_inicial')
        self.juego = Juego.objects.first()
        self.compania = Compania.objects.get(nombre='UNO', juego=self.juego)
        self.compania.estado_resultados = 500000000
        self.compania.save(update_fields=['estado_resultados'])
        self.turno = Turno.objects.get(turno_id=0, juego=self.juego)
        self.puerto = Ubicacion.objects.get(id=0)
        self.tipo = TipoBarco.objects.get(nombre='Chalupa')

    def test_buying_more_boats_updates_inventory_and_balance(self):
        result = game_logic.comprar_barcos(self.compania, 'Chalupa', 2)

        self.assertTrue(result['ok'])
        self.assertEqual(
            BarcosXCompania.objects.get(compania=self.compania, tipo_barco=self.tipo, ubicacion=self.puerto).cantidad,
            5,
        )
        self.assertEqual(self.compania.estado_resultados, 500000000 - (2 * self.tipo.precio))

    def test_auction_bid_is_recorded(self):
        subasta = Subasta.objects.get(turno=self.turno)
        subasta.costo_base = 12000000
        subasta.num_chalupas = 2
        subasta.num_pangas = 1
        subasta.num_pesqueros = 1
        subasta.save(update_fields=['costo_base', 'num_chalupas', 'num_pangas', 'num_pesqueros'])

        result = game_logic.apostar_en_subasta(self.compania, 15000000, self.turno)

        self.assertTrue(result['ok'])
        self.assertEqual(Oferta.objects.filter(compania=self.compania, subasta=subasta).count(), 1)
        self.assertEqual(Oferta.objects.get(compania=self.compania, subasta=subasta).valor, 15000000)

    def test_news_generation_uses_turn_cycle(self):
        self.assertFalse(game_logic.debe_generar_noticias(1))
        self.assertTrue(game_logic.debe_generar_noticias(2))
        self.assertTrue(game_logic.debe_generar_noticias(3))

    def test_regional_capture_summary_is_calculated(self):
        turno = Turno.objects.create(turno_id=4, juego=self.juego)
        Reporte.objects.create(
            compania=self.compania,
            turno=turno,
            captura_robalo_costa=100,
            captura_robalo_mar_profundo=200,
            captura_sierra_costa=50,
            captura_sierra_mar_profundo=150,
            captura_pargo_costa=75,
            captura_pargo_mar_profundo=100,
        )

        reporte = game_logic.resumen_captura_por_region(self.compania, turno)

        self.assertEqual(reporte['costa'], 225)
        self.assertEqual(reporte['mar_profundo'], 450)
        self.assertEqual(reporte['total'], 675)
        self.assertAlmostEqual(reporte['porcentajes']['costa'], 33.33, places=2)
        self.assertAlmostEqual(reporte['porcentajes']['mar_profundo'], 66.67, places=2)

    def test_positioning_api_returns_fishing_and_cost_summary(self):
        session = self.client.session
        session['compania_id'] = self.compania.id
        session.save()

        Decision = __import__('game.models', fromlist=['Decision']).Decision
        Decision.objects.create(
            compania=self.compania,
            turno=self.turno,
            chalupas_costa=2,
            pangas_costa=1,
            pesqueros_costa=1,
        )

        response = self.client.get(reverse('api_posicion'))

        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertIn('resumen', payload)
        self.assertGreater(payload['resumen']['captura_total'], 0)
        self.assertGreater(payload['resumen']['costo_operativo'], 0)
        self.assertGreater(payload['resumen']['ingresos_estimados'], 0)
