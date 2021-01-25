ARG VER=latest
FROM haproxy:$VER
EXPOSE 8080/tcp
EXPOSE 80/tcp
EXPOSE 443/tcp
#ENTRYPOINT /bin/bash
