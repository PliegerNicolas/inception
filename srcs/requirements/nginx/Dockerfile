# Use the penultimate stable Alpine image (19 september 2023)
FROM	alpine:3.18.3

# Install Nginx and clear cache to free up space in image
RUN	apk update && apk upgrade \
		&& apk add nginx \
	&& rm -rf /var/cache/apk/*

# Copy nginx configuration file to the container
#COPY	./conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE	80

# Run nginx
# By default nginx runs as daemon in the background. We make it run in forground
# Docker compose expects the primary container (PID 1) to run in the forground.
# Else it might be considered immediately terminated and the container shuts down.
# It can lead to the container constantly restarting.
CMD	["nginx", "-g", "daemon off;"]
