const canvas = document.getElementById('mapaCanvas');
let gameState = {
    barcos: [],
    turno: 0,
    weatherIntensity: 0
};

const PUERTOS = {
    1: { nombre: 'Necoclí', x: 150, y: 120, color: '#1e90ff', region: 'norte' },
    2: { nombre: 'Turbo', x: 280, y: 350, color: '#32cd32', region: 'este' },
    3: { nombre: 'Bocas de Atrato', x: 220, y: 280, color: '#ff4500', region: 'centro' },
    4: { nombre: 'Acandí', x: 80, y: 80, color: '#ffd700', region: 'noroeste' }
};

const UBICACIONES = {
    0: { nombre: 'PUERTO', x: 0, y: 0 },
    1: { nombre: 'COSTA', x: 180, y: 200 },
    2: { nombre: 'MAR PROFUNDO', x: 380, y: 250 }
};

function fetchTurnInfo() {
    fetch('/api/turno-info/')
        .then((response) => response.json())
        .then((data) => {
            const turno = data.turno || 0;
            const estado = (turno % 2 === 0 || turno % 3 === 0) ? 'Noticias activas' : 'Tránsito normal';
            const riesgo = turno > 0 && (turno % 3 === 0) ? 'Medio' : 'Bajo';

            gameState.turno = turno;
            gameState.weatherIntensity = (turno % 3 === 0) ? 1 : 0.25;

            const turnoActual = document.getElementById('turnoActual');
            const turnoBadge = document.getElementById('turnoBadge');
            const estadoMar = document.getElementById('estadoMar');
            const riesgoMar = document.getElementById('riesgoMar');

            if (turnoActual) turnoActual.textContent = turno;
            if (turnoBadge) turnoBadge.textContent = turno;
            if (estadoMar) estadoMar.textContent = estado;
            if (riesgoMar) riesgoMar.textContent = riesgo;
        })
        .catch(() => {
            if (document.getElementById('turnoActual')) document.getElementById('turnoActual').textContent = gameState.turno;
        });
}

function bindQuickActions() {
    const buttons = document.querySelectorAll('.action-card');
    buttons.forEach((button) => {
        button.addEventListener('click', () => {
            const action = button.dataset.action;
            if (action === 'mercado') {
                window.location.href = '/compania/';
            }
            if (action === 'subasta') {
                window.location.href = '/compania/';
                setTimeout(() => {
                    const modal = document.getElementById('modalContainer');
                    if (!modal) {
                        setTimeout(() => window.openModal && window.openModal('subasta'), 200);
                    }
                }, 200);
            }
            if (action === 'noticias') {
                window.location.href = '/compania/';
                setTimeout(() => window.openModal && window.openModal('noticias'), 200);
            }
            if (action === 'region') {
                window.location.href = '/compania/';
                setTimeout(() => window.openModal && window.openModal('region'), 200);
            }
        });
    });
}

