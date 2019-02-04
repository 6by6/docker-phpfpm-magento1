# sixbysix/phpfpm-mage1

## Overview
A phpfpm container for Magento 1 developer use. Prebuilt with the following tools:
- [composer.phar](https://getcomposer.org)
- [mageconfigsync](https://github.com/punkstar/mageconfigsync)
- [n98-magerun.phar](https://github.com/netz98/n98-magerun)
- xdebug

## Usage
This container uses [`gosu`](https://github.com/tianon/gosu) to convert the UID of the container www-data to whatever is required by the host. You should, therefore, pass a `UID` env variable containing the required value.

**docker**
```
docker run --rm -e UID=`id -u` -it sixbysix-phpfpm-mage1:7.2 /bin/bash
```

**docker-compose**
```
services:
  phpfpm:
    image: sixbysix-phpfpm-mage1:7.2
    environment:
      - UID=${PHP_UID}
```

