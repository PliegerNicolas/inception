# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 23:36:21 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 23:57:19 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		curl \
		tar && \
	rm -f /var/cache/apk/*

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts

# Set up Portainer configuration
COPY	./tools/configure_portainer.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_portainer.sh

# This script will be executed when the container starts.
ENTRYPOINT	["sh", "/etc/scripts/configure_portainer.sh"]

# Expose port 9433 (default would be 9000)
EXPOSE 9433

CMD	["/var/portainer/portainer"]
