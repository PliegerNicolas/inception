# Use the penultimate stable version of Alpine Linux (19 september 2023)
FROM	alpine:3.18.3

# APK :
#	1. Update package lists
#	2. Install dependencies (nginx openssl)
#	3. Clean package cache to reduce image size
RUN	apk update && \
	apk add nginx openssl && \
	rm -rf /var/cache/apk/*

# Copy configuration file of nginx to container
COPY	./conf/nginx.conf /etc/nginx/conf.d

# Generate a self signed SSL certificate
RUN	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx-selfsigned.key \
		-out /etc/nginx/ssl/nginx-selfsigned.crt \
		-subj "/C=FR/ST=Île-de-France/L=Paris/O=42Paris/OU=nplieger/CN=nplieger.fr"

# Expose port 442, default port for SSL connexions (HTTPS)
EXPOSE	443

# Run nginx
# By default nginx runs as daemon in the background. We make it run in forground
# Docker compose expects the primary container (PID 1) to run in the forground.
# Else it might be considered immediately terminated and the container shuts down.
# It can lead to the container constantly restarting.
CMD	["nginx", "-g", "daemon off;"]
