from django.urls import re_path
from game import consumers

websocket_urlpatterns = [
    re_path(r'ws/juego/(?P<juego_id>\d+)/$', consumers.JuegoConsumer.as_asgi()),
]
