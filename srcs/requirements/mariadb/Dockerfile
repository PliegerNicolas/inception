# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 17:32:44 by nicolas           #+#    #+#              #
#    Updated: 2023/09/21 23:32:08 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		mariadb \
		mariadb-client

# Create run-time mariaDB socket directory and set permrissions
RUN	mkdir -p var/run/mysqld
RUN	chown -R mysql:mysql var/run/mysqld && \
	chmod 750 /var/run/mysqld

# Copy tools and configuration files to container
#RUN	mkdir -p /etc/initialize-mariadb.d/

# Expose port 3006 (default mariadb port = 3306)
EXPOSE	3306

# Run mysqld
CMD	["mysqld", "--user=mysql"]
