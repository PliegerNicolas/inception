# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/21 17:32:44 by nicolas           #+#    #+#              #
#    Updated: 2023/09/21 23:32:08 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		mariadb \
		mariadb-client \
		sed && \
	rm -f /var/cache/apk/*

# Setup mariaDB
# 1. Generate all necessary folders and set permissions.
# 2. COPY th template initialize_mariadb.sh file and it's generate_*.sh file.
# 3. Make generate_*.sh executable and execute it to replace with sed the env variables.
# 4. Initialize the database with the initialize_mariadb.sh file just generated.
# 5. rm the generator file but keep the initialize_*.sh file
# 6. rm and purge sed dependencie
RUN	mkdir -p /etc/scripts && \
	mkdir -p /etc/scripts/pre-exec.d && \
	mkdir -p /etc/scripts/pre-init.d && \
	chmod -R 755 /etc/scripts && \
	mkdir -p /etc/docker-entrypoint-initdb.d

COPY	./conf/initialize_mariadb.sh.template /etc/scripts/
COPY	./tools/generate_initialize_mariadb.sh /etc/scripts/

RUN	chmod +x /etc/scripts/generate_initialize_mariadb.sh && \
	sh /etc/scripts/generate_initialize_mariadb.sh && \
	chmod +x /etc/scripts/initialize_mariadb.sh && \
	sh /etc/scripts/initialize_mariadb.sh && \
	rm -rf /etc/scripts/generate_initialize_mariadb.sh && \
	apk del --purge sed

# Expose port 3006 (default mariadb port = 3306)
EXPOSE	3306

CMD ["mysqld", "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0"]
