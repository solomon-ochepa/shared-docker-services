# phpMyAdmin Configuration

## Quick Start

### Build and Run

```bash
# Build the custom phpMyAdmin image
docker compose build phpmyadmin

# Start phpMyAdmin
docker compose up -d phpmyadmin

# Check status
docker compose ps phpmyadmin

# View logs
docker compose logs phpmyadmin

# Restart if needed
docker compose restart phpmyadmin

# Stop and remove
docker compose down phpmyadmin
```

### Access phpMyAdmin
Open your browser and navigate to: http://localhost:8080

## Default Servers

The following MySQL servers are configured by default in `phpmyadmin.config.inc.php`:

1. **Auth** - auth-mysql
2. **MailForce** - mailforce-mysql

## Adding Custom Servers Locally

To add additional MySQL servers without modifying the tracked configuration:

1. Copy the example file:
   ```bash
   cp phpmyadmin/config/phpmyadmin.config.local.php.example phpmyadmin/config/phpmyadmin.config.local.php
   ```

2. Edit `phpmyadmin/config/phpmyadmin.config.local.php` to add your servers (see the example in the file)

3. Restart phpMyAdmin:
   ```bash
   docker compose restart phpmyadmin
   ```

The `phpmyadmin.config.local.php` file is gitignored and won't be tracked.

## Server Selection

With the current setup:
- You can switch between servers using the dropdown on the phpMyAdmin login page
- Each server maintains separate sessions to prevent conflicts
- The `PMA_ARBITRARY=1` setting allows you to connect to any MySQL server by entering its hostname directly

## Session Isolation

Sessions are stored in files (`/tmp/phpmyadmin_sessions`) instead of the database to prevent the "Unknown database" error when multiple apps share phpMyAdmin.

## Troubleshooting

### Database Connection Error
If you see "Unknown database" errors:

```bash
# Quick fix - rebuild and restart
./phpmyadmin/scripts/fix-phpmyadmin.sh

# Or manually:
docker compose down phpmyadmin
docker volume rm shared-docker-services_phpmyadmin_sessions
docker compose up -d phpmyadmin
```

### Port Conflicts
If port 8080 is already in use, change it in `.env`:

```bash
PMA_PORT=8081
```

Then restart phpMyAdmin:
```bash
docker compose restart phpmyadmin
```

## Architecture

```
phpmyadmin/
├── config/
│   ├── phpmyadmin.config.inc.php         # Main configuration
│   └── phpmyadmin.config.local.php.example   # Local server template
├── docker/
│   ├── Dockerfile                        # Custom image definition
│   └── docker-entrypoint-init.d/        # Startup scripts
├── scripts/
│   └── fix-phpmyadmin.sh                # Quick fix script
└── README.md                             # This file
```

The custom Docker image:
- Based on official `phpmyadmin:latest`
- File-based session storage to prevent conflicts
- Optimized PHP settings for large databases
- Support for local configuration overrides
