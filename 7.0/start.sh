#!/bin/bash

usermod -u $UID www-data
groupmod -g $UID www-data

if [ -z "$NO_XDEBUG" ]; then

if [ -z "$XDEBUG_PROFILER_DIR" ]; then
    XDEBUG_PROFILER_DIR=/cachegrind
fi

HOST_IP=`/sbin/ip route | awk '/default/ { print $3 }'`

cat > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini <<- EOF
zend_extension=xdebug.so
EOF

mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

cat >> /usr/local/etc/php/php.ini <<- EOF
xdebug.idekey=$XDEBUG_IDEKEY
xdebug.remote_connect_back=Off
xdebug.remote_enable=On
xdebug.remote_host=$HOST_IP
xdebug.remote_port=9000
xdebug.remote_autostart=true
xdebug.remote_handler=dbgp
xdebug.profiler_enable_trigger=On
xdebug.profiler_output_dir=$XDEBUG_PROFILER_DIR
EOF
fi

if [ -z "$NO_MAILCATCHER" ]; then
cat >> /usr/local/etc/php/php.ini <<- EOF
sendmail_path=/usr/bin/env catchmail -f $MAILCATCHER_SENDER --smtp-ip $MAILCATCHER_IP --smtp-port 25
EOF
fi

# generate app/etc/local.xml
if [ -f "/var/www/app/etc/local.xml.docker" ]; then
  gosu www-data bash -c 'eval "$(</var/www/app/etc/local.xml.docker)" > /var/www/app/etc/local.xml'
else
  echo "Could not create /var/www/app/etc/local.xml as there is no template at /var/www/app/etc/local.xml.docker"
fi

if [ ! -z "$DEV_MODE" ]; then
export MAGE_IS_DEVELOPER_MODE=1
fi

if [[ "$@" = "php-fpm" ]]; then
  $@
else
  gosu www-data $@
fi