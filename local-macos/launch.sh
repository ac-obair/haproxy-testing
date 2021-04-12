#!/bin/bash
# ./launch.sh 2.2.9 <-- uses default config
# ./launch.sh 2.2.9 awx/haproxy-awx-backend-test.cfg

VER=$1
DEFAULT=default/haproxy.cfg
CONFIG=$PWD/${2:-$DEFAULT}

echo stopping previous run...
docker container ls --filter name=haproxy -q | xargs docker container stop

echo testing configuration file
docker run --rm --name haproxy-syntax-check --network host \
                -v ${CONFIG}:/usr/local/etc/haproxy/haproxy.cfg \
                haproxy:${VER} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg

: <<comment
there is no docker0 on mac containers run in a vm so access to the hosts network stack is restricted
using --network host for quick testing is made more difficult when hitting services not running in docker

the started container below's haproxy.cfg uses host.docker.internal with http-request set-header host
comment

echo starting...
docker run --rm -d --name haproxy-egress-proxy -p 8080:8080 -p 8081:8081 \
                -v ${CONFIG}:/usr/local/etc/haproxy/haproxy.cfg \
                haproxy:${VER}

ID=$(docker container ls --filter name=haproxy -q)
docker container ls -a --filter name=haproxy
echo docker exec -it $ID /bin/bash
echo reachable http://$(ifconfig en0 inet|awk 'NR==3{print $2}'):8080
echo monitoring http://$(ifconfig en0 inet|awk 'NR==3{print $2}'):8081