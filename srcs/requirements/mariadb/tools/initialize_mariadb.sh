#!/bin/sh

# Based on "https://github.com/yobasystems/alpine-mariadb/"

# Set run-time folder for mariadb
if [ -d "/run/mysql" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then

	echo "[i] MySQL directory not found, creating initial DB."

	chown -R mysql:mysql /var/lib/mysql
	# Initialize database
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null 2>&1

	# Create temporary file to intialize database content
	temp_file="/tmp/my_temp_file.$(date +%s)"
	touch "${temp_file}"

	if [ ! -f "$temp_file" ]; then
		return 1
	fi

	cat << EOF > $temp_file

	USE mysql;
	FLUSH PRIVILEGES ;
	GRANT ALL ON *.* TO 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}' WITH GRANT OPTION ;
	SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${DB_ROOT_PASSWORD}') ;
	DROP DATABASE IF EXISTS test ;
	FLUSH PRIVILEGES ;

EOF

	if [ "${DB_TITLE}" != "" ]; then

		echo "[i] Creating data base ${DB_TITLE}..."
		echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"

		# Create database
		echo "CREATE DATABASE IF NOT EXISTS \`${DB_TITLE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $temp_file

		# Create admin if not exist

		if [ "${DB_ADMIN_NAME}" != "" ]; then
			if ! mysql -u root -p"${DB_ROOT_PASSWORD}" -e "SELECT 1 FROM mysql.user WHERE user = '${DB_ADMIN_NAME}'" | grep -q 1; then
				echo "[i] Creating user: ${DB_ADMIN_NAME}..."
				echo "CREATE USER '${DB_ADMIN_NAME}'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';" >> $temp_file
				echo "GRANT ALL ON \`${DB_TITLE}\`.* to '${DB_ADMIN_NAME}'@'localhost';" >> $temp_file
			else
				echo "[i] User '${DB_ADMIN_NAME}' already exists in database."
			fi
		fi

		# Create user if not exist
		if [ "${DB_USER_NAME}" != "" ]; then
			if ! mysql -u root -p"${DB_ROOT_PASSWORD}" -e "SELECT 1 FROM mysql.user WHERE user = '${DB_USER_NAME}'" | grep -q 1; then
				echo "[i] Creating user: ${DB_USER_NAME}..."
				echo "CREATE USER '${DB_USER_NAME}'@'localhost' IDENTIFIED BY '${DB_USER_PASSWORD}';" >> $temp_file
				echo "GRANT ALL ON \`${DB_TITLE}\`.* to '${DB_USER_NAME}'@'localhost';" >> $temp_file
			else
				echo "[i] User '${DB_USER_NAME}' already exists in database."
			fi
		fi

		/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $temp_file
		rm -f $temp_file
		echo 'MySQL init process done. Ready for start up.'
	fi
else
	echo "[i] MySQL directory already present, skipping creation."
	chown -R mysql:mysql /var/lib/mysql
fi

exec	/usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 > /dev/null 2>&1
