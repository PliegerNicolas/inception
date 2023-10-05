# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/02 18:59:38 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 21:02:51 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Retrieve .env variables during image construction
ARG	DOMAIN_NAME
ARG	FTP_CERTS

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		vsftpd \
		openssl && \
	rm -f /var/cache/apk/*

# Generate a self signed SSL certificat and key
RUN	mkdir -p ${FTP_CERTS} && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${FTP_CERTS}/${DOMAIN_NAME}.key \
		-out ${FTP_CERTS}/${DOMAIN_NAME}.crt \
		-subj "/C=FR/ST=Île De France/L=Paris/O=42School/CN=${DOMAIN_NAME}"

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts && \
	mkdir -p /etc/vsftpd/conf.d && chmod -R 755 /etc/vsftpd

# Set up redis configuration file
COPY	./conf/wp-vsftpd.conf /etc/vsftpd/conf.d/

# Set up Redis configuration
COPY	./tools/configure_vsftpd.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_vsftpd.sh

# This script will be executed when the container starts.
ENTRYPOINT	["sh", "/etc/scripts/configure_vsftpd.sh"]

# Open default FTP Data Ports.
# - Port 20 : used for data transfer.
# - Port 21 : used for communication.
EXPOSE 20 21

# Start vsftpd
CMD	["vsftpd", "/etc/vsftpd/vsftpd.conf"]
