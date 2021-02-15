#!/bin/bash
VER=$1
IMAGE_NAME=runable-haproxy-${VER}-image

docker container ls -f "name=haproxy*" --format "{{.ID}}"|xargs docker container stop

echo building
docker build --build-arg VER=${VER} -t ${IMAGE_NAME}:${VER} .

docker run --rm --name haproxy-${VER}-syntax-check --network host \
                -v /etc/haproxy:/usr/local/etc/haproxy \
                -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
                -v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                -it ${IMAGE_NAME}:${VER} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

docker run --rm -d --security-opt seccomp:unconfined --privileged --log-driver=journald --cpus 8 --name haproxy-${VER}-running-proxy --network host \
		-v /etc/haproxy:/usr/local/etc/haproxy \
		-v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
		-v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v socket_vol:/var/lib/haproxy \
                -v /etc/haproxy/errors:/etc/haproxy/errors \
                ${IMAGE_NAME}:${VER}

echo running containers
docker container ls
