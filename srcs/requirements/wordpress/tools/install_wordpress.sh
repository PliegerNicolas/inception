#!/bin/sh

# Wait for mariaDB ENTRYPOINT script to finish.
until mysqladmin ping -h mariadb --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 1
done

echo "[i] MariaDB is ready."

if [ ! -f /var/www/html/wp-config.php ]; then


	echo "[i] Install WP-CLI..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

	echo "[i] Download wordpress at /var/www/html path."
	wp core download --path=/var/www/html --version=6.3.1 --locale=fr_FR

	echo "[i] Configure wp-config.php file."
	wp config create --path=/var/www/html \
		--dbname="${DB_TITLE}" \
		--dbuser="${DB_USER_NAME}" \
		--dbpass="${DB_USER_PASSWORD}" \
		--dbhost="${DB_HOST}:3306"

	echo "[i] Install wordpress website process with admin account."
	wp core install --path=/var/www/html \
		--url="${DOMAIN_NAME}" \
		--title="${DOMAIN_NAME}" \
		--admin_user="${DB_USER_NAME}" \
		--admin_password="${DB_USER_PASSWORD}" \
		--admin_email="${DB_USER_NAME}@gmail.com"

	echo "[i] Add user account."
	wp user create \
		user \
		user@gmail.com \
		--user_pass="password" \
		--role="subscriber"

	echo "[i] Install 'inspiro' WordPress theme."
	wp theme install bravada --activate

else

	echo "[i] Wordpress already downloaded"

fi

echo "[i] Create www-data user/group"
adduser -S -D -H -G www-data -s /sbin/nologin www-data

echo "[i] Set /var/www/html/ property and rights."
chown -R www-data:www-data /var/www/html
chown -R 755 /var/www/html

echo "[i] Build php81 run-time directory."
mkdir -p /run/php/
touch /run/php/php81-fpm.pid

exec "$@"
