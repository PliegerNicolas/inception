# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/25 12:05:58 by nicolas           #+#    #+#              #
#    Updated: 2023/09/25 13:21:51 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables during image construction
ARG	DOMAIN_NAME
ARG	CERTS_

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		nginx \
		openssl && \
	rm -f /var/cache/apk/*

# Generate a self signed SSL certificat and key
RUN	mkdir -p ${CERTS_} && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${CERTS_}/${DOMAIN_NAME}.key \
		-out ${CERTS_}/${DOMAIN_NAME}.crt \
		-subj "/C=FR/ST=Île De France/L=Paris/O=42School/CN=${DOMAIN_NAME}"

# Add configuration file
RUN	rm -f /etc/nginx/http.d/default.conf
COPY	./conf/wordpress.conf.template /etc/nginx/http.d/

# Set up env variable substitution in configuration file
RUN	mkdir -p /etc/scripts && \
	chmod -R 755 /etc/scripts
COPY	./tools/generate_wordpress_conf.sh /etc/scripts/
RUN	chmod +x /etc/scripts/generate_wordpress_conf.sh

ENTRYPOINT	["sh", "/etc/scripts/generate_wordpress_conf.sh"]

# Expose port 443 for HTTPS
EXPOSE	443

# Run NGINX. It runs as daemon in the background by default. We make it run in
# forground. Docker compose expects PID 1 to run in forground. Else it might
# consider it immediately terminated and the container shuts down.
CMD	["nginx", "-g", "daemon off;"]
