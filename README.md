# sixbysix/phpfpm-mage1

## Overview
A phpfpm container for Magento 1 developer use. Prebuilt with the following tools:
- [composer.phar](https://getcomposer.org)
- [mageconfigsync](https://github.com/punkstar/mageconfigsync)
- [n98-magerun.phar](https://github.com/netz98/n98-magerun)
- [mailcatcher](https://mailcatcher.me/)
- xdebug

## Usage

### Environmental Variables
<dl>
  <dt><strong>UID</strong></dt>
  <dd>This container uses [`gosu`](https://github.com/tianon/gosu) to convert the UID of the container www-data to whatever is required by the host. You should, therefore, pass a `UID` env variable containing the required value.</dd>
  <dt><strong>XDEBUG_IDEKEY</strong></dt>
  <dd>If you're looking using Xdebug for debugging in your IDE (phpstorm, for example) set this value to a unique project key so your IDE can authorise connections.</dd>
  <dt><strong>MAILCATCHER_SENDER</strong></dt>
  <dd>Sender email address for the mailcatcher container</dd>
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

### app/etc/local.xml 
The magento configuration XML file is generated automatically when you start the container.

This feature relies on the presence of a app/etc/local.xml.docker template file within the Magento project itself, for example:

```
cat <<EOF
<?xml version="1.0"?>
<config>
    <global>
        <install>
            <date><![CDATA[Mon, 09 Sep 2013 13:55:25 +0000]]></date>
        </install>
        <crypt>
            <key><![CDATA[$MAGE_CRYPT_KEY]]></key>
        </crypt>
        <disable_local_modules>false</disable_local_modules>
        <resources>
            <db>
                <table_prefix><![CDATA[]]></table_prefix>
            </db>
            <default_setup>
                <connection>
                    <host><![CDATA[$MYSQL_HOST]]></host>
                    <username><![CDATA[$MYSQL_USER]]></username>
                    <password><![CDATA[$MYSQL_PASSWORD]]></password>
                    <dbname><![CDATA[$MYSQL_DATABASE]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </default_setup>
        </resources>
        <session_save><![CDATA[files]]></session_save>
    </global>
    <admin>
        <routers>
            <adminhtml>
                <args>
                    <frontName><![CDATA[$MAGE_ADMIN_URL]]></frontName>
                </args>
            </adminhtml>
        </routers>
    </admin>
</config>
EOF
```

You may inject any env variable required into this file:

```
  phpfpm:
    image: sixbysix-phpfpm-mage1:7.2
    volumes_from:
      - codebase
    environment:
      - UID=${PHP_UID}
      - XDEBUG_IDEKEY
      - MYSQL_HOST=percona
      - MYSQL_DATABASE
      - MYSQL_USER
      - MYSQL_PASSWORD
```

## Mailcatcher

*See [https://mailcatcher.me](https://mailcatcher.me) for description.*
$MAILCATCHER_SENDER