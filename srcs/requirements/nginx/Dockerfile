# Use the penultimate stable Alpine image (19 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables
ARG	DOMAIN_NAME

# Install Nginx and clear cache to free up space in image
RUN	apk update && apk upgrade \
		&& apk add --no-cache nginx \
		&& apk add --no-cache openssl \
	&& rm -rf /var/cache/apk/*


# Generate a self signed SSL certificat and key
RUN	mkdir -p /etc/nginx/ssl
RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nplieger.key \
		-out /etc/nginx/ssl/nplieger.crt \
		-subj "/C=FR/ST=Île De France/L=Paris/O=42School/CN=${DOMAIN_NAME}"

# Copy nginx configuration file to the container
COPY	./conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE	80
EXPOSE	443

# Run nginx
# By default nginx runs as daemon in the background. We make it run in forground
# Docker compose expects the primary container (PID 1) to run in the forground.
# Else it might be considered immediately terminated and the container shuts down.
# It can lead to the container constantly restarting.
CMD	["nginx", "-g", "daemon off;"]
