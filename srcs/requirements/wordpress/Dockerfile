# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/23 21:13:39 by nicolas           #+#    #+#              #
#    Updated: 2023/09/24 14:57:51 by nplieger         ###   ########.fr        #
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
		php82-fpm \
		php82-mysqli \
		php82-mbstring \
		php82-xml \
		php82-curl \
		php82-zip && \
	rm -f /var/cache/apk/*

# Add folder for php82 run-time files.
RUN	mkdir -p /run/php

# Add www-data to group www-data
RUN	adduser -S -D -G www-data www-data

# Add php-fpm configuration file.
COPY	./conf/www.conf /etc/php82/php-fpm.d/www.conf

# Copy temporarily in /tmp/. install_wordpress.sh will handle the move if necessary.
COPY	./conf/wp-config.php /tmp/

# Copy WordPress installation script
RUN	mkdir -p /etc/scripts && \
	chmod -R 755 /etc/scripts
COPY	./tools/install_wordpress.sh /etc/scripts/
RUN	chmod +x /etc/scripts/install_wordpress.sh

# Launch install_wordpress.sh script at container launch
ENTRYPOINT	["/etc/scripts/install_wordpress.sh"]

WORKDIR	/var/www/html

# Expose port 9000.
EXPOSE	9000

CMD	["/usr/sbin/php-fpm82", "-F"]
