FROM composer/composer:php5-alpine
MAINTAINER Repometric <docker@repometric.com>
ARG WORKDIR
COPY composer.json /composer
RUN composer global require phpcheckstyle/phpcheckstyle
ENTRYPOINT /bin/sh