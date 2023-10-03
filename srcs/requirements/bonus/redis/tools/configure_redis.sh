#!/bin/sh

echo "[i] Move redis.conf to /etc/redis/ directory"
mv /etc/redis.conf /etc/redis/

echo "[i] Append conf.d inclusion to redis.conf file."
cat <<EOL >> /etc/redis/redis.conf

# Include all configuration files from the conf.d directory
include /etc/redis/conf.d/*.conf
EOL

exec "$@"
