# Repository Guidelines

## Project Structure & Module Organization

This repository manages shared Docker infrastructure for PHP and Node.js applications. It is organized into two primary functional areas:

- **Docker Base Images (`/docker`)**: Contains multi-stage Dockerfiles (`Dockerfile.php-nodejs-x.y`) for building PHP-NodeJS runtime environments. These images include specialized configurations for Apache, PHP (opcache, performance), and a shared `laravel-boot.sh` script for application startup.
- **Customized phpMyAdmin (`/phpmyadmin`)**: A specialized phpMyAdmin setup designed for multi-service environments. It features **session isolation** (file-based storage in `/tmp/phpmyadmin_sessions`) to prevent "Unknown database" errors when switching between different MySQL servers.

The services are orchestrated via a root `compose.yml` and connect to an external Docker network named `shared`.

## Build, Test, and Development Commands

### Docker Compose
- **Start Services**: `docker compose up -d`
- **Build phpMyAdmin**: `docker compose build phpmyadmin`
- **Restart phpMyAdmin**: `docker compose restart phpmyadmin`
- **Stop Services**: `docker compose down`

### Image Building
Base images must be built from the repository root:
- **Local Build**: `docker build -t php-nodejs:8.3 -f docker/Dockerfile.php-nodejs-8.3 .`
- **Production Build**: `docker build -t mburton3969/php-nodejs:8.3 -f docker/Dockerfile.php-nodejs-8.3 .`

### Maintenance
- **Fix phpMyAdmin Sessions**: `./phpmyadmin/scripts/fix-phpmyadmin.sh` (Stops container, clears session volume, and restarts).

## Coding Style & Naming Conventions

The project follows rules defined in `.editorconfig`:
- **Indentation**: 4 spaces for most files; 2 spaces for YAML (`.yml`, `.yaml`).
- **End of Line**: LF.
- **Charset**: UTF-8.

## Commit & Pull Request Guidelines

Commit messages follow a prefix-based convention:
- **`feat:` or `feat(scope):`**: New features (e.g., `feat(docker): implement session isolation`).
- **`fix:`**: Bug fixes.
- **`Refactor:`**: Code restructuring without functional changes.
- **`Merge:`**: Standard merge commit messages from PRs.

Major changes should be implemented via feature branches and merged into `develop` or `main` using Pull Requests.
