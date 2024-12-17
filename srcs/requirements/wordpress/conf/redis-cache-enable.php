<?php
require_once '/var/www/html/wp-load.php';

if (!wp_using_ext_object_cache()) {
    wp_cache_enable();

    if (wp_using_ext_object_cache()) {
        echo "Redis Object Cache enabled successfully\n";
    } else {
        echo "Failed to enable Redis Object Cache\n";
    }
}
