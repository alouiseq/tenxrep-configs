# TenXRep - Monorepo Overview

This is the root directory for the TenXRep fitness tracking application. The application is split across four separate project repositories, each with its own CLAUDE.md for detailed documentation.

## What is TenXRep?

TenXRep is a fitness tracking application that combines real-time workout tracking with interactive 3D anatomy visualization. It's the only app that merges workout planning/tracking with visual muscle targeting feedback.

**Key Features:**
- Workout planning and tracking
- Exercise library with muscle targeting (250+ exercises)
- Interactive 3D muscle visualization (237 meshes, 40+ sub-muscles)
- Three 3D view modes: Activation, Volume, and Balance
- Visual Progression — timeline slider to scrub past weeks on 3D model
- Imbalance detection — push/pull and anterior/posterior volume balance
- Corrective micro-programs — targeted exercises to fix imbalances
- Workout recommendations with single-exercise swap
- Overtraining Red Zone alerts (>30 sets)
- Calisthenics skill tree progression (15 skills, 90+ progressions)
- Progress tracking with personal records
- Desktop side-by-side layout with mini 3D preview
- Open registration + Google OAuth login
- Google account linking for existing users
- Capacitor native shells (iOS + Android)
- Freemium gating with 14-day trial (6 feature gates, upgrade prompts)
- Stripe subscription payments (checkout, billing portal, webhooks)
- Beta waitlist and invite system

## Project Structure

**This is not a monorepo. It's five independent git repositories that happen to sit side by side on disk.**

```
tenxrep/                     ← a git repo → github.com/alouiseq/tenxrep-configs
├── CLAUDE.md                   tracked by tenxrep-configs
├── docs/                       tracked by tenxrep-configs (BACKLOG, strategy, patterns…)
├── AUDIT_FINDINGS.md           tracked by tenxrep-configs
├── TURNSTILE_ROLLOUT.md        tracked by tenxrep-configs
│
├── tenxrep-api/             ← separate repo → github.com/alouiseq/tenxrep-api
├── tenxrep-web/             ← separate repo → github.com/alouiseq/tenxrep-web
├── tenxrep-marketing/       ← separate repo → github.com/alouiseq/tenxrep-marketing
└── tenxrep-go/              ← separate repo (static files + vercel.json)
```

The parent repo is named **`tenxrep-configs`** on GitHub, and its `.gitignore` excludes `tenxrep-*/` — so it tracks **zero** files from the project directories. They are **not** git submodules either; nothing on GitHub records the parent/child relationship. The nesting exists only in this working copy.

### What follows from that

**1. Cross-repo relative links work locally and break on GitHub.** `../docs/ENGINEERING_PATTERNS.md` in `tenxrep-web/CLAUDE.md` resolves here (`tenxrep-web/..` is `tenxrep/`), but on GitHub the `tenxrep-web` repo's root *is* `tenxrep-web/`, so `../` points above the repository and 404s. **Use absolute URLs for any link that crosses a repo boundary:**

```markdown
[Engineering Patterns](https://github.com/alouiseq/tenxrep-configs/blob/main/docs/ENGINEERING_PATTERNS.md)
```

Relative links *within* one repo are fine and preferred.

**2. A change spanning projects is several commits in several repos** — never one. A full-stack feature means a PR on `tenxrep-api` and a PR on `tenxrep-web`, merged in that order, plus possibly a `tenxrep-configs` commit for the docs. There is no atomic cross-repo commit, so order matters when one side depends on the other (e.g. ship the API contract before the frontend that calls it).

**3. Check which repo you're in before branching.** `cd` moves you between repos; `git status` in `tenxrep/` reports only `tenxrep-configs` files and will look suspiciously clean when your real edits are a directory down. The sub-repos require feature branches + PRs; `tenxrep-configs` commits straight to `main`.

