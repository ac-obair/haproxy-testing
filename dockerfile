ARG VER=latest
FROM haproxy:$VER
EXPOSE 8080/tcp
EXPOSE 80/tcp
EXPOSE 443/tcp
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY letsencrypt /etc/pki/tls/certs/letsencrypt
#ENTRYPOINT /bin/bash debugging
