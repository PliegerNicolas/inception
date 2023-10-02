#!/bin/sh

# Wait for mariaDB ENTRYPOINT script to finish.
until mysqladmin ping -h mariadb -u${DB_USER_NAME} -p${DB_USER_PASSWORD}; do
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

	echo "[i] Inforce HTTPS/SSH on wordpress by default."
	wp option update siteurl "https://${DOMAIN_NAME}"
	wp option update home "https://${DOMAIN_NAME}"
	wp config set FORCE_SSL_ADMIN true --raw

	echo "[i] Install 'bravada' WordPress theme and delete some default ones."
	wp theme install bravada --activate
	wp theme delete twentytwentyone
	wp theme delete twentytwentytwo

	echo "[i] Uninstall inactive extensions"
	wp plugin delete akismet hello

	echo "[i] Disable cron."
	wp config set DISABLE_WP_CRON true

	# BONUS : REDIS
	echo "[i] Configure redis cache."

	echo "[i] Add Redis variables to wp-conf.php."
	wp config set WP_REDIS_HOST ${REDIS_HOST}
	wp config set WP_REDIS_PORT 6379
	wp config set WP_REDIS_DATABASE 0
	wp config set WP_CACHE true

	echo "[i] Install Redis plugin."
	wp plugin install redis-cache --activate
	wp plugin update --all

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
