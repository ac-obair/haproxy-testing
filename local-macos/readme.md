

Launch a proxy capable of fronting awx on mac os
```
./launch.sh 2.2.9 awx/haproxy-awx-backend-test.cfg
```
there is no `docker0` on mac containers run in a vm so access to the hosts network stack is restricted
using `--network host` for quick testing is made more difficult when hitting services not running in docker

the started container below's `haproxy.cfg` uses `host.docker.internal` with `http-request set-header host`