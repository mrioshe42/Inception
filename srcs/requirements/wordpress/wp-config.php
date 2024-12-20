<?php
if (!defined('WP_HOME')) {
    define('WP_HOME', 'https://' . getenv('DOMAIN_NAME'));
}
if (!defined('WP_SITEURL')) {
    define('WP_SITEURL', WP_HOME);
}

define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', file_get_contents('/run/secrets/mysql_password'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

// Table Prefix
$table_prefix = 'wp_';

//redis
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_REDIS_DATABASE', 0);
define('WP_REDIS_CLIENT', 'phpredis');

// Debug Settings
define('WP_DEBUG', false);

// Memory and Performance
define('WP_MEMORY_LIMIT', '256M');
define('WP_MAX_MEMORY_LIMIT', '512M');
define('WP_CACHE', true);
define('EMPTY_TRASH_DAYS', 7);
define('WP_POST_REVISIONS', 5);

// PHP Settings
ini_set('memory_limit', '256M');
ini_set('max_execution_time', '300');
ini_set('post_max_size', '64M');
ini_set('upload_max_filesize', '64M');

// Security Settings
define('DISALLOW_FILE_EDIT', true);
define('FORCE_SSL_ADMIN', true);
define('WP_AUTO_UPDATE_CORE', 'minor');

// Additional Security
define('AUTOMATIC_UPDATER_DISABLED', false);
define('WP_HTTP_BLOCK_EXTERNAL', false);
define('DISALLOW_UNFILTERED_HTML', true);

// Define WordPress Content Directory
define('WP_CONTENT_DIR', __DIR__ . '/wp-content');
// Use WP_HOME instead of $_SERVER['HTTP_HOST']
define('WP_CONTENT_URL', WP_HOME . '/wp-content');

// Absolute path to the WordPress directory
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

// Sets up WordPress vars and included files
require_once ABSPATH . 'wp-settings.php';