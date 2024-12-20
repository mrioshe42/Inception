#!/bin/bash

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"$(cat /run/secrets/mysql_password)" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done


sleep 10

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    
    # Install WordPress core
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/credentials)" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --path=/var/www/html \
        --allow-root

    echo "WordPress core installation completed!"
else
    echo "WordPress already installed, updating admin password..."
    wp user update ${WP_ADMIN_USER} --user_pass="$(cat /run/secrets/credentials)" --allow-root
fi

if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
fi

if ! wp plugin is-active redis-cache --allow-root; then
    wp plugin activate redis-cache --allow-root
fi

# Configure Redis settings in wp-config.php if not already set
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp config set WP_REDIS_TIMEOUT 1 --allow-root
wp config set WP_REDIS_READ_TIMEOUT 1 --allow-root
wp config set WP_REDIS_DATABASE 0 --allow-root
wp config set WP_REDIS_PREFIX wordpress_ --allow-root

if [ ! -f /var/www/html/wp-content/object-cache.php ]; then
    wp redis enable --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Checking Redis status..."
wp redis status --allow-root

exec php-fpm7.4 --nodaemonize