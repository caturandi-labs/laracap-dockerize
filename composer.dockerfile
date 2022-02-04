FROM composer

LABEL maintainer="catur.andi.pamungkas@gmail.com"

ENV COMPOSERUSER=1000
ENV COMPOSERGROUP=1000


RUN adduser -g ${COMPOSERUSER} -s /bin/sh -D ${COMPOSERGROUP}


ENTRYPOINT [ "composer" ]