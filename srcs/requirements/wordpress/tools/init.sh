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

# Check if WordPress core files exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress config not found. Installing WordPress..."
    
    # Download WordPress core if not present
    wp core download --path=/var/www/html --allow-root
    
    # Create wp-config.php
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="$(cat /run/secrets/mysql_password)" \
        --dbhost="mariadb" \
        --path=/var/www/html \
        --allow-root
        
    # Add Redis configuration to wp-config.php
    wp config set WP_REDIS_HOST redis --allow-root --path=/var/www/html
    wp config set WP_REDIS_PORT 6379 --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_CLIENT phpredis --allow-root --path=/var/www/html
    wp config set WP_REDIS_DATABASE 0 --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_PREFIX "${DOMAIN_NAME}" --allow-root --path=/var/www/html
    wp config set WP_CACHE true --raw --allow-root --path=/var/www/html
    
    # Install WordPress
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/html \
        --allow-root
fi

# Always ensure Redis plugin is installed and configured
if ! wp plugin is-installed redis-cache --allow-root --path=/var/www/html; then
    wp plugin install redis-cache --activate --allow-root --path=/var/www/html
fi

# Make sure Redis plugin is activated
if ! wp plugin is-active redis-cache --allow-root --path=/var/www/html; then
    wp plugin activate redis-cache --allow-root --path=/var/www/html
fi

# Update object-cache.php dropin
cp /var/www/html/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/html/wp-content/object-cache.php

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Enable Redis Object Cache
wp redis enable --allow-root --path=/var/www/html

# Verify Redis is working
echo "Checking Redis status..."
wp redis status --allow-root --path=/var/www/html

# Start PHP-FPM in foreground
exec php-fpm7.4 --nodaemonize