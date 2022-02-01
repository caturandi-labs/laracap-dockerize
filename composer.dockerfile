FROM composer:2

LABEL maintainer="catur.andi.pamungkas@gmail.com"

ENV COMPOSERUSER=nginx
ENV COMPOSERGROUP=nginx


RUN adduser -g ${COMPOSERUSER} -s /bin/sh -D ${COMPOSERGROUP}


ENTRYPOINT [ "composer" ]