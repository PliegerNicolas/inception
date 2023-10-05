#!/bin/sh

PROMETHEUS_VERSION=2.47.1
PROMETHEUS_LINK=https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

echo "[i] Install prometheus..."
curl -LO ${PROMETHEUS_LINK} && \
tar xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/ && \
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64

echo "[i] Move prometheus configuration file to prometheus folder."
mv /tmp/prometheus.yml /prometheus/

exec "$@"
