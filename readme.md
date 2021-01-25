build and run different versions of haproxy


Quickly replace the version of haproxy you're working with. Removes old versions add the one specific, cleans up image and container env. 

```bash
./reload 2.2
./reload latest
./reload 2.3
./reload 1.8
```
These examples will fail since there's no haproxy config, but it shows the build and run process and resulting images. 
```
➜  ./reload.sh 2.2
building
Sending build context to Docker daemon  65.02kB
Step 1/5 : ARG VER=latest
Step 2/5 : FROM haproxy:$VER
2.2: Pulling from library/haproxy
a076a628af6f: Pull complete
ad0be6673509: Pull complete
be26affcff79: Pull complete
a6541eb67c94: Pull complete
3de03f3673be: Pull complete
Digest: sha256:4ab795077c4de5c955fa6c1b3185f98e8ff7d6c3e5355b67d8a1801290a23112
Status: Downloaded newer image for haproxy:2.2
 ---> 3eae824b21ac
Step 3/5 : EXPOSE 8080/tcp
 ---> Running in a200e14e5241
Removing intermediate container a200e14e5241
 ---> f9e15386d40a
Step 4/5 : EXPOSE 80/tcp
 ---> Running in 7eeea2e59017
Removing intermediate container 7eeea2e59017
 ---> 3cdc38c9e758
Step 5/5 : EXPOSE 443/tcp
 ---> Running in a584736d56e4
Removing intermediate container a584736d56e4
 ---> b25be74cc265
Successfully built b25be74cc265
Successfully tagged haproxy-2.2:latest
[NOTICE] 024/081710 (1) : haproxy version is 2.2.8-7bf78d7
[NOTICE] 024/081710 (1) : path to executable is /usr/local/sbin/haproxy
[ALERT] 024/081710 (1) : Cannot open configuration file/directory /usr/local/etc/haproxy/haproxy.cfg : No such file or directory
started stats page http://192.168.88.249:8080 admin:123
listening http://192.168.88.249:80 https://192.168.88.249:443

➜  ./reload.sh 2.2.8
building
Sending build context to Docker daemon  65.02kB
Step 1/5 : ARG VER=latest
Step 2/5 : FROM haproxy:$VER
2.2.8: Pulling from library/haproxy
Digest: sha256:4ab795077c4de5c955fa6c1b3185f98e8ff7d6c3e5355b67d8a1801290a23112
Status: Downloaded newer image for haproxy:2.2.8
 ---> 3eae824b21ac
Step 3/5 : EXPOSE 8080/tcp
 ---> Using cache
 ---> f9e15386d40a
Step 4/5 : EXPOSE 80/tcp
 ---> Using cache
 ---> 3cdc38c9e758
Step 5/5 : EXPOSE 443/tcp
 ---> Using cache
 ---> b25be74cc265
Successfully built b25be74cc265
Successfully tagged haproxy-2.2.8:latest
[NOTICE] 024/081725 (1) : haproxy version is 2.2.8-7bf78d7
[NOTICE] 024/081725 (1) : path to executable is /usr/local/sbin/haproxy
[ALERT] 024/081725 (1) : Cannot open configuration file/directory /usr/local/etc/haproxy/haproxy.cfg : No such file or directory

started stats page http://192.168.88.249:8080 admin:123
listening http://192.168.88.249:80 https://192.168.88.249:443

➜  docker image ls
REPOSITORY                           TAG                                              IMAGE ID       CREATED          SIZE
haproxy-2.2.8                        latest                                           b25be74cc265   20 seconds ago   93.5MB
haproxy-2.2                          latest                                           b25be74cc265   20 seconds ago   93.5MB
haproxy                              2.2                                              3eae824b21ac   11 days ago      93.5MB
haproxy                              2.2.8                                            3eae824b21ac   11 days ago      93.5MB
```


### debugging 

rebuild a copy of an haproxy version with bash entrypoint for testing, uncomment entry point. 
```docker
FROM haproxy:2.2.8
ENTRYPOINT /bin/bash
```

Running with `-d` removes stdout and shell prompt, don't use it unless you want to run in everything sliently. 

- haproxy config must be real file or hard link, soft links won't work with volume mounts.
- commands can be passed to the container to test the config. 

```bash
docker run --rm --name test -v /etc/haproxy:/usr/local/etc/haproxy -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt -it haproxy-check-mounts-work
```

```bash
docker run --rm --name syntax-check -v /etc/haproxy:/usr/local/etc/haproxy -v /etc/pki/tls/certs/letsencrypt:/etc/pki/tls/certs/letsencrypt -it haproxy:2.2.8 haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
```
