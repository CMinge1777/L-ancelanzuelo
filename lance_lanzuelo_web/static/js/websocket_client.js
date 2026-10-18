function initWebSocket(juegoId) {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const ws = new WebSocket(`${protocol}//${window.location.host}/ws/juego/${juegoId}/`);
    
    ws.onmessage = function(e) {
        const data = JSON.parse(e.data);
        console.log('Mensaje WS:', data);
        if(data.event === 'nuevo_turno') {
            alert('¡Nuevo turno iniciado! Sincronizando...');
            window.location.reload();
        }
    };
    
    ws.onclose = function(e) {
        console.error('WS cerrado', e);
        setTimeout(() => initWebSocket(juegoId), 1000);
    };
}
