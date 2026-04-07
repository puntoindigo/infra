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

### Ecosistema gremial

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| remitero | Remitos, ventas y crédito gremial (proveeduría) | [preview.remitero.puntoindigo.com](https://preview.remitero.puntoindigo.com) | [puntoindigo/remitero](https://github.com/puntoindigo/remitero) |
| id | Identidad facial, DNI y kiosco de verificación | [id.puntoindigo.com](https://id.puntoindigo.com) | [puntoindigo/id](https://github.com/puntoindigo/id) |
| recibos-gremio | Recibos de sueldo con descuentos a crédito | [v0-recibos.vercel.app](https://v0-recibos.vercel.app) | [puntoindigo/recibos-gremio](https://github.com/puntoindigo/recibos-gremio) |
| gremio-hub | Hub del ecosistema gremial | [gremio-hub.vercel.app](https://gremio-hub.vercel.app) | [puntoindigo/gremio-hub](https://github.com/puntoindigo/gremio-hub) |

### IA y automatización

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| ai (ia) | Motor IA gateway — API unificada, planes, checkout SSE | [ia.puntoindigo.com](https://ia.puntoindigo.com) | [puntoindigo/ai](https://github.com/puntoindigo/ai) |
| devbot-orchestrator | Orquestador de Claude Code bots, panel admin | localhost:3333 / [devbots.puntoindigo.com](https://devbots.puntoindigo.com) | [puntoindigo/devbot-orchestrator](https://github.com/puntoindigo/devbot-orchestrator) |
| devbots | Landing/producto devbots | [devbots.puntoindigo.com](https://devbots.puntoindigo.com) | [puntoindigo/devbots](https://github.com/puntoindigo/devbots) |
| mensajero | Notificaciones WhatsApp unificadas | localhost:3005 (PM2) | — |
| vorum-wa | Bot WhatsApp que conecta números al CRM | PM2 local + Tailscale | [puntoindigo/vorum-wa](https://github.com/puntoindigo/vorum-wa) |

### CRM y comunicación

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| vorum | CRM WhatsApp para abogados, contadores y consultores | [vorum.puntoindigo.com](https://vorum.puntoindigo.com) | [puntoindigo/vorum](https://github.com/puntoindigo/vorum) |

### Identidad y pagos

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| accounts | Cuentas y autenticación del ecosistema | [accounts-daeiman0.vercel.app](https://accounts-daeiman0.vercel.app) | [puntoindigo/accounts](https://github.com/puntoindigo/accounts) |
| plata | Pasarela de pagos y suscripciones | [plata-opal.vercel.app](https://plata-opal.vercel.app) | [puntoindigo/plata](https://github.com/puntoindigo/plata) |

### Apps y herramientas

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| auris (v0-audio) | Sonidos binaurales — concentración, relajación, sueño | [auris.puntoindigo.com](https://auris.puntoindigo.com) | [puntoindigo/v0-audio-generation-interface](https://github.com/puntoindigo/v0-audio-generation-interface) |
| postulador | CVs ATS, flyers y perfiles profesionales | — | [puntoindigo/postulador](https://github.com/puntoindigo/postulador) |
| mvp | Sistema de autorización de operaciones (POS) | [app.puntoindigo.com](https://app.puntoindigo.com) | [puntoindigo/mvp](https://github.com/puntoindigo/mvp) |
| tableros | Dashboards de gestión del ecosistema | — | [puntoindigo/tableros](https://github.com/puntoindigo/tableros) |
| Cruxis | — | — | [puntoindigo/Cruxis](https://github.com/puntoindigo/Cruxis) |
| oliveros | — | [oliveros.vercel.app](https://oliveros.vercel.app) | [puntoindigo/oliveros](https://github.com/puntoindigo/oliveros) |

### Infraestructura local (PM2)

| Proyecto | Descripción | Puerto | Repo |
|---|---|---|---|
| launcher | Hub local — panel de acceso rápido a servicios | 80 | — |
| mensajero | Notificaciones WA unificadas | 3005 | — |
| ia | Motor IA (ver arriba) | 3001 | [puntoindigo/ai](https://github.com/puntoindigo/ai) |
| devbot | Orquestador bots (ver arriba) | 3333 | [puntoindigo/devbot-orchestrator](https://github.com/puntoindigo/devbot-orchestrator) |
| remitero | Remitos (ver arriba) | 8000 | [puntoindigo/remitero](https://github.com/puntoindigo/remitero) |
| vorum-wa | Bot WA (ver arriba) | — | [puntoindigo/vorum-wa](https://github.com/puntoindigo/vorum-wa) |

### Presencia y marketing

| Proyecto | Descripción | URL | Repo |
|---|---|---|---|
| dev | Landing institucional Punto Indigo | [dev.puntoindigo.com](https://dev.puntoindigo.com) | [puntoindigo/dev](https://github.com/puntoindigo/dev) |
| launchpad | Hub de proyectos + 10 ideas | [launchpad-daeiman0.vercel.app](https://launchpad-daeiman0.vercel.app) | [puntoindigo/launchpad](https://github.com/puntoindigo/launchpad) |
