#!/bin/sh

# Set run-time folder for mariadb
if [ -d "/run/mysql" ]; then
	echo "[i] mysqld already present, skipping creation"
else
	echo "[i] musqld not found, creating..."
	mkdir -p /run/mysqld
fi
chown -R mysql:mysql /run/mysqld

# Initialize database
mysql_install_db --user=mysql --ldata=/var/lib/mysql

# Create temporary file to intialize database content
temp_file="/tmp/my_temp_file.$(data +%s)"
if [ ! -f "$temp_file" ]; then
	return 1
fi

cat << EOF > $temp_file
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '${DB_ROOT_PASSWORD}' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${DB_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

if [ -n "${DB_TITLE}" ]; then

	echo "[i] Creating data base ${DB_TITLE}..."
	echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
	echo "CREATE DATABASE IF NOT EXISTS \`${DB_TITLE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $temp_file

	# Create admin if not exist
	if [ -n "${DB_ADMIN_NAME}" ]; then
		if ! mysql -u root -e "SELECT 1 FROM mysql.user WHERE user = '${DB_ADMIN_NAME}'" | grep -q 1; then
			echo "[i] Creating user: ${DB_ADMIN_NAME}..."
			echo "CREATE USER '${DB_ADMIN_NAME}'@'%' IDENTIFIED BY '${DB_ADMIN_PASSWORD}';" >> $temp_file
			echo "GRANT ALL ON \`${DB_TITLE}\`.* to '${DB_ADMIN_NAME}'@'%';" >> $temp_file
		else
			echo "[i] User '${DB_ADMIN_NAME}' already exists in database."
		fi
	fi

	# Create admin if not exist
	if [ -n "${DB_USER_NAME}" ]; then
		if ! mysql -u root -e "SELECT 1 FROM mysql.user WHERE user = '${DB_USER_NAME}'" | grep -q 1; then
			echo "[i] Creating user: ${DB_USER_NAME}..."
			echo "CREATE USER '${DB_USER_NAME}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';" >> $temp_file
			echo "GRANT ALL ON \`${DB_TITLE}\`.* to '${DB_USER_NAME}'@'%';" >> $temp_file
		else
			echo "[i] User '${DB_USER_NAME}' already exists in database."
		fi
	fi

	#
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $temp_file
	rm -f $temp_file

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo
fi
