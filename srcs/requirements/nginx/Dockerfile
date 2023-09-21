# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 14:56:02 by nicolas           #+#    #+#              #
#    Updated: 2023/09/21 17:25:01 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables
ARG	DOMAIN_NAME
ARG	CERTS_

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		nginx \
		openssl

# Generate a self signed SSL certificat and key
RUN	mkdir -p ${CERTS_} && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ${CERTS_}/${DOMAIN_NAME}.key \
		-out ${CERTS_}/${DOMAIN_NAME}.crt \
		-subj "/C=FR/ST=Île De France/L=Paris/O=42School/CN=${DOMAIN_NAME}"

# Generate and populate with .env variables 'nginx.conf'
# 1. build temporary 'generate_conf_file' directory.
# 2. install sed dependency.
# 3. copy nginx.config.template and generate_nginx_config.sh.
# 4. modify permissions on .sh file and execute it.
# 5. delete generate_conf_file foldler and remove sed dependency.
RUN	mkdir -p /etc/nginx/generate_conf_file
RUN	apk update && apk upgrade && apk add --no-cache sed
COPY	./tools/generate_nginx_config.sh /etc/nginx/generate_conf_file/
COPY	./conf/nginx.config.template /etc/nginx/generate_conf_file/
RUN	chmod +x /etc/nginx/generate_conf_file/generate_nginx_config.sh
RUN	sh /etc/nginx/generate_conf_file/generate_nginx_config.sh
RUN	rm -rf /etc/nginx/generate_conf_file && apk del --purge sed

# Expose port 443 for HTTPS traffic
EXPOSE	443

# Run NGINX. It runs as daemon in the background by default. We make it run in
# forground. Docker compose expects PID 1 to run in forground. Else it might
# consider it immediately terminated and the container shuts down.
CMD	["nginx", "-g", "daemon off;"]
