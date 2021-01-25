#!/bin/bash
VER=$1
IP=$(ifconfig en0 | grep 'inet\b'|awk '{print$2}')

docker container ls -f "name=haproxy*" --format "{{.ID}}"|xargs docker container stop

echo building; docker build --build-arg VER=${VER} -t haproxy-${VER} .

docker run --rm --name haproxy-${VER} \
                -v /etc/haproxy:/usr/local/etc/haproxy \
                -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
                -v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -it haproxy-${VER} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

docker run --rm -d --name haproxy-${VER} \
		-v /etc/haproxy:/usr/local/etc/haproxy \
		-v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt \
		-v /etc/ssl/certs/ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt \
                -v socket_vol:/var/lib/haproxy \
                -p 8080:8080 -p 80:80 -p 443:443 -p 3306:3306 -p 3307:3307 haproxy-${VER}

echo; echo started stats page http://${IP}:8080 admin:123
echo listening http://${IP}:80 https://${IP}:443
