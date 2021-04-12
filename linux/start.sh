#!/bin/bash
TAG=$1
docker run --rm --name haproxy-syntax-check --network host \
                -v /etc/haproxy:/usr/local/etc/haproxy \
                -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
                -v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v socket_vol:/var/lib/haproxy \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                haproxy:${TAG} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

docker run --rm -d --name currently-running-proxy --network host \
		-v /etc/haproxy:/usr/local/etc/haproxy \
		-v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
		-v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v socket_vol:/var/lib/haproxy \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                haproxy:${TAG}

echo running containers
docker container ls
