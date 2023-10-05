# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 15:28:01 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 15:41:05 by nicolas          ###   ########.fr        #
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
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts && \
mkdir -p /prometheus

# Copy prometheus configuration file
COPY	./conf/prometheus.yml /tmp/

# Set up Redis configuration
COPY	./tools/configure_prometheus.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_prometheus.sh

ENTRYPOINT	["sh", "/etc/scripts/configure_prometheus.sh"]

WORKDIR	/prometheus

# Expose the Prometheus web UI and API ports
EXPOSE	9090

# Start Prometheus
CMD	["prometheus", "--config.file=/prometheus/prometheus.yml"]
