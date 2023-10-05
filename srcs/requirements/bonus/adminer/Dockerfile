# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 12:44:31 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 12:44:44 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Retrieve .env variables during image construction
ARG HTML_PATH


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

WORKDIR	"${HTML_PATH}"

# Expose port 8888 (Default would be 8080 or 80 or 443)
EXPOSE 8888

CMD	["php81", "-S", "0.0.0.0:8888", "-t", "/var/www"]
