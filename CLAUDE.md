# TenXRep - Monorepo Overview

This is the root directory for the TenXRep fitness tracking application. The application is split across four separate project repositories, each with its own CLAUDE.md for detailed documentation.

## What is TenXRep?

TenXRep is a fitness tracking application that combines real-time workout tracking with interactive 3D anatomy visualization. It's the only app that merges workout planning/tracking with visual muscle targeting feedback.

**Key Features:**
- Workout planning and tracking
- Exercise library with muscle targeting (160+ exercises)
- Interactive 3D muscle visualization (237 meshes, 40+ sub-muscles)
- Three 3D view modes: Activation, Volume, and Balance
- Visual Progression — timeline slider to scrub past weeks on 3D model
- Imbalance detection — push/pull and anterior/posterior volume balance
- Corrective micro-programs — targeted exercises to fix imbalances
- Workout recommendations with single-exercise swap
- Overtraining Red Zone alerts (>30 sets)
- Calisthenics skill tree progression (15 skills, 88 progressions)
- Progress tracking with personal records
- Desktop side-by-side layout with mini 3D preview
- Capacitor native shells (iOS + Android)
- Beta waitlist and invite system

## Project Structure

```
tenxrep/
├── tenxrep-api/        # Backend API (FastAPI/Python)
├── tenxrep-web/        # Main application (React/Vite)
├── tenxrep-marketing/  # Marketing site (Next.js)
├── tenxrep-go/         # URL shortener/redirect service (Vercel)
└── CLAUDE.md           # This file
```

## Projects

### tenxrep-api (Backend)
**Tech Stack:** FastAPI, PostgreSQL (Neon), SQLAlchemy, Alembic, JWT Auth
**Port:** 8000
**Deployment:** AWS App Runner + ECR (Docker)
**Documentation:** See [`tenxrep-api/CLAUDE.md`](tenxrep-api/CLAUDE.md)

```bash
cd tenxrep-api
source venv/bin/activate
python run.py              # Start dev server
pytest                     # Run tests
alembic upgrade head       # Run migrations
```

### tenxrep-web (Frontend)
**Tech Stack:** React 18, Vite, TypeScript, Tailwind CSS, shadcn/ui, TanStack Query, Three.js
**Port:** 8080
**Deployment:** Vercel
**Documentation:** See [`tenxrep-web/CLAUDE.md`](tenxrep-web/CLAUDE.md)

```bash
cd tenxrep-web
npm install
npm run dev                # Start dev server
npm test                   # Run tests
npm run build              # Production build
```

### tenxrep-marketing (Marketing Site)
**Tech Stack:** Next.js 14 (App Router), TypeScript, Tailwind CSS, shadcn/ui
**Port:** 3000
**Deployment:** Vercel
**Documentation:** See [`tenxrep-marketing/CLAUDE.md`](tenxrep-marketing/CLAUDE.md)

```bash
cd tenxrep-marketing
npm install
npm run dev                # Start dev server
npm test                   # Run tests
npm run build              # Production build
```

### tenxrep-go (URL Shortener)
**Tech Stack:** Static HTML + Vercel rewrites/redirects
**Deployment:** Vercel
**Production URL:** https://go.tenxrep.com

A lightweight URL shortener service that:
- Redirects root `/` to `https://tenxrep.com`
- Rewrites `/:code` to the API's short-links endpoint for tracking

Used for creating trackable short links for marketing campaigns (e.g., `go.tenxrep.com/launch` → tracks clicks and redirects to target URL).

```bash
cd tenxrep-go
# No build step - just static files + vercel.json config
# Deploy via Vercel CLI or push to main
```

## Key URLs

| Environment | URL | Description |
|-------------|-----|-------------|
| Production API | https://mqq3xyhgt5.us-west-2.awsapprunner.com/api/v1 | Backend API |
| Production App | https://tenxrep.alouisequiatchon.com | Main web app |
| Production Short Links | https://go.tenxrep.com | URL shortener |
| Local API | http://localhost:8000/api/v1 | Dev backend |
| Local App | http://localhost:8080 | Dev frontend |
| Local Marketing | http://localhost:3000 | Dev marketing site |
| API Docs | http://localhost:8000/docs | Swagger UI |

