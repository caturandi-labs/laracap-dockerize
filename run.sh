#!/usr/bin/env sh
set -e

php-fpm -D
nginx
supervisord -c /etc/supervisor/supervisord.conf

