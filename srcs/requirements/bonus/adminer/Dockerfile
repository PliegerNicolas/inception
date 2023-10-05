# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 12:06:50 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 12:30:30 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/02 18:59:38 by nicolas           #+#    #+#              #
#    Updated: 2023/10/03 18:42:36 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		curl \
		mysql-client \
		php81 \
		php81-session \
		php81-mysqli && \
	rm -f /var/cache/apk/*

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts

# Set up Redis configuration
COPY	./tools/configure_adminer.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_adminer.sh

ENTRYPOINT	["sh", "/etc/scripts/configure_adminer.sh"]

WORKDIR	"/var/www/html"

# Expose port 8888 (Default would be 8080 or 80 or 443)
EXPOSE 8888

CMD	["php81", "-S", "0.0.0.0:8888", "-t", "/var/www"]
