#!/bin/sh

# Wait for mariaDB ENTRYPOINT script to finish.
until mysqladmin ping -h mariadb -u${DB_USER_NAME} -p${DB_USER_PASSWORD}i > /dev/null 2>&1; do
	echo "[i]Waiting for MariaDB to be ready..."
	sleep 2
done
echo "[i] MariaDB is ready."

echo "[i] Make ${WP_PATH} & ${STATIC_PATH} folder if needed."
mkdir -p ${WP_PATH}
mkdir -p ${STATIC_PATH}

if [ ! -f ${STATIC_PATH}/index.html ]; then

	echo "[i] Insert static website (index.html)."
	mv /tmp/index.html ${STATIC_PATH}

fi

if [ ! -f ${WP_PATH}/wp-config.php ]; then

	cd ${WP_PATH}

	echo "[i] Install WP-CLI..."
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp


	echo "[i] Download wordpress at ${WP_PATH} path."
	wp core download --version=6.3.1 --locale=fr_FR

	echo "[i] Configure wp-config.php file."
	wp config create \
		--dbname="${DB_TITLE}" \
		--dbuser="${DB_USER_NAME}" \
		--dbpass="${DB_USER_PASSWORD}" \
		--dbhost="${DB_HOST}:3306"

	echo "[i] Install wordpress website process with admin account."
	wp core install \
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
	wp option update siteurl "https://${DOMAIN_NAME}/wordpress"
	wp option update home "https://${DOMAIN_NAME}/wordpress"
	wp config set FORCE_SSL_ADMIN true --raw

	echo "[i] Install 'bravada' WordPress theme and delete some default ones."
	wp theme install bravada --activate
	wp theme delete twentytwentyone twentytwentytwo

	echo "[i] Uninstall inactive extensions"
	wp plugin delete akismet hello

	echo "[i] Disable cron."
	wp config set DISABLE_WP_CRON true --raw

	# BONUS : REDIS
	echo "[i] Configure redis cache."

	echo "[i] Add Redis variables to wp-conf.php."
	wp config set WP_REDIS_HOST ${REDIS_HOST}
	wp config set WP_REDIS_PORT 6379
	wp config set WP_REDIS_DATABASE 0
	wp config set WP_CACHE true --raw

	echo "[i] Install Redis plugin."
	wp plugin install redis-cache --activate --version=2.4.4
	wp plugin update --all

	echo "[i] Enable Object Cache."
	wp redis enable

	cd ${HTML_PATH}

fi

echo "[i] Create www-data user/group"
adduser -S -D -H -G www-data -s /sbin/nologin www-data

echo "[i] Set ${HTML_PATH} property and rights."
chown -R www-data:www-data ${HTML_PATH}
chmod -R 755 ${HTML_PATH}
find ${HTML_PATH} -type f -exec chmod 644 {} \;

echo "[i] Build php81 run-time directory."
mkdir -p /run/php/
touch /run/php/php81-fpm.pid

exec "$@"
