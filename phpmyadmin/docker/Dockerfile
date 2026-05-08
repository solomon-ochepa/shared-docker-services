FROM phpmyadmin:latest

# Create directory for file-based sessions
RUN mkdir -p /tmp/phpmyadmin_sessions && \
    chmod 777 /tmp/phpmyadmin_sessions

# Install additional PHP extensions if needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev && \
    rm -rf /var/lib/apt/lists/*

# Set PHP configuration for better performance with multiple databases
RUN { \
        echo 'max_execution_time = 600'; \
        echo 'memory_limit = 512M'; \
        echo 'post_max_size = 256M'; \
        echo 'upload_max_filesize = 256M'; \
        echo 'max_input_time = 600'; \
        echo 'max_input_vars = 10000'; \
        echo 'session.save_handler = files'; \
        echo 'session.save_path = /tmp/phpmyadmin_sessions'; \
        echo 'session.gc_maxlifetime = 1440'; \
        echo 'session.cookie_lifetime = 0'; \
        echo 'session.use_strict_mode = 1'; \
    } > /usr/local/etc/php/conf.d/phpmyadmin-custom.ini

# Copy startup scripts
COPY docker-entrypoint-init.d /docker-entrypoint-init.d
RUN chmod +x /docker-entrypoint-init.d/*.sh

# Ensure session directory permissions
VOLUME /tmp/phpmyadmin_sessions