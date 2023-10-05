#!/bin/sh

ADMINER_VERSION=4.8.1
ADMINER_LINK=https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php

echo "[i] Generate /var/www/adminer folder."
mkdir -p ${ADMINER_PATH}

echo "[i] Install adminer via curl."
curl -o ${ADMINER_PATH}/adminer.php -L ${ADMINER_LINK}

exec "$@"
