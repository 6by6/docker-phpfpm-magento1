FROM php:7.0-fpm

WORKDIR /var/www

RUN apt-get update \
  && apt-get install -y \
    iproute2 \
    libcurl3-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    mysql-client \
    ruby \
    ruby-dev \
    libsqlite3-dev \
    sendmail-bin \
    sendmail \
    sudo \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
  bcmath \
  dom \
  gd \
  intl \
  mbstring \
  pdo_mysql \
  xsl \
  zip \
  soap

COPY --from=smartlyio/gosu:1.10-alpine /usr/local/bin/gosu /usr/local/bin/gosu

# install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# install composer
RUN cd /tmp/ && curl -s http://getcomposer.org/installer | php
RUN mv /tmp/composer.phar /usr/local/bin/composer

# install n98-magerun.phar
RUN cd /tmp/ && curl https://files.magerun.net/n98-magerun.phar > /usr/local/bin/n98 && chmod +x /usr/local/bin/n98

# install https://github.com/punkstar/mageconfigsync/
RUN curl -L https://github.com/punkstar/mageconfigsync/releases/download/0.5.0-beta.1/mageconfigsync-0.5.0-beta.1.phar > /usr/local/bin/mageconfigsync
RUN chmod +x /usr/local/bin/mageconfigsync

RUN gem install mailcatcher

RUN usermod -s /bin/bash www-data
RUN usermod -a -G tty www-data

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["php-fpm"]