# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/02 18:59:32 by nicolas           #+#    #+#              #
#    Updated: 2023/10/05 21:03:09 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.17.5

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		redis \
	rm -f /var/cache/apk/*

# Build necessary folders.
RUN	mkdir -p /etc/scripts && chmod -R 755 /etc/scripts && \
	mkdir -p /etc/redis/conf.d && chmod -R 755 /etc/redis

# Set up redis configuration file
COPY	./conf/wp-redis.conf /etc/redis/conf.d/

# Set up Redis configuration
COPY	./tools/configure_redis.sh /etc/scripts/
RUN	chmod +x /etc/scripts/configure_redis.sh

# This script will be executed when the container starts.
ENTRYPOINT	["sh", "/etc/scripts/configure_redis.sh"]

# Expose default Redis port : 6379
EXPOSE 6379

# Run Redis server as the default command
CMD ["redis-server", "--protected-mode no"]
