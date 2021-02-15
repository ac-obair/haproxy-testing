#!/bin/bash
mv /var/lib/haproxy/stats.sock /var/lib/haproxy/stats.sock.bak
mv /var/lib/haproxy/haproxy.sock /var/lib/haproxy/haproxy.sock.bak
ln -s /var/lib/docker/volumes/socket_vol/_data/stats.sock /var/lib/haproxy/stats.sock
ln -s /var/lib/docker/volumes/socket_vol/_data/haproxy.sock /var/lib/haproxy/haproxy.sock
