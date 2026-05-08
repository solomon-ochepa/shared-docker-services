#!/bin/bash
# Shared Laravel boot library — source this file from your app's startup.sh.
# Provides standard setup functions used across all Laravel services.
# App-specific logic (migrations, seeders, etc.) belongs in each app's startup.sh.
set -e

setup_env() {
    if [ ! -z "${APP_KEY}" ]; then
        echo "APP_KEY: Found in Doppler, skipping generation."
    else
        echo "APP_KEY: Not found in environment, generating a new application key..."
        php artisan key:generate --force
        echo -e "APP_KEY: Generated\n\n"
    fi
}

DB_HEALTHY=false

database_health_check() {
    if [ -z "$DB_HOST" ]; then
        echo "Database: DB_HOST is not set, skipping health check."
        return 0
    fi

    echo "Database: Waiting to be ready..."

    local MAX_ATTEMPTS=30
    local ATTEMPT=0

    while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
        if php artisan db:monitor >/dev/null 2>&1 || php -r "
            try {
                \$pdo = new PDO('mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT') . ';dbname=' . getenv('DB_DATABASE'), getenv('DB_USERNAME'), getenv('DB_PASSWORD'));
                echo 'Database: Connection successful';
                exit(0);
            } catch (PDOException \$e) {
                exit(1);
            }
        " >/dev/null 2>&1; then
            echo -e "Database: Ready!\n\n"
            DB_HEALTHY=true
            return 0
        fi

        echo -e "Database: Not ready yet, attempt $((ATTEMPT + 1))/$MAX_ATTEMPTS...\n\n"

        sleep 2
        ATTEMPT=$((ATTEMPT + 1))
    done

    echo "WARNING: Database connection failed after $MAX_ATTEMPTS attempts"
    echo -e "Skipping migrations...\n\n"
}

run_migrations() {
    if [ "$APP_ENV" != "testing" ] && [ "$DB_HEALTHY" = "true" ]; then
        echo "Migrations"
        MIGRATE_OUTPUT=$(php artisan migrate --force 2>&1)
        echo "$MIGRATE_OUTPUT"
        echo -e "Migrations: Completed!\n\n"

        # Seed when new migrations were applied or explicitly requested via RUN_SEEDERS=true
        local RAN_MIGRATIONS=false
        echo "$MIGRATE_OUTPUT" | grep -qE "Migrating:|Running migrations" && RAN_MIGRATIONS=true

        if [ "$RAN_MIGRATIONS" = "true" ] || [ "$RUN_SEEDERS" = "true" ]; then
            echo "Seeders"

            echo "Seeding root"
            php artisan db:seed --force

            if composer show nwidart/laravel-modules >/dev/null 2>&1; then
                echo "Seeding modules"
                php artisan module:seed --all --force
            fi

            echo -e "Seeders: Completed!\n\n"
        fi
    fi
}

setup_permissions() {
    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

    if [ "$APP_ENV" != "testing" ]; then
        echo "Cache: Clearing application cache"
        php artisan cache:clear
        php artisan view:clear
        echo ""
    fi
}

setup_storage() {
    echo "Storage: Create link"
    mkdir -p storage/app/public
    php artisan storage:link --force
    echo ""
}

setup_telescope() {
    if composer show laravel/telescope >/dev/null 2>&1; then
        echo "Telescope: Publish assets"
        php artisan vendor:publish --tag=telescope-assets --force
        echo ""
    fi
}

setup_passport() {
    if composer show laravel/passport >/dev/null 2>&1; then
        if [ ! -f /var/www/html/storage/oauth-private.key ]; then
            echo "Passport: Generating keys..."
            php artisan passport:keys --force
            echo -e "Passport: Keys generated\n\n"
        fi

        if [ -f /var/www/html/storage/oauth-private.key ]; then
            chown www-data:www-data /var/www/html/storage/oauth-private.key
            chmod 600 /var/www/html/storage/oauth-private.key
        fi

        if [ -f /var/www/html/storage/oauth-public.key ]; then
            chown www-data:www-data /var/www/html/storage/oauth-public.key
            chmod 600 /var/www/html/storage/oauth-public.key
        fi
    fi
}

laravel_boot() {
    echo "Laravel: Starting application setup..."
    echo "Env: $APP_ENV"
    echo -e "DB Host: $DB_HOST\n"

    # Scheduler pod: skip heavy setup and hand off immediately
    if [[ "${1:-}" == "php" ]] && [[ "${2:-}" == "/var/www/html/artisan" ]] && [[ "${3:-}" == "schedule:run" ]]; then
        echo "Scheduler: Running as scheduler pod - simplifying startup..."
        # Skip migrations and other heavy setup for scheduler
        exec php /var/www/html/artisan schedule:run
    fi

    setup_env
    database_health_check
    run_migrations
    setup_permissions
    setup_storage
    setup_telescope
    setup_passport

    echo -e "Laravel: Setup completed successfully!\n\n"

    # Falls back to supervisord when no CMD is given — keeps the container alive
    # without requiring a CMD in the Dockerfile or the orchestration layer.
    if [ $# -gt 0 ]; then
        exec "$@"
    else
        exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
    fi
}
