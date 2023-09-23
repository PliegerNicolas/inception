# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolas <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/23 21:13:39 by nicolas           #+#    #+#              #
#    Updated: 2023/09/23 21:16:09 by nicolas          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Base image FROM penultimate alpine version (21 september 2023)
FROM	alpine:3.18.3

# Retrieve .env variables during image construction
ARG	DB_TITLE
ARG	DB_ROOT_PASSWORD
ARG	DB_USER_NAME
ARG	DB_USER_PASSWORD
ARG	DB_ADMIN_NAME
ARG	DB_ADMIN_PASSWORD

# Install dependencies
RUN	apk update && apk upgrade && apk add --no-cache \
		php82 && \
	rm -f /var/cache/apk/*

# Expose port 9000.
EXPOSE	9000
