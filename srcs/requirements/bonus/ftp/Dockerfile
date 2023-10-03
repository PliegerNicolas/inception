# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/02 18:59:38 by nicolas           #+#    #+#              #
#    Updated: 2023/10/03 17:24:54 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		vsftpd && \
	rm -f /var/cache/apk/*

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts && \
	mkdir -p /etc/vsftpd/conf.d && chmod -R 755 /etc/vsftpd

# Set up redis configuration file
COPY	./conf/wp-vsftpd.conf /etc/vsftpd/conf.d/

# Set up Redis configuration
COPY	./tools/configure_vsftpd.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_vsftpd.sh

ENTRYPOINT	["sh", "/etc/scripts/configure_vsftpd.sh"]

# Open default FTP Data Ports.
# - Port 20 : used for data transfer.
# - Port 21 : used for communication.
EXPOSE 20 21

# Start vsftpd
CMD	["sleep", "infinity"]
#CMD	["vsftpd", "/etc/vsftpd/vsftpd.conf"]
