# Use the penultimate stable version of Alpine Linux (19 september 2023)
FROM alpine:3.18.3

# Update package lists
RUN apk update

# Install dependencies (nginx and openssl)
RUN apk add nginx
RUN apk add openssl

# Copy configuration file of nginx to container
COPY	./conf/nginx.conf /etc/nginx/conf.d

