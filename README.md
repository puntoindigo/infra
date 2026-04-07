# infra — Punto Indigo

Infraestructura local: PM2, CLI de servicios y arranque automático.

**Org:** [github.com/puntoindigo](https://github.com/puntoindigo)

---

## `./start` — CLI de servicios

Script central de atajos. Desde el directorio raíz (`projects/`):

```bash
./start [servicio] [comando] [args]
```

Cada proyecto también tiene su propio wrapper:

```bash
./remitero/start [comando]
./id/start [comando]
./ia/start [comando]
./devbot-orchestrator/start [comando]
```

---

### remitero

| Comando | Acción |
|---|---|
| `./remitero/start kiosco` | Abre Chrome en kiosk mode → pantalla tablet cliente (`localhost:8000/kiosk/display`) |
| `./remitero/start cajero` | Abre UI del cajero en browser (`localhost:8000`) |
| `./remitero/start start` | Levanta el servicio en PM2 (puerto 8000) |
| `./remitero/start stop` | Detiene el proceso PM2 |
| `./remitero/start restart` | Reinicia el proceso PM2 |
| `./remitero/start build` | `npm run build` (necesario antes de levantar en PM2) |
| `./remitero/start deploy` | Deploy a Vercel (rama develop) |
| `./remitero/start logs` | Logs PM2 en vivo |

El `companyId` para la pantalla kiosco se lee de `remitero/.env.local` (`PROVEEDURIA_COMPANY_ID`). Si no está definido usa el de la proveeduría por defecto.

---

### id

| Comando | Acción |
|---|---|
| `./id/start terminal` | Abre Chrome kiosk → terminal reconocimiento facial (`id.puntoindigo.com/kiosko/join/[stationId]`) |
| `./id/start terminal [stationId]` | Igual, con stationId explícito |
| `./id/start panel` | Abre dashboard admin en browser |
| `./id/start seed` | Recrea la estación kiosko-1 en DB (`scripts/seed-kiosko-station.mjs`) |

El `stationId` se lee de `remitero/.env.local` (`ID_KIOSK_STATION_ID`).

---

### ia / devbot

```bash
./ia/start start|stop|restart|build|logs
./devbot-orchestrator/start start|stop|restart|admin|logs
```

---

### General

```bash
./start all          # pm2 reload ecosystem.config.js — levanta todo
./start status       # pm2 status
./start pm2 reload   # recargar ecosystem sin reiniciar procesos
./start pm2 save     # guardar lista de procesos activos
./start pm2 logs ia  # logs de un servicio específico
```

---

## Servicios PM2 (`ecosystem.config.js`)

| Nombre | Puerto | Directorio |
|---|---|---|
| `remitero` | 8000 | `projects/remitero` |
| `ia` | 3001 | `projects/ia` |
| `devbot` | 3333 | `projects/devbot-orchestrator` |
| `vorum-wa` | — | `projects/vorum-wa` |
| `mensajero` | 3005 | `projects/mensajero` |
| `launcher` | 80 | `projects/launcher` |

Arranque automático en Windows: `start-servers.ps1` vía Task Scheduler (ejecuta `pm2 resurrect`).

---

## Setup proveeduría (terminal + tablet)

### 1. Build e inicio de remitero

```bash
cd remitero
npm install
npm run build
cd ..
./start pm2 reload
```

### 2. Recrear estación kiosco-1

```bash
./id/start seed
# → imprime ID_KIOSK_STATION_ID para copiar en remitero/.env.local
```

### 3. Abrir pantallas

**Tablet cliente** (muestra evolución del pedido):
```bash
./remitero/start kiosco
```

**Tablet identidad** (reconocimiento facial):
```bash
./id/start terminal
```

**PC cajero** (UI de remitos):
```bash
./remitero/start cajero
```

---

## Arquitectura de tiempo real

El carrito y la verificación de identidad usan **SSE** (Server-Sent Events) en lugar de polling HTTP.

| Flujo | Endpoint SSE | Latencia |
|---|---|---|
| Carrito → tablet | `GET /api/kiosk/cart/stream?companyId=X` | ~0ms |
| Identidad → cajero | `GET /api/credito/kiosco-stream?view=face\|dni` | ~500ms (poll server-side a id) |
| Vista → terminal id | `GET /api/kiosk/state/stream?stationId=X` | ~500ms (poll DB) |

Para PM2 local el cart usa `EventEmitter` en memoria (un solo proceso). Para Vercel multi-instancia migrar cart a Supabase Realtime.

---

## Proyectos

| Proyecto | URL | Repo |
|---|---|---|
| remitero | preview.remitero.puntoindigo.com | [puntoindigo/remitero](https://github.com/puntoindigo/remitero) |
| id | id.puntoindigo.com | [puntoindigo/id](https://github.com/puntoindigo/id) |
| ia | ia.puntoindigo.com | [puntoindigo/ai](https://github.com/puntoindigo/ai) |
| devbot | localhost:3333 | [puntoindigo/devbot-orchestrator](https://github.com/puntoindigo/devbot-orchestrator) |
| vorum | vorum.puntoindigo.com | — |
| recibos | v0-recibos.vercel.app | [puntoindigo/recibos-gremio](https://github.com/puntoindigo/recibos-gremio) |
| launchpad | launchpad-daeiman0.vercel.app | — |
