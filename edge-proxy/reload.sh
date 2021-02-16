#!/bin/bash
VER=$1

docker container ls -f "name=currently-running-proxy" --format "{{.ID}}"|xargs docker container stop

docker run --rm --name haproxy-${VER}-syntax-check --network host \
                -v /etc/haproxy:/usr/local/etc/haproxy \
                -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
                -v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                -it haproxy:${VER} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

docker run --rm -d --name currently-running-proxy --network host \
		-v /etc/haproxy:/usr/local/etc/haproxy \
		-v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
		-v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v socket_vol:/var/lib/haproxy \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                haproxy:${VER}

echo running containers
docker container ls
