#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

	echo "[i] Installing WordPress..."
	wget -O wordpress.tar.gz "https://wordpress.org/wordpress-6.3.1.tar.gz";
	mkdir -p /var/www/html/
	tar -xzvf wordpress.tar.gz -C /var/www/html/ --strip-components=1;
	rm wordpress.tar.gz;

	echo "[i] Adding custom wp-config.php file."
	mv /tmp/wp-config.php /var/www/html/

else

	echo "[i] Wordpress already downloaded"
	rm -rf /tmp/wp-config.php

fi

chown -R root:root /var/www/html/

exec "$@"
