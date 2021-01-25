#!/bin/bash
VER=$1
KERNEL=$(uname -s)
#STATS_PORT_TCP=44444
STATS_PORT_TCP=8080
ADMIN_STATS_PORT_TCP=44443
WEB_FRONTEND_TCP=80
ENCRYPTED_WEB_FRONTEND_TCP=443
DATABASE1_TCP=3306
DATABASE2_TCP=3307

case $KERNEL in
  Darwin)
    INTERFACE=en0
    ;;
  Linux)
   INTERFACE=ens160
   ;;
  *)
   ;;
esac

IP=$(ifconfig ${INTERFACE} | grep 'inet\b'|awk '{print$2}')

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
                -p 8080:${STATS_PORT_TCP} \
                -p 4443:${ADMIN_STATS_PORT_TCP} \
                -p 80:${WEB_FRONTEND_TCP} \
                -p 443:${ENCRYPTED_WEB_FRONTEND_TCP} \
                -p 3306:${DATABASE1_TCP} \
                -p 3307:${DATABASE2_TCP} \
                haproxy-${VER}

echo; echo started stats page http://${IP}:8080 admin:123
echo listening http://${IP}:80 https://${IP}:443
