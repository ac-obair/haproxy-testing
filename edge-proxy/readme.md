build and run different versions of haproxy

Quickly replace the version of haproxy you're working with. Removes old versions add the one specific, cleans up image and container env. 

```bash
./reload 2.2
./reload 2.2.9
./reload latest
./reload 2.3
./reload 1.8
```
You must link the sockets from the named volume with these will be created when the configuration is tested before starting the process 
```
./link.sh
```
This preserves the host haproxy environment for deploys. Use `./unlink` to fall back to the host haproxy version. 
```
./unlink
```
