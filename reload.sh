#!/bin/bash
VER=$1
IP=$(ifconfig en0 | grep 'inet\b'|awk '{print$2}')
# no need to delete since --rm is used
docker container ls -f "name=haproxy*" --format "{{.ID}}"|xargs docker container stop

# build with test entrypoint '/bin/bash' when debugging. run with 'docker run -it --rm --name whatever haproxy-2.2 -- /bin/bash'
echo building
docker build --build-arg VER=${VER} -t haproxy-${VER} .

docker run -it --rm --name haproxy-${VER} haproxy-${VER} haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg && \
    docker run -d --rm  -p 8080:8080 -p 80:80 -p 443:443 --name haproxy-${VER} haproxy-${VER} && \
    echo; echo started stats page http://${IP}:8080 admin:123 && \
    echo listening http://${IP}:80 https://${IP}:443
