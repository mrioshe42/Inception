#!/bin/bash

service fail2ban start

# Start nginx in foreground
nginx -g "daemon off;"