## Development Workflow

### Starting All Services

```bash
# Terminal 1: Backend API
cd tenxrep-api && source venv/bin/activate && python run.py

# Terminal 2: Frontend App
cd tenxrep-web && npm run dev

# Terminal 3: Marketing Site (if needed)
cd tenxrep-marketing && npm run dev
```

### Common Cross-Project Tasks

**Full Stack Feature Development:**
1. Define API schema in `tenxrep-api/app/schemas/`
2. Create/update endpoint in `tenxrep-api/app/api/v1/endpoints/`
3. Add frontend service in `tenxrep-web/src/services/`
4. Create React hook in `tenxrep-web/src/hooks/`
5. Build UI component in `tenxrep-web/src/components/`

**Database Changes:**
```bash
cd tenxrep-api
alembic revision --autogenerate -m "description"
alembic upgrade head
```

## Shared Conventions

### API Patterns
- RESTful endpoints without trailing slashes
- JWT authentication for protected routes
- Pydantic schemas for validation

### Frontend Patterns
- shadcn/ui components for consistent UI
- TanStack Query for data fetching
- Zod for form validation
- Path alias: `@/*` maps to `./src/*`

### Styling
- Tailwind CSS across all projects
- Shared design tokens (colors, spacing)
- CSS variables for theming

## Environment Variables

Each project has its own `.env` file (gitignored). See each project's CLAUDE.md for required variables.

**Critical:** Never commit `.env` files. Production credentials live in AWS App Runner (API) and Vercel (web/marketing).

## Deployment

| Project | Platform | Trigger |
|---------|----------|---------|
| tenxrep-api | AWS App Runner | Push to main (GitHub Actions) |
| tenxrep-web | Vercel | Push to main (auto) |
| tenxrep-marketing | Vercel | Push to main (auto) |
| tenxrep-go | Vercel | Push to main (auto) |

## Getting Started

1. Clone all four repos into this directory
2. Set up each project following its CLAUDE.md
3. Start the API first (backend)
4. Start the web app (frontend)
5. Marketing site and URL shortener are optional for development

## AI Assistant Guidelines

### Security Audits
When asked to run a security audit, follow the checklist in **[SECURITY_AUDIT.md](SECURITY_AUDIT.md)**. Focus on:
- Authentication/authorization flaws
- Input validation & injection risks
- Secrets management
- Data protection
- Dependency vulnerabilities

Report findings by severity: CRITICAL, HIGH, MEDIUM, LOW.

### Use Context7 for Documentation
When working on this codebase, **always use Context7** to fetch up-to-date documentation for libraries and frameworks. This ensures you're using current APIs and best practices rather than relying on potentially outdated training data.

**When to use Context7:**
- Looking up React, Next.js, or Vite APIs
- Checking TanStack Query patterns
- Verifying FastAPI or SQLAlchemy usage
- Any library-specific questions (shadcn/ui, Tailwind, Three.js, etc.)

**How to use:**
1. First call `resolve-library-id` to get the Context7 library ID
2. Then call `query-docs` with your specific question

This is especially important for:
- React 18 features (useTransition, Suspense)
- Next.js 14 App Router patterns
- TanStack Query v5 APIs
- FastAPI async patterns

## Need More Info?

Each project has comprehensive documentation:
- **API:** `tenxrep-api/CLAUDE.md` and `tenxrep-api/docs/`
- **Web:** `tenxrep-web/CLAUDE.md` and `tenxrep-web/docs/`
- **Marketing:** `tenxrep-marketing/CLAUDE.md`
- **URL Shortener:** `tenxrep-go/vercel.json` (minimal config, uses API short-links endpoint)
- **Monetization:** [`docs/MONETIZATION_STRATEGY.md`](docs/MONETIZATION_STRATEGY.md) - Pricing model, feature access matrix, trial strategy
