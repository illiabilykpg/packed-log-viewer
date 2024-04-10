FROM ubuntu:noble

LABEL version="1.0"
LABEL name="packed-log-viewer"
LABEL description="opcodesio/log-viewer in a container"
MAINTAINER illia.bilyk@paygames.net

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt update
RUN apt install -y git curl libxml2 php php-curl php-pdo php-xml php-sqlite3 composer


RUN composer create-project --prefer-dist laravel/laravel
WORKDIR laravel
RUN composer require opcodesio/log-viewer && php artisan log-viewer:publish
RUN sed -i '/route_path/s/log-viewer/\//g' ./vendor/opcodesio/log-viewer/config/log-viewer.php
RUN sed -i "/absolute\/paths\//a '/ext-logs'" ./vendor/opcodesio/log-viewer/config/log-viewer.php

RUN mkdir /laravel/storage/logs/ext-logs

EXPOSE 80
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
