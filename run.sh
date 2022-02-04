#!/usr/bin/env sh
# set -e

# Run Supervisord
supervisord -c /etc/supervisor/supervisord.conf

#  Run PHP-FPM
php-fpm -D

# Run NGINX
nginx

