FROM alpine:3.13

LABEL maintainer="catur.andi.pamungkas@gmail.com"

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
    php7-fpm \
    php7-opcache \
    php7-pecl-apcu \
    php7-mysqli \
    php7-pgsql \
    php7-json \
    php7-openssl \
    php7-curl \
    php7-zlib \
    php7-soap \
    php7-xml \
    php7-fileinfo \
    php7-phar \
    php7-intl \
    php7-dom \
    php7-xmlreader \
    php7-ctype \
    php7-session \
    php7-iconv \
    php7-tokenizer \
    php7-zip \
    php7-simplexml \
    php7-mbstring \
    php7-gd \
    php7-pdo \
    php7-pdo_pgsql \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-bz2 \
    php7-redis \
    php7-intl \
    tzdata \
    supervisor \
    procps  \ 
    nodejs npm \
    && ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
    && addgroup -S php \
    && adduser -S -G php php \
    && rm -rf /var/cache/apk/* /etc/nginx/conf.d/*

# COPY files/general files/php7 /

RUN rm -rf /etc/nginx/nginx.conf

ADD files/general/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD files/php7/etc/php7/php-fpm.conf /etc/php7/php-fpm.conf



# Enable options supported by this version of PHP-FPM
RUN sed '/decorate_workers_output/s/^; //g' /etc/php7/php-fpm.conf

RUN mkdir -p /var/www/html/public


COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord/conf.d/*.conf /etc/supervisor/conf.d-available/


COPY run.sh /usr/local/bin/run

RUN chmod +x /usr/local/bin/run


EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/php-fpm-ping || exit 1

CMD ["/usr/local/bin/run"]
