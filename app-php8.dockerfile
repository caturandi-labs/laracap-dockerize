FROM alpine:3.13

LABEL maintainer="catur.andi.pamungkas@gmail.com"

ENV USER=1000
ENV GROUP=1000

RUN adduser -g ${USER} -s /bin/sh -D ${GROUP}

# Install dependencies for wkhtmltopdf
RUN apk add --no-cache \
  libstdc++ \
  libx11 \
  libxrender \
  libxext \
  libssl1.1 \
  ca-certificates \
  fontconfig \
  freetype \
  ttf-dejavu \
  ttf-droid \
  ttf-freefont \
  ttf-liberation \
&& apk add --no-cache --virtual .build-deps \
  msttcorefonts-installer \
\
# Install microsoft fonts
&& update-ms-fonts \
&& fc-cache -f \
# \
# Clean up when done
&& rm -rf /tmp/* \
&& apk del .build-deps

COPY --from=surnet/alpine-wkhtmltopdf:3.15.0-0.12.6-full /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=surnet/alpine-wkhtmltopdf:3.15.0-0.12.6-full /bin/wkhtmltoimage /bin/wkhtmltoimage

RUN apk add --no-cache \
    curl \
    nginx \
    php8-fpm \
    php8-opcache \
    php8-pecl-apcu \
    php8-mysqli \
    php8-pgsql \
    php8-json \
    php8-openssl \
    php8-curl \
    php8-zlib \
    php8-soap \
    php8-xml \
    php8-fileinfo \
    php8-phar \
    php8-intl \
    php8-dom \
    php8-xmlreader \
    php8-ctype \
    php8-session \
    php8-iconv \
    php8-tokenizer \
    php8-zip \
    php8-simplexml \
    php8-mbstring \
    php8-gd \
    php8-pdo \
    php8-pdo_pgsql \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-bz2 \
    php8-redis \
    php8-intl \
    tzdata \
    supervisor \
    procps  \ 
    nodejs npm \
    && ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm \
    && ln -s /usr/bin/php8 /usr/bin/php \
    && addgroup -S php \
    && adduser -S -G php php \
    && rm -rf /var/cache/apk/* /etc/nginx/conf.d/*

# COPY files/general files/php8 /

RUN rm -rf /etc/nginx/nginx.conf

ADD files/general/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD files/php8/etc/php8/php-fpm.conf /etc/php8/php-fpm.conf


# Enable options supported by this version of PHP-FPM
RUN sed '/decorate_workers_output/s/^; //g' /etc/php8/php-fpm.conf

RUN mkdir -p /var/www/html


COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord/conf.d/*.conf /etc/supervisor/conf.d-available/


COPY run.sh /usr/local/bin/run

RUN chmod +x /usr/local/bin/run

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/php-fpm-ping || exit 1

CMD ["/usr/local/bin/run"]