function drawMap() {
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    let frameCount = 0;
    
    function draw() {
        frameCount++;
        
        const skyGradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
        skyGradient.addColorStop(0, '#061a2d');
        skyGradient.addColorStop(0.45, '#0b4478');
        skyGradient.addColorStop(1, '#0d6fa8');
        ctx.fillStyle = skyGradient;
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        ctx.fillStyle = '#2c6b42';
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.lineTo(200, 0);
        ctx.lineTo(180, 150);
        ctx.lineTo(100, 180);
        ctx.lineTo(0, 120);
        ctx.closePath();
        ctx.fill();
        
        ctx.fillStyle = '#468d5d';
        ctx.beginPath();
        ctx.moveTo(0, 120);
        ctx.lineTo(100, 180);
        ctx.lineTo(250, 320);
        ctx.lineTo(0, 400);
        ctx.closePath();
        ctx.fill();
        
        ctx.strokeStyle = '#d7b179';
        ctx.lineWidth = 4;
        ctx.beginPath();
        ctx.moveTo(200, 0);
        ctx.bezierCurveTo(220, 80, 200, 160, 180, 200);
        ctx.stroke();
        
        ctx.fillStyle = 'rgba(100, 180, 200, 0.18)';
        ctx.beginPath();
        ctx.moveTo(180, 200);
        ctx.bezierCurveTo(200, 220, 280, 240, 320, 300);
        ctx.lineTo(250, 320);
        ctx.bezierCurveTo(200, 280, 150, 240, 180, 200);
        ctx.closePath();
        ctx.fill();
        ctx.strokeStyle = '#4da6d9';
        ctx.lineWidth = 2;
        ctx.stroke();
        
        ctx.fillStyle = 'rgba(30, 100, 200, 0.12)';
        ctx.fillRect(320, 200, 280, 280);
        ctx.strokeStyle = '#1e64c8';
        ctx.lineWidth = 2;
        ctx.setLineDash([5, 5]);
        ctx.strokeRect(320, 200, 280, 280);
        ctx.setLineDash([]);
        
        Object.keys(PUERTOS).forEach((id) => {
            const puerto = PUERTOS[id];
            ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
            ctx.beginPath();
            ctx.arc(puerto.x + 3, puerto.y + 3, 12, 0, Math.PI * 2);
            ctx.fill();
            ctx.fillStyle = puerto.color;
            ctx.beginPath();
            ctx.arc(puerto.x, puerto.y, 12, 0, Math.PI * 2);
            ctx.fill();
            ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
            ctx.beginPath();
            ctx.arc(puerto.x - 3, puerto.y - 3, 4, 0, Math.PI * 2);
            ctx.fill();
            ctx.fillStyle = '#fff';
            ctx.font = 'bold 11px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(puerto.nombre, puerto.x, puerto.y + 28);
        });

        const waveOffset = Math.sin(frameCount * 0.02) * 2;
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.12)';
        ctx.lineWidth = 1;
        for (let i = 0; i < 4; i++) {
            ctx.beginPath();
            ctx.arc(320 + (i * 40), 240 + waveOffset, 30 + i * 15, 0, Math.PI * 2);
            ctx.stroke();
        }

        if (gameState.weatherIntensity > 0.6) {
            ctx.fillStyle = `rgba(255, 120, 0, ${gameState.weatherIntensity * 0.45})`;
            ctx.fillRect(340, 220, 120, 95);
            ctx.fillStyle = '#ffe066';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('⚠ TORMENTA', 400, 275);
        }

        const fleetColors = ['#6ae3ff', '#ffd166', '#8ef0c7'];
        for (let i = 0; i < 12; i++) {
            const x = 120 + (i * 30) % 560;
            const y = 120 + (i * 19) % 220 + Math.sin(frameCount * 0.04 + i) * 12;
            ctx.fillStyle = fleetColors[i % fleetColors.length];
            ctx.fillRect(x, y, 10, 5);
            ctx.fillStyle = '#d8f3ff';
            ctx.fillRect(x + 2, y - 3, 6, 3);
        }
        
        ctx.fillStyle = 'rgba(0, 0, 0, 0.45)';
        ctx.fillRect(10, 420, 780, 70);
        
        ctx.fillStyle = '#4da6d9';
        ctx.font = 'bold 12px Arial';
        ctx.textAlign = 'left';
        ctx.fillText('COSTA - Zona de pesca cercana', 20, 440);
        ctx.fillText('MAR PROFUNDO - Zona de alto riesgo y alta recompensa', 20, 460);
        ctx.fillText('PUERTO - Punto de partida y resguardo', 20, 480);
        
        ctx.fillStyle = '#3bd9ff';
        ctx.font = 'bold 14px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('GOLFO DE URABÁ - Lance L\'anzuelo', 400, 30);
        
        requestAnimationFrame(draw);
    }
    draw();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        drawMap();
        fetchTurnInfo();
    });
} else {
    drawMap();
    fetchTurnInfo();
}
