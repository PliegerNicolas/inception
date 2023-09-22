# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 17:32:44 by nicolas           #+#    #+#              #
#    Updated: 2023/09/23 01:36:48 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables during image construction
ARG	DB_TITLE
ARG	DB_ROOT_PASSWORD
ARG	DB_USER_NAME
ARG	DB_USER_PASSWORD
ARG	DB_ADMIN_NAME
ARG	DB_ADMIN_PASSWORD

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		mariadb \
		mariadb-client && \
	rm -f /var/cache/apk/*

# Setup mariaDB
# 1. Generate all necessary folders and set permissions.
# 2. copy initialize_mariadb.sh file to container
# 3. set permission and execute it
RUN	mkdir -p /etc/scripts && \
	chmod -R 755 /etc/scripts
COPY	./tools/initialize_mariadb.sh /etc/scripts/
RUN	chmod +x /etc/scripts/initialize_mariadb.sh

# Set script executed at launch.
ENTRYPOINT	["/etc/scripts/initialize_mariadb.sh"]

# Expose port 3006 (default mariadb port = 3306)
EXPOSE	3306

CMD	["usr/bin/mysqld", "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0"]
