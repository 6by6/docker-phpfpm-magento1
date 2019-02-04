# sixbysix/phpfpm-mage1

## Overview
A phpfpm container for Magento 1 developer use. Prebuilt with the following tools:
- [composer.phar](https://getcomposer.org)
- [mageconfigsync](https://github.com/punkstar/mageconfigsync)
- [n98-magerun.phar](https://github.com/netz98/n98-magerun)
- xdebug

## Usage

### Environmental Variables
<dl>
  <dt><strong>UID</strong></dt>
  <dd>This container uses [`gosu`](https://github.com/tianon/gosu) to convert the UID of the container www-data to whatever is required by the host. You should, therefore, pass a `UID` env variable containing the required value.</dd>
  <dt><strong>XDEBUG_IDEKEY</strong></dt>
  <dd>If you're looking using Xdebug for debugging in your IDE (phpstorm, for example) set this value to a unique project key so your IDE can authorise connections.</dd>
</dl> 

**docker**
```
docker run --rm -e UID=`id -u` -e XDEBUG_IDEKEY=test-xdebug -it sixbysix-phpfpm-mage1:7.2 /bin/bash
```

**docker-compose**
```
services:
  phpfpm:
    image: sixbysix-phpfpm-mage1:7.2
    environment:
      - UID=${PHP_UID}
      - XDEBUG_IDEKEY=${XDEBUG_IDEKEY}
```

