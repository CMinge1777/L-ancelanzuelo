// Modal management
let currentModal = null;

function openModal(id) {
    currentModal = id;
    
    switch(id) {
        case 'banco':
            loadBanco();
            break;
        case 'stats':
            loadEstadisticas();
            break;
        case 'mercado':
            loadMercado();
            break;
        case 'posicion':
            loadPosicion();
            break;
        case 'subasta':
            loadSubasta();
            break;
        case 'noticias':
            loadNoticias();
            break;
        case 'region':
            loadRegion();
            break;
    }
}

function loadBanco() {
    fetch('/api/banco/')
        .then(r => r.json())
        .then(data => {
            let content = `
                <h3>🏦 Banco</h3>
                <p><strong>Balance Actual:</strong> $${data.balance.toLocaleString()}</p>
                <h4>Últimas Transacciones:</h4>
                <ul style="color: #3bd9ff;">
            `;
            if(data.historial.length === 0) {
                content += '<li>Sin transacciones registradas</li>';
            } else {
                data.historial.forEach(tx => {
                    content += `<li>Turno ${tx.turno}: $${tx.ingresos.toLocaleString()}</li>`;
                });
            }
            content += '</ul>';
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function loadEstadisticas() {
    fetch('/api/estadisticas/')
        .then(r => r.json())
        .then(data => {
            let content = `
                <h3>📊 Estadísticas</h3>
                <table style="width:100%; color:#3bd9ff;">
                    <tr>
                        <th>Turno</th>
                        <th>Captura Total (kg)</th>
                        <th>Ingresos ($)</th>
                    </tr>
            `;
            if(data.stats.length === 0) {
                content += '<tr><td colspan="3">Sin datos disponibles</td></tr>';
            } else {
                data.stats.forEach(stat => {
                    content += `<tr>
                        <td>${stat.turno}</td>
                        <td>${stat.captura_total.toLocaleString()}</td>
                        <td>$${stat.ingresos.toLocaleString()}</td>
                    </tr>`;
                });
            }
            content += '</table>';
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function loadMercado() {
    fetch('/api/mercado/')
        .then(r => r.json())
        .then(data => {
            let content = `
                <h3>🚤 Mercado de Barcos</h3>
                <div style="display:grid; gap:10px;">
            `;
            data.barcos.forEach(barco => {
                content += `
                    <div style="background:#1a2a42; padding:15px; border-left:4px solid #3bd9ff;">
                        <strong>${barco.nombre}</strong><br>
                        Precio: $${barco.precio.toLocaleString()}<br>
                        Capacidad: ${barco.capacidad} kg
                        <div style="margin-top:10px;">
                            <input id="qty-${barco.nombre}" type="number" min="1" value="1" style="width:70px; margin-right:8px;">
                            <button class="button" onclick="comprarBarco('${barco.nombre}')">Comprar</button>
                        </div>
                    </div>
                `;
            });
            content += '</div>';
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function comprarBarco(nombre) {
    const input = document.getElementById('qty-' + nombre);
    const cantidad = input ? input.value : 1;
    fetch('/api/comprar-barcos/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRFToken': getCookie('csrftoken') },
        body: `nombre=${encodeURIComponent(nombre)}&cantidad=${encodeURIComponent(cantidad)}`
    })
    .then(r => r.json())
    .then(data => {
        if (data.ok) {
            alert(data.message + ' · Nuevo balance: $' + Number(data.nuevo_balance).toLocaleString());
            loadMercado();
        } else {
            alert(data.message);
        }
    })
    .catch(err => alert('Error: ' + err));
}

function updateCompanySummary(summary) {
    if (!summary) return;
    const capture = document.getElementById('companySummaryCapture');
    const cost = document.getElementById('companySummaryCost');
    const income = document.getElementById('companySummaryIncome');

    if (capture) capture.textContent = `${Number(summary.captura_total || 0).toLocaleString()} kg`;
    if (cost) cost.textContent = `$ ${Number(summary.costo_operativo || 0).toLocaleString()}`;
    if (income) income.textContent = `$ ${Number(summary.ingresos_estimados || 0).toLocaleString()}`;
}

function loadPosicion() {
    fetch('/api/posicion/')
        .then(r => r.json())
        .then(data => {
            updateCompanySummary(data.resumen || window.companySummary);

            // Construir tabla de inventario
            let inventarioHTML = `
                <h3>📊 Inventario Disponible</h3>
                <table style="width:100%; color:#3bd9ff; margin-bottom:20px;">
                    <tr><th>Tipo de Barco</th><th>Total</th></tr>
                    <tr><td>Chalupas</td><td>${data.inventario.chalupas}</td></tr>
                    <tr><td>Pangas</td><td>${data.inventario.pangas}</td></tr>
                    <tr><td>Barcos Pesqueros</td><td>${data.inventario.pesqueros}</td></tr>
                </table>
            `;

            let resumenHTML = `
                <h3>🐟 Resumen del turno</h3>
                <table style="width:100%; color:#3bd9ff; margin-bottom:20px;">
                    <tr><th>Concepto</th><th>Valor</th></tr>
                    <tr><td>Captura estimada</td><td>${Number((data.resumen || window.companySummary || {}).captura_total || 0).toLocaleString()} kg</td></tr>
                    <tr><td>Costo operativo</td><td>$${Number((data.resumen || window.companySummary || {}).costo_operativo || 0).toLocaleString()}</td></tr>
                    <tr><td>Ingresos estimados</td><td>$${Number((data.resumen || window.companySummary || {}).ingresos_estimados || 0).toLocaleString()}</td></tr>
                </table>
            `;
            
            // Construir tabla de tasas por ubicación
            let tasasHTML = `
                <h3>🐟 Tasas de Pesca y Nacimiento</h3>
                <table style="width:100%; color:#3bd9ff; margin-bottom:20px;">
                    <tr>
                        <th>Ubicación</th>
                        <th>Tasa Pesca</th>
                        <th>Tasa Nacimiento</th>
                    </tr>
                    <tr>
                        <td><strong>Costa</strong></td>
                        <td>${data.tasas.costa.pesca.toFixed(2)}x</td>
                        <td>${(data.tasas.costa.nacimiento * 100).toFixed(0)}%</td>
                    </tr>
                    <tr>
                        <td><strong>Mar Profundo</strong></td>
                        <td>${data.tasas.mar_profundo.pesca.toFixed(2)}x</td>
                        <td>${(data.tasas.mar_profundo.nacimiento * 100).toFixed(0)}%</td>
                    </tr>
                    <tr>
                        <td><strong>Puerto</strong></td>
                        <td>${data.tasas.puerto.pesca.toFixed(2)}x</td>
                        <td>${(data.tasas.puerto.nacimiento * 100).toFixed(0)}%</td>
                    </tr>
                </table>
            `;
            
            // Construir formulario de posicionamiento
            let formHTML = `
                <h3>🗺️ Posicionar Barcos</h3>
                <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; margin-top:12px;">
                    <!-- Chalupas -->
                    <div style="background:#1a2a42; padding:15px; border-radius:4px;">
                        <h4 style="color:#ffd166; margin-top:0;">Chalupas (Inv: ${data.inventario.chalupas})</h4>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Puerto</label><br>
                            <input id="chalupas_puerto" type="number" min="0" max="${data.inventario.chalupas}" value="${data.chalupas_puerto || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Costa</label><br>
                            <input id="chalupas_costa" type="number" min="0" max="${data.inventario.chalupas}" value="${data.chalupas_costa || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Mar Profundo</label><br>
                            <input id="chalupas_mar_profundo" type="number" min="0" max="${data.inventario.chalupas}" value="${data.chalupas_mar_profundo || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                    </div>
                    
                    <!-- Pangas -->
                    <div style="background:#1a2a42; padding:15px; border-radius:4px;">
                        <h4 style="color:#70e0a5; margin-top:0;">Pangas (Inv: ${data.inventario.pangas})</h4>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Puerto</label><br>
                            <input id="pangas_puerto" type="number" min="0" max="${data.inventario.pangas}" value="${data.pangas_puerto || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Costa</label><br>
                            <input id="pangas_costa" type="number" min="0" max="${data.inventario.pangas}" value="${data.pangas_costa || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Mar Profundo</label><br>
                            <input id="pangas_mar_profundo" type="number" min="0" max="${data.inventario.pangas}" value="${data.pangas_mar_profundo || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                    </div>
                    
                    <!-- Pesqueros -->
                    <div style="background:#1a2a42; padding:15px; border-radius:4px;">
                        <h4 style="color:#ff7a59; margin-top:0;">Pesqueros (Inv: ${data.inventario.pesqueros})</h4>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Puerto</label><br>
                            <input id="pesqueros_puerto" type="number" min="0" max="${data.inventario.pesqueros}" value="${data.pesqueros_puerto || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Costa</label><br>
                            <input id="pesqueros_costa" type="number" min="0" max="${data.inventario.pesqueros}" value="${data.pesqueros_costa || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                        <div style="margin:10px 0;">
                            <label style="color:#7dd3fc; font-size:12px;">Mar Profundo</label><br>
                            <input id="pesqueros_mar_profundo" type="number" min="0" max="${data.inventario.pesqueros}" value="${data.pesqueros_mar_profundo || 0}" style="width:100%; padding:6px; background:#0a1628; color:#3bd9ff; border:1px solid #3bd9ff;">
                        </div>
                    </div>
                </div>
            `;
            
            let content = inventarioHTML + resumenHTML + tasasHTML + formHTML;
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function guardarPosicion() {
    const datos = {
        chalupas_puerto: document.getElementById('chalupas_puerto')?.value || 0,
        chalupas_costa: document.getElementById('chalupas_costa')?.value || 0,
        chalupas_mar_profundo: document.getElementById('chalupas_mar_profundo')?.value || 0,
        pangas_puerto: document.getElementById('pangas_puerto')?.value || 0,
        pangas_costa: document.getElementById('pangas_costa')?.value || 0,
        pangas_mar_profundo: document.getElementById('pangas_mar_profundo')?.value || 0,
        pesqueros_puerto: document.getElementById('pesqueros_puerto')?.value || 0,
        pesqueros_costa: document.getElementById('pesqueros_costa')?.value || 0,
        pesqueros_mar_profundo: document.getElementById('pesqueros_mar_profundo')?.value || 0,
    };
    
    const params = new URLSearchParams(datos);
    fetch('/api/posicion/', {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRFToken': getCookie('csrftoken') },
        body: params.toString()
    })
    .then(r => r.json())
    .then(data => {
        if (data.ok) {
            updateCompanySummary(data.resumen || window.companySummary);
            alert('Posicionamiento actualizado correctamente');
            loadPosicion();
        } else {
            alert('Error: ' + data.message);
        }
    })
    .catch(err => alert('Error: ' + err));
}

function loadSubasta() {
    fetch('/api/subasta/')
        .then(r => r.json())
        .then(data => {
            let content = `
                <h3>🔨 Subasta Actual</h3>
                <p><strong>Estado:</strong> ${data.abierta ? 'ABIERTA' : 'CERRADA'}</p>
                <p><strong>Costo Base:</strong> $${data.costo_base.toLocaleString()}</p>
                <p><strong>Mi Oferta:</strong> ${data.mi_oferta ? '$' + data.mi_oferta.toLocaleString() : 'Sin oferta'}</p>
                <p><strong>Artículos:</strong></p>
                <ul style="color:#3bd9ff;">
                    <li>${data.num_chalupas} Chalupas</li>
                    <li>${data.num_pangas} Pangas</li>
                    <li>${data.num_pesqueros} Barcos Pesqueros</li>
                </ul>
                <div style="margin-top:12px;">
                    <input id="subasta-valor" type="number" min="1" value="${data.costo_base || 1000000}" style="width:140px; margin-right:8px;">
                    <button class="button" onclick="apostarSubasta()">Aportar en la subasta</button>
                </div>
            `;
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function apostarSubasta() {
    const valor = document.getElementById('subasta-valor')?.value || 0;
    fetch('/api/apostar-subasta/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', 'X-CSRFToken': getCookie('csrftoken') },
        body: `valor=${encodeURIComponent(valor)}`
    })
    .then(r => r.json())
    .then(data => {
        if (data.ok) {
            alert('Oferta registrada: $' + Number(data.oferta).toLocaleString());
            loadSubasta();
        } else {
            alert(data.message);
        }
    })
    .catch(err => alert('Error: ' + err));
}

function loadNoticias() {
    fetch('/api/noticias/')
        .then(r => r.json())
        .then(data => {
            let content = `<h3>📰 Noticias</h3>`;
            if(data.noticias.length === 0) {
                content += '<p>Sin noticias disponibles</p>';
            } else {
                data.noticias.forEach(noticia => {
                    content += `
                        <div style="background:#1a2a42; padding:10px; margin:10px 0; border-left:4px solid #3bd9ff;">
                            <strong>Turno ${noticia.turno}:</strong> ${noticia.texto}
                        </div>
                    `;
                });
            }
            content += '<p style="color:#7dd3fc;">Las noticias aparecen cada 2 o 3 corridas según el turno activo.</p>';
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function loadRegion() {
    fetch('/api/captura-region/')
        .then(r => r.json())
        .then(data => {
            let content = `
                <h3>🎣 Captura por región</h3>
                <p><strong>Zona Costa:</strong> ${Number(data.costa).toLocaleString()} kg (${Number(data.porcentajes?.costa ?? 0).toFixed(2)}%)</p>
                <p><strong>Mar Profundo:</strong> ${Number(data.mar_profundo).toLocaleString()} kg (${Number(data.porcentajes?.mar_profundo ?? 0).toFixed(2)}%)</p>
                <p><strong>Total:</strong> ${Number(data.total).toLocaleString()} kg</p>
                <div style="background:#1a2a42; padding:12px; margin-top:10px; border-left:4px solid #66d9ef;">
                    <strong>Validación:</strong> la producción se compara por región para mostrar si la pesca es más rentable en costa o en mar profundo.
                </div>
            `;
            showModal(content);
        })
        .catch(err => alert('Error: ' + err));
}

function getCookie(name) {
    const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    return match ? decodeURIComponent(match[2]) : '';
}

function showModal(content) {
    let modal = document.getElementById('modalContainer');
    if(!modal) {
        modal = document.createElement('div');
        modal.id = 'modalContainer';
        modal.style.cssText = `
            position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.7); display:flex; align-items:center;
            justify-content:center; z-index:1000;
        `;
        document.body.appendChild(modal);
    }
    
    let box = document.querySelector('.modal-box');
    if(!box) {
        box = document.createElement('div');
        box.className = 'modal-box';
        box.style.cssText = `
            background:#1a2a42; padding:30px; border-radius:8px;
            max-width:600px; width:90%; border:2px solid #3bd9ff;
            color:#e0e0e0; max-height:80vh; overflow-y:auto;
        `;
        modal.appendChild(box);
    }
    
    let buttons = `<br><button onclick="closeModal()" class="button">Cerrar</button>`;
    if (currentModal === 'posicion') {
        buttons = `<br><button onclick="guardarPosicion()" class="button primary">Guardar Posicionamiento</button> <button onclick="closeModal()" class="button">Cancelar</button>`;
    }
    
    box.innerHTML = content + buttons;
    modal.style.display = 'flex';
}

function closeModal() {
    let modal = document.getElementById('modalContainer');
    if(modal) modal.style.display = 'none';
}
