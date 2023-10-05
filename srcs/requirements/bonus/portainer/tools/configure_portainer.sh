#!/bin/sh

PORTAINER_VERSION=2.19.1
PORTAINER_LINK=https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz

mkdir -p /var/portainer

curl -L ${PORTAINER_LINK} -o /tmp/portainer.tar.gz && \
	tar -C /var/portainer -xzf /tmp/portainer.tar.gz --strip-components=1 && \
	rm /tmp/portainer.tar.gz && \

exec "$@"
