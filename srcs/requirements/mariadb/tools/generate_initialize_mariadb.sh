#!/bin/bash

# Replace placeholders in the template
cat /etc/scripts/initialize_mariadb.sh.template |
	sed -e "s#\${DB_ROOT_PASSWORD}#${DB_ROOT_PASSWORD}#g" \
		-e "s#\${DB_NAME}#${DB_NAME}#g" \
		-e "s#\${DB_USER}#${DB_USER}#g" \
		-e "s#\${DB_USER_PASSWORD}#${DB_USER_PASSWORD}#g" \
	> /etc/scripts/initialize_mariadb.sh
