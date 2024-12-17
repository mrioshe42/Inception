#!/bin/bash

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"$(cat /run/secrets/mysql_password)" --silent; do
    echo "Waiting for MariaDB to be ready... Attempting to connect with user: ${MYSQL_USER}"
    sleep 2
done

# Wait for Redis to be ready
while ! redis-cli -h redis ping &>/dev/null; do
    echo "Waiting for Redis..."
    sleep 1
done

sleep 10

# Check if WordPress is already installed
WP_INSTALLED=$(wp core is-installed --path=/var/www/html --allow-root 2>/dev/null || echo "false")

if [ "$WP_INSTALLED" = "false" ]; then
    echo "WordPress is not installed. Starting installation..."
    
    # Download WordPress core if not present
    if [ ! -f /var/www/html/wp-includes/version.php ]; then
        wp core download --path=/var/www/html --allow-root
    fi
    
    # Create wp-config.php if it doesn't exist
    if [ ! -f /var/www/html/wp-config.php ]; then
        wp config create \
            --dbname="${MYSQL_DATABASE}" \
            --dbuser="${MYSQL_USER}" \
            --dbpass="$(cat /run/secrets/mysql_password)" \
            --dbhost="mariadb" \
            --path=/var/www/html \
            --allow-root
    fi
    
    # Add Redis configuration to wp-config.php
    wp config set WP_REDIS_HOST redis --allow-root --path=/var/www/html
    wp config set WP_REDIS_PORT 6379 --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_CLIENT phpredis --allow-root --path=/var/www/html
    wp config set WP_REDIS_DATABASE 0 --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_PREFIX "${DOMAIN_NAME}" --allow-root --path=/var/www/html
    wp config set WP_CACHE true --raw --allow-root --path=/var/www/html
    
    # Install WordPress core
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/wp_admin_password)" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --path=/var/www/html \
        --allow-root
        
    echo "WordPress core installation completed!"
fi

# Always ensure Redis plugin is installed and configured
if ! wp plugin is-installed redis-cache --allow-root --path=/var/www/html; then
    wp plugin install redis-cache --activate --allow-root --path=/var/www/html
fi

# Make sure Redis plugin is activated
if ! wp plugin is-active redis-cache --allow-root --path=/var/www/html; then
    wp plugin activate redis-cache --allow-root --path=/var/www/html
fi

# Copy object-cache.php dropin
if [ ! -f /var/www/html/wp-content/object-cache.php ]; then
    cp /var/www/html/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/html/wp-content/object-cache.php
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable Redis Object Cache
wp redis enable --allow-root --path=/var/www/html

# Verify Redis is working
echo "Checking Redis status..."
wp redis status --allow-root --path=/var/www/html || true

# Start PHP-FPM in foreground
exec php-fpm7.4 --nodaemonize