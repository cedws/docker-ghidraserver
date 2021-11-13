# docker-ghidraserver
This project attempts to containerise Ghidra server in a way that isn't a complete pain in the ass. Unfortunately Ghidra is a pretty legacy "masterpiece" and is extremely hostile to containerisation and even basic DevOps practices. Abandon all ye who enter here.

## Running
To start adding users, you need to start up the server at least once to initialise the `repositories` directory. This contains all of the server's state including projects and users, so you don't need to create mounts or volumes for anything else.

If you want to use Docker Compose, modify `docker-compose.yml` to your liking and follow the steps for Compose.

For some dumb reason, Ghidra needs to know what FQDN you'll be using to connect to it. Set `GHIDRASERVER_FQDN` to the external IP address or domain name you're connecting to it with on the clientside.

With Compose:
```sh
docker-compose up -d
```

With bare Docker:
```sh
docker run --env GHIDRASERVER_FQDN=YOUR_SERVER_FQDN -p 13100-13102:13100-13102 -v "$PWD/repositories:/srv/repositories" --name ghidraserver ghcr.io/cedws/docker-ghidraserver:master
```

## Adding users
With Compose:
```sh
docker-compose exec server /entrypoint.sh "./svrAdmin -add myuser --p"
```

With bare Docker:
```sh
docker exec -it ghidraserver /entrypoint.sh "./svrAdmin -add myuser --p"
```

## Removing users
With Compose:
```sh
docker-compose exec server /entrypoint.sh "./svrAdmin -remove myuser"
```

With bare Docker:
```sh
docker exec -it ghidraserver /entrypoint.sh "./svrAdmin -remove myuser"
```