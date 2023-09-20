# Use the penultimate stable Alpine image (19 september 2023)
FROM	alpine:3.18.3

# Install dependencies and clear apk cache to free up space
# 1. php82 : core PHP package, PHP runtime and necessary libraries for PHP scripts.
# 2. php82-fpm : FastCGI Process Manager, it allows PHP scripts to run efficiently.
# 3. php82-mysqli : Allows PHP to communicate with MySQL databases.
# 4. php82-json : Enables PHP to encode and decode JSON data.
# 5. php82-curl : Allows PHP to make HTTP requests.
# 6. php82-zlib : Allows compression and decompression using the zlib library.
# 7. php82-xml : allows PHP to prase and generate XML documents.
# 8. php82-phar : allows PHP to work with PHP archives (phar files).
RUN	apk update && apk upgrade && apk add --no-cache \
		php82 \
		php82-fpm \
		php82-mysqli \
		php82-json \
		php82-curl \
		php82-zlib \
		php82-xml \
		php82-phar \
		php82-mbstring \
	&& rm -rf /var/cache/apk/*

# Setup PHP-FPM service
# Create www-data user and add it to the www-data group
RUN	adduser -D -g '' -G www-data www-data
# Create /run/php-fpm directory for php-fpm to store it's runtime files. Make www-data it's owner.
RUN	mkdir /run/php-fpm && chown www-data:www-data /run/php-fpm

# Start PHP-FPM in forground
CMD	["php-fpm82", "-F"]
