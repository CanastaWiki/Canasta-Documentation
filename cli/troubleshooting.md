# Troubleshooting

This page covers common troubleshooting steps for Canasta installations.

## Contents

- [Checking container status](#checking-container-status)
- [Viewing container logs](#viewing-container-logs)
- [Accessing the database](#accessing-the-database)
- [Running commands inside containers](#running-commands-inside-containers)
- [Common issues](#common-issues)

---

## Checking container status

To see if your Canasta containers are running:
```bash
cd /path/to/installation
sudo docker compose ps
```

---

## Viewing container logs

To view logs from the web container:
```bash
cd /path/to/installation
sudo docker compose logs web
```

To follow logs in real-time:
```bash
sudo docker compose logs -f web
```

To view logs from all containers:
```bash
sudo docker compose logs
```

---

## Accessing the database

To connect to the MySQL database directly:
```bash
cd /path/to/installation
sudo docker compose exec db mysql -u root -p
```
Enter the root database password from your `.env` file when prompted.

---

## Running commands inside containers

To run arbitrary commands inside the web container:
```bash
cd /path/to/installation
sudo docker compose exec web <command>
```

For example, to check PHP version:
```bash
sudo docker compose exec web php -v
```

To get a shell inside the container:
```bash
sudo docker compose exec web bash
```

---

## Common issues

**Installation fails with "Canasta installation with the ID already exists"**
- An installation with that ID is already registered. Use `canasta list` to see existing installations, or choose a different ID.

**Cannot connect to Docker**
- Ensure Docker is running: `sudo systemctl status docker`
- Ensure you're running the command with `sudo`

**Wiki not accessible after creation**
- Check that containers are running: `sudo docker compose ps`
- Verify the domain/URL configuration in your `.env` file
- Check container logs for errors: `sudo docker compose logs web`

**Permission denied errors**
- Most Canasta commands require `sudo`
- Ensure the installation directory has proper ownership
