#!/bin/bash

# Replace placeholders in the template
cat /etc/nginx/generate_conf_file/nginx.config.template |
	sed -e "s#\${DOMAIN_NAME}#${DOMAIN_NAME}#g" \
  		-e "s#\${CERTS_}#${CERTS_}#g" \
	> /etc/nginx/nginx.conf
