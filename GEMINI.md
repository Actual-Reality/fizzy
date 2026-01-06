# Fizzy - Project Context for Gemini

## Project Overview

**Fizzy** is a Kanban-style project management and issue tracking tool developed by 37signals (the makers of Basecamp). It is built as a standard Ruby on Rails application ("Vanilla Rails") but includes sophisticated architectural patterns for multi-tenancy and SaaS operations.

**Key Technologies:**
*   **Framework:** Ruby on Rails (Main branch/8.0+ features)
*   **Database:**
    *   **Development:** SQLite (default)
    *   **Production:** MySQL (Trilogy adapter), utilizing UUIDv7 primary keys.
    *   **Search:** 16-shard MySQL full-text search (no Elasticsearch).
*   **Frontend:** Hotwire (Turbo & Stimulus), Propshaft for assets.
*   **Background Jobs:** Solid Queue (DB-backed).
*   **Caching:** Solid Cache (DB-backed).
*   **WebSockets:** Solid Cable (DB-backed).
*   **Deployment:** Docker (simple), Kamal (advanced/production).

## Architecture

### Multi-Tenancy
Fizzy uses **URL-based multi-tenancy** (Path-based).
*   **Format:** `/{account_id}/boards/...`
*   **Mechanism:** `AccountSlug::Extractor` middleware extracts the ID, sets `Current.account`, and creates a "mounted" feel by manipulating `SCRIPT_NAME`.
*   **Isolation:** All relevant models include `account_id`.

### The SaaS Engine
The repository follows an "Open Core" model:
*   **Core:** The `app/` directory contains the open-source functionality.
*   **SaaS:** The `saas/` directory is a Rails engine (`fizzy-saas`) that adds proprietary features (billing, metrics via Yabeda, detailed auditing via Console1984/Audits1984) for the hosted version (`app.fizzy.do`).

### "Entropy" System
A unique domain concept where cards automatically postpone themselves (move to "Not Now") after a configurable period of inactivity to prevent board clutter.

## Development Workflow

### Setup & Run
*   **Setup:** `bin/setup` (Installs gems, prepares DB).
*   **Start Server:** `bin/dev` (Runs on port 3006).
*   **Access:** `http://fizzy.localhost:3006`
*   **Auth:** Passwordless "Magic Link". Dev credentials: `david@example.com` (Check console/logs for login link).

### Testing & Quality (`bin/ci`)
The CI script (`bin/ci`) is the source of truth for quality checks. It runs:
1.  **Style:** `bin/rubocop` (Rails Omakase preset).
2.  **Dependencies:** `bin/bundle-drift check` (Checks for gem versions drift).
3.  **Security:**
    *   `bin/bundler-audit` (Gem vulnerabilities).
    *   `bin/importmap audit` (JS vulnerabilities).
    *   `bin/brakeman` (Static analysis).
    *   `bin/gitleaks-audit` (Secret scanning).
4.  **Tests:**
    *   `bin/rails test` (Unit/Integration).
    *   `bin/rails test:system` (System tests with Capybara/Selenium).

**Note:** System tests require `PARALLEL_WORKERS=1` for reliability.

### Deployment
*   **Docker:** Simple deployment via `Dockerfile`.
*   **Kamal:** Recommended for production (`bin/kamal deploy`).

## Coding Conventions

Adhere strictly to `STYLE.md`. Key highlights:

*   **Vanilla Rails:** Prefer thin controllers and rich models. Avoid Service Objects unless necessary.
*   **Conditionals:** Prefer expanded `if/else` over guard clauses (`return unless`) for readability, except for simple early returns.
*   **Method Order:** Class methods -> Public -> Private. Order by invocation (caller above callee).
*   **Visibility:** Indent `private` methods.
*   **Controllers:** Strict REST. Create new resources (e.g., `Cards::ClosuresController#create`) instead of custom actions (`CardsController#close`).
*   **Naming:** `!` methods are only for counterparts to non-bang methods, not just for "destructive" actions.

## Directory Structure

*   `app/`: Core application code.
*   `bin/`: Executables and scripts (including `ci`, `setup`, `dev`).
*   `config/`: Configuration.
    *   `ci.rb`: Definition of CI steps.
    *   `database.yml`: Dynamic config handling SaaS vs OSS modes.
*   `saas/`: The SaaS Rails engine.
*   `docs/`: Detailed documentation (`kamal-deployment.md`, `docker-deployment.md`).
