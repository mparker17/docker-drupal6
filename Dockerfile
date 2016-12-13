FROM php:5-apache

RUN a2enmod rewrite

RUN apt-get update \
	&& apt-get install -y libpng12-dev libjpeg-dev libpq-dev mysql-client php5-mysql \
	&& rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install gd mbstring mysql pdo pdo_mysql pdo_pgsql zip

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 6.38
ENV DRUPAL_MD5 2ece34c3bb74e8bff5708593fa83eaac

RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites

EXPOSE 80
CMD ["apache2-foreground"]
