# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 17:32:44 by nicolas           #+#    #+#              #
#    Updated: 2023/09/21 17:41:27 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		mariadb \
		mariadb-client

# Initiialize the mariaDB data directory
RUN	mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Create run-time mariaDB socket directory and set permrissions
RUN	mkdir -p /run/mysqld
RUN	chown mysql:mysql /run/mysqld

# Expose port 3006 (default mariadb port = 3306)
EXPOSE	3306

# Run NGINX. It runs as daemon in the background by default. We make it run in
# forground. Docker compose expects PID 1 to run in forground. Else it might
# consider it immediately terminated and the container shuts down.
CMD	["mysqld", "--user=mysql"]
