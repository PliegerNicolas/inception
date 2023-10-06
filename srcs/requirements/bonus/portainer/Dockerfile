# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 23:36:21 by nicolas           #+#    #+#              #
#    Updated: 2023/10/06 17:29:36 by nplieger         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Retrieve .env variables during image construction
ARG	DOMAIN_NAME
ARG	PORTAINER_CERTS

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		curl \
		tar \
		openssl && \
	rm -f /var/cache/apk/*

# Generate a self signed SSL certificat and key
RUN	mkdir -p ${PORTAINER_CERTS} && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${PORTAINER_CERTS}/${DOMAIN_NAME}.key \
		-out ${PORTAINER_CERTS}/${DOMAIN_NAME}.crt \
		-subj "/C=FR/ST=Île De France/L=Paris/O=42School/CN=${DOMAIN_NAME}"

# Define environment variables for SSL configuration
ENV	TLS=on
ENV	TLSKEY=${PORTAINER_CERTS}/${DOMAIN_NAME}.key
ENV	TLSCERT=${PORTAINER_CERTS}/${DOMAIN_NAME}.crt

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts

# Set up Portainer configuration
COPY	./tools/configure_portainer.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_portainer.sh

# This script will be executed when the container starts.
ENTRYPOINT	["sh", "/etc/scripts/configure_portainer.sh"]

WORKDIR /var/portainer

# Expose port 9443 (default would be 9000)
EXPOSE 9001

CMD	["/var/portainer/portainer"]
