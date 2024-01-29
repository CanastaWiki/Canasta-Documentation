# Maintaining your wiki

## Running maintenance scripts
Usually, you don't need to run maintenance scripts. `update.php` is always ran during the container startup process, so if you need to run it, it's best to remove the existing container and spin up a new one. The job queue is always automatically ran during the entire life of the container.

However, in the case you do need to run them, you can use:

```bash
sudo docker compose exec web php /var/www/mediawiki/w/maintenance/SCRIPT_NAME.php
```
