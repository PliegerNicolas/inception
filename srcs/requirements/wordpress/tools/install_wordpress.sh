#!/bin/sh

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then

	echo "[i] Installing WordPress..."
	wget https://wordpress.org/wordpress-6.3.1.tar.gz
	tar -xzvf wordpress-6.3.1.tar.gz
	rm -rf wordpress-6.3.1.tar.gz

	echo "[i] Adding custom wp-config.php file."
	mv /tmp/wp-config.php ./wordpress/
else
	echo "[i] Wordpress already downloaded"
	rm -rf ~/tmp/wp-config.php
fi

exec "$@"
