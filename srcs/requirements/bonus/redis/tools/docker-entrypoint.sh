#!/bin/bash

# Configure system settings for Redis
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl vm.overcommit_memory=1

# Start Redis server
exec redis-server /usr/local/etc/redis/redis.conf