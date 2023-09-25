#!/bin/bash

# Replace placeholders in the template
if [ -f /etc/nginx/http.d/wordpress.conf.template ]; then

	echo "[i] Generating /etc/nginx/http.d/wordpress.conf file"
	cat /etc/nginx/http.d/wordpress.conf.template |
		sed -e "s#\${DOMAIN_NAME}#${DOMAIN_NAME}#g" \
	  		-e "s#\${CERTS_}#${CERTS_}#g" \
		> /etc/nginx/http.d/wordpress.conf
	rm -f /etc/nginx/http.d/wordpress.conf.template
	chown nginx:nginx /etc/nginx/http.d/wordpress.conf

else

	echo "/etc/nginx/http.d/wordpress.conf file already generated."

fi

exec "$@"