**4. Each repo has its own `CLAUDE.md`,** and `tenxrep-api`/`tenxrep-web` have their own `docs/`. Only cross-project material belongs in `tenxrep-configs/docs/`.

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
**Tech Stack:** React 18, Vite, TypeScript, Tailwind CSS, shadcn/ui, TanStack Query, Three.js, PostHog, Sentry
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
| Production App | https://app.tenxrep.com | Main web app |
| Production Short Links | https://go.tenxrep.com | URL shortener |
| Local API | http://localhost:8000/api/v1 | Dev backend |
| Local App | http://localhost:8080 | Dev frontend |
| Local Marketing | http://localhost:3000 | Dev marketing site |
| API Docs | http://localhost:8000/docs | Swagger UI |

## Development Workflow

### Starting All Services

Use these version-correct commands (Python 3.11.14 via the API venv, Node 20 via `.nvmrc`):

```bash
# Terminal 1: Backend API (Python 3.11.14, port 8000)
cd tenxrep-api && source venv/bin/activate && python --version && python run.py

# Terminal 2: Frontend App (Node 20, port 8080)
cd tenxrep-web && nvm use && npm run dev

# Terminal 3: Marketing Site (if needed, port 3000)
cd tenxrep-marketing && nvm use && npm run dev
```

**Required versions:**
| Project | Required | Pinned in |
|---------|----------|-----------|
| tenxrep-api | Python 3.11.14 | `.python-version`, `Dockerfile`, venv |
| tenxrep-web | Node 20 | `.nvmrc` |

- API venv is locked to 3.11.14 — just activate it (no `pyenv` switch needed). `python --version` is a sanity check before launch.
- `nvm use` reads `.nvmrc` automatically. If Node 20 isn't installed: `nvm install 20` once.
- Default shell Node may be newer (e.g. 23.x) — always `nvm use` in `tenxrep-web` before `npm run dev`.

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

### Keep the docs current as you work — split by depth

When work produces a correction worth remembering or a pattern worth following, record it. This is **default behavior, not something to request each time**: after a change lands, self-classify — new or changed functionality → propose the doc edit as part of wrapping up; a bug fix or refactor → skip, unless it surfaced a durable gotcha. Override phrases: **"doc this"** forces an update, **"skip docs"** suppresses one.

**Where it goes depends on depth, not topic:**

| Kind | Home | Shape |
|---|---|---|
| Terse warning or convention for one project | that project's `CLAUDE.md` → "Common Pitfalls to Avoid" | 1–2 imperative lines, linking to the deep version |
| Pattern spanning projects, with reasoning | [`docs/ENGINEERING_PATTERNS.md`](docs/ENGINEERING_PATTERNS.md) | pattern + why + worked example |
| Deep project-specific detail | that project's `docs/` (e.g. `tenxrep-api/docs/DATABASE.md`, `tenxrep-web/docs/COMPONENTS.md`) | full writeups |
| Planned work | [`docs/BACKLOG.md`](docs/BACKLOG.md) | what + why, `where`, `size`, `source` |
| User-facing change | `tenxrep-marketing/content/changelog/` **and** [`docs/product_overview.md`](docs/product_overview.md) | changelog entry (history) + edit the overview in place (current state) |

The `CLAUDE.md` files are auto-loaded into every session; the `docs/` are not. So the warning that stops a repeat mistake belongs in `CLAUDE.md` even when its explanation lives elsewhere — and when a pitfall's body outgrows two lines, move the body out and leave the warning.

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
- **Product Overview:** [`docs/product_overview.md`](docs/product_overview.md) - Single source of truth for what the app does today (features, counts, free vs Pro, platforms). Self-contained — the file to hand an external AI or person
- **Engineering Patterns:** [`docs/ENGINEERING_PATTERNS.md`](docs/ENGINEERING_PATTERNS.md) - Cross-project design/code patterns with the incidents behind them. Read before non-trivial work; add to it when a correction generalises beyond one project
- **Backlog:** [`docs/BACKLOG.md`](docs/BACKLOG.md) - Planned work across all four projects (Now/Next/Later/Parked). Add new planned work here rather than starting a separate list; it links to AUDIT_FINDINGS.md, TURNSTILE_ROLLOUT.md, and docs/user-interview-plan.md rather than duplicating them
