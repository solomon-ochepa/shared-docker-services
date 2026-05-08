#!/bin/bash

# Script to fix phpMyAdmin session conflicts when using multiple MySQL instances

echo "Fixing phpMyAdmin session conflicts..."

# Stop the phpMyAdmin container
echo "Stopping phpMyAdmin container..."
docker stop phpmyadmin 2>/dev/null

# Remove old phpMyAdmin container
echo "Removing old phpMyAdmin container..."
docker rm phpmyadmin 2>/dev/null

# Clear any existing session volume
echo "Clearing old session data..."
docker volume rm shared-docker-services_phpmyadmin_sessions 2>/dev/null

# Recreate phpMyAdmin with new configuration
echo "Starting phpMyAdmin with fixed configuration..."
docker compose up -d phpmyadmin

# Wait for container to be ready
echo "Waiting for phpMyAdmin to be ready..."
sleep 5

# Check if phpMyAdmin is running
if docker ps | grep -q phpmyadmin; then
    echo "✅ phpMyAdmin has been restarted with session isolation"
    echo ""
    echo "You can now access phpMyAdmin at http://localhost:${PMA_PORT:-8080}"
    echo ""
    echo "Available MySQL servers:"
    echo "  - Auth MySQL (auth-mysql)"
    echo "  - MailForce MySQL (mailforce-mysql)"
    echo "  - ERP MySQL (erp-mysql)"
    echo ""
    echo "Each server now maintains separate sessions to prevent conflicts."
else
    echo "❌ Failed to start phpMyAdmin. Please check the logs:"
    echo "docker logs phpmyadmin"
fi