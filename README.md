# Proyectos

Repositorio de proyectos de desarrollo personal. Organización GitHub: [puntoindigo](https://github.com/puntoindigo).

---

## Proyectos

### [mvp](./mvp/) · [app.puntoindigo.com](https://app.puntoindigo.com)

Sistema de autorización de operaciones para Punto Indigo / Sindicato. Permite crear solicitudes de autorización (POS), aprobarlas/rechazarlas via link, y gestionar multi-tenant por subdominio.

**Características principales:**
- POS (punto de venta): creación de solicitudes de autorización con flujo en tiempo real via SSE
- Página de autorización `/autorizar/[token]` para aprobar/rechazar desde email o móvil
- Panel Setup `/setup` con diagnóstico de variables, gestor de tenants, visor de DB y AI Playground
- Multi-tenant por subdominio (`*.puntoindigo.com`)
- Admin de Vercel Blob (listar, eliminar, limpiar)

**Stack:** Next.js, TypeScript, Tailwind CSS, Prisma, PostgreSQL, NextAuth.js, Vercel Blob, Resend

**Estado:** En desarrollo activo

---

### [dev](./dev/) · [www.puntoindigo.com](https://www.puntoindigo.com)

Sitio web institucional de la agencia digital Punto Indigo. Presenta los servicios, portfolio, equipo y contacto.

**Características principales:**
- Secciones: Hero, Servicios, Portfolio (incluye Remitero), Equipo, Contacto, Footer
- Diseño moderno y responsive con animaciones (Framer Motion)
- SEO optimizado

**Stack:** Next.js 14, TypeScript, Tailwind CSS, Framer Motion, Lucide React

**Estado:** En producción

---

### [remitero](./remitero/) · [v0-remitero-daeiman0.vercel.app](https://v0-remitero-daeiman0.vercel.app)

Sistema web de gestión de remitos (recibos de entrega) para empresas que necesitan administrar entregas de productos a clientes.

**Características principales:**
- CRUD completo de remitos con estados personalizables
- Soporte multi-empresa con aislamiento de datos
- Sistema de roles: SUPERADMIN, ADMIN, USER
- Autenticación dual: Google OAuth + credenciales
- Dashboard con métricas y gráficos (Recharts)
- Impresión de remitos y logs de auditoría de usuarios

**Stack:** Next.js 15, TypeScript, Tailwind CSS, Supabase (PostgreSQL), NextAuth.js, TanStack Query, Puppeteer

**Estado:** En producción activo

---

### [id](./id/) · [id.puntoindigo.com](https://id.puntoindigo.com)

Proveedor de identidad centralizado para Crédito Gremial y otros productos del ecosistema Punto Indigo.

**Características principales:**
- Alta de personas con datos, biometría, DNI y QR
- Tabla `persons` con DNI, email, face signature, auth_hash
- Dashboard admin con gestión de personas y configuración
- API `/api/verify` para identificación por cookie, rostro, DNI o Google
- CORS restringido a `*.puntoindigo.com`

**Stack:** Next.js 15, TypeScript, Tailwind CSS (dark/glassmorphism), Neon (PostgreSQL), Drizzle ORM, Neon Auth (Clerk — por integrar)

**Estado:** En desarrollo activo

---

### [postulador](./postulador/)

**Postula+** — Plataforma web para crear postulaciones profesionales.

Aplicación orientada a jóvenes que necesitan armar CVs, flyers sociales y perfiles profesionales de forma rápida y efectiva.

**Características principales:**
- Generador de CVs ATS-friendly con exportación PDF, DOCX y TXT
- Generador de flyers para redes sociales
- Perfil público compartible por enlace único
- Sistema de análisis y recomendaciones ATS
- Autenticación con email/contraseña y Google
- Suscripción premium via Mercado Pago

**Stack:** Next.js 14+, TypeScript, Tailwind CSS, Prisma, PostgreSQL, NextAuth.js, Playwright, Anthropic SDK

**Estado:** En desarrollo activo

---

## Stack general

| Proyecto | Framework | Base de datos | Auth | Deploy |
|----------|-----------|---------------|------|--------|
| mvp | Next.js | PostgreSQL (Prisma) | NextAuth.js | Vercel |
| dev | Next.js 14 | — | — | Vercel |
| remitero | Next.js 15 | Supabase (PostgreSQL) | NextAuth.js | Vercel |
| id | Next.js 15 | Neon (PostgreSQL) | Neon Auth / Clerk | Vercel |
| postulador | Next.js 14+ | PostgreSQL (Prisma) | NextAuth.js | Vercel |
