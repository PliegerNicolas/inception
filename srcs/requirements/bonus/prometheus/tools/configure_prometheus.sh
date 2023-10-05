#!/bin/sh

PROMETHEUS_VERSION=2.47.1
PROMETHEUS_LINK=https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

echo "[i] Install prometheus..."

curl -LO ${PROMETHEUS_LINK} && \
tar xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/ && \
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64

echo "[i] Move prometheus configuration file to prometheus folder."
mv /tmp/prometheus.yml .

echo "[i] Create www-data user/group"
adduser -S -D -H -G www-data -s /sbin/nologin www-data

echo "[i] Set ${HTML_PATH} property and rights."
chown -R www-data:www-data ${PROMETHEUS_PATH}
chmod -R 755 ${PROMETHEUS_PATH}
find ${PROMETHEUS_PATH} -type f -exec chmod 644 {} \;

exec "$@"
