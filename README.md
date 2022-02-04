# PHP-CAP // LaraCAP Containerization Builder

Suitable for PHP development with Docker Container

### Includes

#### Main Container

- PHP 8 / PHP 7
- NGINX
- Alpine Linux
- Wkhtmltopdf/Wkhtmltoimage (QT Patched) => `/bin/wkhtmltopdf`
- MariaDB 10.6
- Scheduler /Queue Worker => Supervisord


#### Utility container

- Composer
- Artisan


### Guide

Place main project to `src` directory. its automatically bind mounts into `/var/www/html`

### Running utility container

1. Running composer

> `docker-compose run --rm composer <command>`

example: `docker-compose run --rm composer update`

2. Running artisan

> `docker-compose run --rm artisan <command>`

example: `docker-compose run --rm artisan make:controller UserController -r`
