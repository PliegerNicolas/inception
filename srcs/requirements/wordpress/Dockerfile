# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/23 21:13:39 by nicolas           #+#    #+#              #
#    Updated: 2023/09/24 21:06:09 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables during image construction
ARG	DB_TITLE
ARG	DB_PREFIX
ARG	DB_HOST
ARG	DB_ROOT_PASSWORD
ARG	DB_USER_NAME
ARG	DB_USER_PASSWORD

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		php82 \
		php82-fpm \
		php82-mysqli \
		php82-mbstring \
		php82-xml \
		php82-curl \
		php82-zip && \
	rm -f /var/cache/apk/*

# Set up WordPress configuration
COPY	./conf/wp-config.php /tmp/

RUN	mkdir -p /etc/scripts && \
	chmod -R 755 /etc/scripts
COPY	./tools/install_wordpress.sh /etc/scripts/
RUN	chmod +x /etc/scripts/install_wordpress.sh

ENTRYPOINT	["/etc/scripts/install_wordpress.sh"]

WORKDIR	"/var/www/html"

# Expose PHP-FPM port
EXPOSE	9000

# Start PHP-FPM
CMD	["php-fpm82", "-F"]
