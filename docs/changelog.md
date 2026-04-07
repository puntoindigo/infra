# Changelog — Punto Indigo

---

## 2026-04-06/07 — Terminal Proveeduría · SSE + Infraestructura

### remitero (`develop`)

**Performance: reemplazo de polling HTTP con SSE**

| Archivo | Cambio |
|---|---|
| `src/lib/cart-emitter.ts` | Nuevo — singleton EventEmitter para notificaciones de carrito |
| `src/app/api/kiosk/cart/route.ts` | Emite evento en PUT y DELETE |
| `src/app/api/kiosk/cart/stream/route.ts` | Nuevo — SSE endpoint del carrito (`?companyId=X`) |
| `src/app/kiosk/display/page.tsx` | Reemplazado `setInterval` 2s por `EventSource` |
| `src/app/api/credito/kiosco-stream/route.ts` | Nuevo — SSE que reemplaza `/kiosco-status` polling; poll server-side a id cada 500ms |
| `src/components/forms/VerificacionIdentidadPanel.tsx` | Reemplazado polling 1.5s por `EventSource`; eventos: `event` y `timeout` |
| `start` | Nuevo — wrapper CLI (`./remitero/start kiosco|cajero|build|deploy|start|logs`) |

**Latencia anterior → nueva:**
- Carrito tablet: poll 2s → SSE ~0ms
- Identidad cajero: poll cliente 1.5s → SSE ~500ms (poll servidor)

---

### id (`main`)

| Archivo | Cambio |
|---|---|
| `src/app/api/kiosk/state/stream/route.ts` | Nuevo — SSE que reemplaza polling 3s en KioskScreen; poll DB 500ms server-side |
| `src/app/kiosko/join/[stationId]/KioskScreen.tsx` | Reemplazado `setTimeout` loop por `EventSource` |
| `scripts/seed-kiosko-station.mjs` | Nuevo — recrea kiosko-1 con UUID histórico `16efd110-bcc4-4446-92a3-d0de967630b4` |
| `start` | Nuevo — wrapper CLI (`./id/start terminal|panel|seed`) |

**Latencia anterior → nueva:**
- Vista terminal: poll 3s → SSE ~500ms

---

### infra (`main`) — repo nuevo público

**Creado:** https://github.com/puntoindigo/infra

| Archivo | Descripción |
|---|---|
| `ecosystem.config.js` | PM2 — remitero (:8000), ia (:3001), devbot (:3333), vorum-wa, mensajero (:3005), launcher (:80) |
| `start` | CLI central de servicios — `./start [servicio] [comando]` |
| `start-servers.ps1` | Arranque automático Windows vía Task Scheduler |
| `README.md` | Índice completo de 20+ repos organizados por categoría + CLI reference + setup proveeduría |
| `docs/testing-proveeduria.html` | Caso de prueba HTML end-to-end — 6 pasos con URLs, diagramas y tabla de mejoras |
| `docs/changelog.md` | Este archivo |

**CLI `./start` — comandos disponibles:**
```
./start remitero kiosco     → Chrome kiosk → pantalla tablet cliente
./start remitero cajero     → UI cajero en browser
./start remitero start      → levantar en PM2
./start id terminal         → Chrome kiosk → terminal facial
./start id seed             → recrear kiosko-1 en DB
./start all                 → pm2 reload ecosystem.config.js
./start status              → pm2 status
```

---

## Pendientes post-sesión

- [ ] Correr `./id/start seed` → copiar `ID_KIOSK_STATION_ID` en `remitero/.env.local`
- [ ] `cd remitero && npm install && npm run build` → `pm2 reload ecosystem.config.js`
- [ ] Cargar empleados de prueba con `faceDescriptor` en id (tabla `persons`)
- [ ] Verificar flujo facial end-to-end
