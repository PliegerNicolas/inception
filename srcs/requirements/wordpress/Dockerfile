# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/23 21:13:39 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 04:19:39 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Retrieve .env variables during image construction
ARG	DB_TITLE
ARG	DB_USER_NAME
ARG	DB_USER_PASSWORD
ARG	DB_HOST

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		curl \
		mysql-client \
		php81 \
		php81-fpm \
		php81-phar \
		php81-mysqli \
		php81-mbstring \
		php81-xml \
		php81-curl \
		php81-zip \
		php81-dom \
		php81-exif \
		php81-fileinfo \
		php81-gd \
		php81-pecl-imagick \
		php81-iconv \
		php81-intl \
		php81-tokenizer \
		php81-ctype \
		php81-redis && \
	rm -f /var/cache/apk/*

# Insert static website (index.html)
COPY	./conf/index.html /tmp/
COPY	./conf/styles.css /tmp/

# Set up php-fpm configuration
COPY	./conf/www.conf /etc/php81/php-fpm.d/

# Set up WordPress configuration
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts
COPY	./tools/install_wordpress.sh /etc/scripts/
RUN	chmod +x /etc/scripts/install_wordpress.sh

ENTRYPOINT	["sh", "/etc/scripts/install_wordpress.sh"]

WORKDIR	"/var/www/html"

# Expose PHP-FPM port
EXPOSE	9000

# Start PHP-FPM
CMD	["php-fpm81", "-F"]
