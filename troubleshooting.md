# Troubleshooting

### On Ubuntu, `docker-compose` doesn't work because it says Docker isn't running?
If you are using Ubuntu, you need to add `sudo` before all `docker` and `docker-compose` commands.

### After starting up my Canasta repo for the first time, I am getting a "guru meditation error".

This is an error that Varnish returns. In this case, it is most likely because it cannot access the Canasta container (containing Apache, PHP, MediaWiki, etc.) Wait a few minutes for it to go away. If after 10 minutes it does not go away, try to restart your Canasta stack (`docker-compose down && docker-compose up -d`).

### When accessing my Canasta instance, I am getting "SSL protocol error" in the browser or "sitemap permission denied" in the Canasta job queue logs.

This probably means your `.env` file doesn't exist. Use `.env.example` as a starting point and change things as necessary.

### There is some issue with starting up the stack repo, as the database is complaining.

You may see an error message like this:

```
ERROR: for db Cannot start service db: OCI runtime create failed: container_linux.go:380: starting container process caused: process_linux.go:545: container init caused: rootfs_linux.go:76: mounting "/home/ubuntu/Canasta-DockerCompose/_initdb" to rootfs at "/docker-entrypoint-initdb.d" caused: mount through procfd: not a directory: unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified host path exists and is the expected type
```

This probably means your `_initdb` directory either doesn't exist or you named your SQL dump `_initdb` rather than putting it into a directory called `_initdb`. Delete whatever you had, (re)create the `_initdb` directory, add your SQL dump into it, and delete all volumes created. Run `docker volume ls` and use `docker volume rm` to delete those volumes.

### Why am I getting a database error after putting in a SQL dump in `_initdb`?

You likely initialized Canasta already by starting it with `docker-compose up -d`, then placed the SQL file in `_initdb`. Please delete your MySQL data volume and place the SQL file in `_initdb` before trying to start Canasta again. Run `docker volume ls` and use `docker volume rm` to delete those volumes.
