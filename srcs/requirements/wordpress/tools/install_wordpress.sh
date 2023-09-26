#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

	echo "[i] Installing WordPress..."
	wget -O wordpress.tar.gz "https://wordpress.org/wordpress-6.3.1.tar.gz";
	mkdir -p /var/www/html/
	tar -xzvf wordpress.tar.gz -C /var/www/html/ --strip-components=1;
	rm wordpress.tar.gz;

	echo "[i] Install sed."
	apk add --no-cache sed

	echo "[i] Generating /var/www/html/wp-config.php file."
	cat /tmp/wp-config.php.template |
		sed -e "s#\${DB_TITLE}#${DB_TITLE}#g" \
	  		-e "s#\${DB_USER_NAME}#${DB_USER_NAME}#g" \
	  		-e "s#\${DB_USER_PASSWORD}#${DB_USER_PASSWORD}#g" \
	  		-e "s#\${DB_HOST}#${DB_HOST}#g" \
		> /var/www/html/wp-config.php

	echo "[i] Remove sed."
	apk del sed

else

	echo "[i] Wordpress already downloaded"

fi

echo "[i] Remove wp-config.php.template"
rm -rf /tmp/wp-config.php.template

echo "[i] Create www-data user/group"
adduser -S -D -H -G www-data -s /sbin/nologin www-data

echo "[i] Set /var/www/html/ property and rights."
chown -R www-data:www-data /var/www/html/*
chown -R 755 /var/www/html/*
mkdir -p /run/php/
touch /run/php/php81-fpm.pid

exec "$@"
