import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

class JuegoConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.juego_id = self.scope['url_route']['kwargs']['juego_id']
        self.group_name = f'juego_{self.juego_id}'
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()
    
    async def disconnect(self, code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)
    
    async def receive(self, text_data):
        pass  # clientes no envían datos via WS
    
    async def turno_actualizado(self, event):
        await self.send(text_data=json.dumps(event['data']))

def broadcast_turno_actualizado(juego_id, data):
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f'juego_{juego_id}',
        {'type': 'turno_actualizado', 'data': data}
    )
