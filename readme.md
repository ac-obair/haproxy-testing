build and run different versions of haproxy

Quickly replace the version of haproxy you're working with. Removes old versions add the one specific, cleans up image and container env. 

```bash
./start.sh 2.2
./start.sh 2.2.9
./start.sh lts    # (same as 2.2.9 or latest lts)
```
You must link the sockets from the named volume with these will be created when the configuration is tested before starting the process 
```
./link.sh
```
This preserves the host haproxy environment for deploys. Use `./unlink` to fall back to the host haproxy version. 
```
./unlink
```

```bash
./reload-config.sh # doesn't effect container uptime in memory config reload
./stop.sh          # stop container --rm flag ensures container is removed when stopped
```
