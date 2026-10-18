from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('admin-panel/', views.admin_panel, name='admin_panel'),
    path('produccion/', views.juego_produccion, name='juego_produccion'),
    path('golfo/', views.golfo_view, name='golfo'),
    path('compania/', views.compania_view, name='compania'),
    path('api/estado-golfo/', views.api_estado_golfo, name='api_estado_golfo'),
    path('api/estado-compania/', views.api_estado_compania, name='api_estado_compania'),
    path('api/comprar-barcos/', views.comprar_barcos_view, name='comprar_barcos'),
    path('api/apostar-subasta/', views.apostar_subasta_view, name='apostar_subasta'),
    path('api/banco/', views.api_banco, name='api_banco'),
    path('api/estadisticas/', views.api_estadisticas, name='api_estadisticas'),
    path('api/mercado/', views.api_mercado, name='api_mercado'),
    path('api/posicion/', views.api_posicion, name='api_posicion'),
    path('api/captura-region/', views.api_captura_por_region, name='api_captura_region'),
    path('api/subasta/', views.api_subasta, name='api_subasta'),
    path('api/noticias/', views.api_noticias, name='api_noticias'),
    path('api/turno-info/', views.api_turno_info, name='api_turno_info'),
    path('admin/metrics/', views.admin_metricas, name='admin_metricas'),
    path('admin/avanzar-turno/', views.admin_avanzar_turno, name='admin_avanzar_turno'),
    path('admin/nuevo-juego/', views.admin_nuevo_juego, name='admin_nuevo_juego'),
]
