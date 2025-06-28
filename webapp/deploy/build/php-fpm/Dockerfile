FROM php:8.1.5-fpm

WORKDIR /var/www

RUN apt update \
    && apt-get install -y \
    libmagickwand-dev \
    libmagickcore-dev \
    libzip-dev \
    libwebp-dev

RUN docker-php-ext-install exif \
    && PHP_OPENSSL=yes \
    && docker-php-ext-install xml \
    && docker-php-ext-install filter \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli

CMD ["php-fpm"]
