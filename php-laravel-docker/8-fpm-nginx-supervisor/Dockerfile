FROM php:8-fpm

# Add docker php ext repo
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install php extensions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions mbstring zip exif pcntl gd memcached intl sqlsrv pdo_sqlsrv pdo_mysql pgsql pdo_pgsql

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip \
    git \
    curl \
    lua-zlib-dev \
    libmemcached-dev \
    libmagickwand-dev \
    nginx 

RUN pecl install imagick
RUN docker-php-ext-enable imagick

# Install supervisor
RUN apt-get install -y supervisor

# Install composer
RUN curl -sS https://getcomposer.org/installer | php >> composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy nginx/php/supervisor configs
COPY .docker/supervisor.conf /etc/supervisord.conf
COPY .docker/php.ini /usr/local/etc/php/conf.d/app.ini
COPY .docker/nginx.conf /etc/nginx/sites-enabled/default



# PHP Error Log Files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log
