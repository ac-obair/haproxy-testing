#!/bin/bash
rm /var/lib/haproxy/stats.sock
rm /var/lib/haproxy/haproxy.sock
mv /var/lib/haproxy/stats.sock.bak /var/lib/haproxy/stats.sock
mv /var/lib/haproxy/haproxy.sock.bak /var/lib/haproxy/haproxy.sock
