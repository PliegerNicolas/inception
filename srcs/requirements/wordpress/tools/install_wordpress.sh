#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

	echo "[i] Installing WordPress..."
	wget -O wordpress.tar.gz "https://wordpress.org/wordpress-6.3.1.tar.gz";
	mkdir -p /var/www/html/
	tar -xzvf wordpress.tar.gz -C /var/www/html/ --strip-components=1;
	rm wordpress.tar.gz;

	echo "[i] Adding sed."
	apk add --no-cache sed
	echo "[i] Generating /var/www/html/wp-config.php file."
	cat /tmp/wp-config.php.template |
		sed -e "s#\${DB_TITLE}#${DB_TITLE}#g" \
	  		-e "s#\${DB_USER_NAME}#${DB_USER_NAME}#g" \
	  		-e "s#\${DB_USER_PASSWORD}#${DB_USER_PASSWORD}#g" \
	  		-e "s#\${DB_HOST}#${DB_HOST}#g" \
		> /var/www/html/wp-config.php

	chown www-data:www-data /var/www/html/wp-config.php

	echo "[i] Remove sed and template."
	rm -f /etc/wp-config.php.template

else

	echo "[i] Wordpress already downloaded"
	echo "[i] Remove sed and template."
	rm -rf /tmp/wp-config.php.template

fi

chown -R www-data:www-data /var/www/html/

exec "$@"
