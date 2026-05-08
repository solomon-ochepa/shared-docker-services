#!/bin/bash

# Check if local config exists and copy it if it does
if [ -f "/local-config/phpmyadmin.config.local.php" ]; then
    echo "Loading local phpMyAdmin configuration..."
    cp /local-config/phpmyadmin.config.local.php /etc/phpmyadmin/config.local.inc.php
    chmod 644 /etc/phpmyadmin/config.local.inc.php
else
    echo "No local phpMyAdmin configuration found, using defaults only."
    # Create an empty file to avoid include errors
    touch /etc/phpmyadmin/config.local.inc.php
fi