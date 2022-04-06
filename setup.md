# Setup

## Quick setup
Quick setup instructions assume you are using Docker Compose. For most users, using Docker Compose is the best choice.

### Before starting
You should have installed Docker Engine and Docker Compose. This is very fast and easy to do on common Debian distros such as Debian, Ubuntu, Red Hat, and CentOS. See the following guides for each OS:

* [Debian](https://docs.docker.com/engine/install/debian/)
* [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [CentOS](https://docs.docker.com/engine/install/centos/)
* More available at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

### Import existing wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose`
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Drop your database dump (in either a `.sql` or `.sql.gz` file) into the `_initdb/` directory
* Place your existing `LocalSettings.php` in the `config/` directory and change your database configuration to be the following
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see `Configuration` section)
* Navigate to the repo directory and run `docker-compose up -d`
* Visit your wiki at its URL (or `http://localhost` if installed locally)

### Create new wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose`
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Navigate to the repo directory and run `docker-compose up -d`
* Navigate to `http://localhost` and run wiki setup wizard:
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see `Configuration` section)
* Place your new `LocalSettings.php` in the `config/` directory
* Run `docker-compose down`, then `docker-compose up -d` (this is important because it initializes your `LocalSettings.php` for Canasta)
* Visit your wiki at its URL (or `http://localhost` if installed locally)

## Configuration
Canasta relies on setting environment variables in the Docker container for controlling
aspects of the system that are outside the purview of LocalSettings.php. You can change
these options by editing the `.env` file; see `.env.example` for details:

* `PORT` - modify the publicly-accessible HTTP port, default is `80`
* `MYSQL_PASSWORD` - modify MySQL container `root` user password, default is `mediawiki`
(use it when installing the wiki via wizard)
* `PHP_UPLOAD_MAX_FILESIZE` - php.ini upload max file size
* `PHP_POST_MAX_SIZE` - php.ini post max size

You can add/modify extensions and skins using the following mount points:

* `./config` - persistent bind-mount which stores the `LocalSettings.php` file,
volumed in as `mediawiki/config/LocalSettings.php -> /var/www/mediawiki/w/LocalSettings.php`
* `./images` - persistent bind-mount which stores the wiki images,
volumed in as `mediawiki/images -> /var/www/mediawiki/w/images`
* `./skins` - persistent bind-mount which stores 3rd party skins,
volumed in as `/var/www/mediawiki/w/user-skins`
* `./extensions` - persistent bind-mount which stores 3rd party extensions,
volumed in as `/var/www/mediawiki/w/user-extensions`
* `./_initdb` - persistent bind-mount which can be used to initialize the database container
with a mysql dump. You can place `.sql` or `.gz` database dump there. This is optional and
intended to be used for migrations only.

## Enabling extensions
In `LocalSettings.php` you can add an extension by picking its name from our [list of bundled extensions](https://canasta.wiki/documentation/#extensions-included-in-canasta) and add a `cfLoadExtension`, e.g.:

```php
cfLoadExtension( 'Cite' );
```

## Enabling skins
In `LocalSettings.php` you can add a skin by picking its name from our [list of bundled skins](https://canasta.wiki/documentation/#skins-included-in-canasta) and add a `cfLoadSkin` call, e.g.:

```php
cfLoadSkin( 'Timeless' );
```

## Installing 3rd party extensions
In order to install a 3rd party extension, simply place it in the `./extensions`
directory and add a `wfLoadExtension` call to `./config/LocalSettings.php`, e.g.:

```php
wfLoadExtension( 'MyCustomExtension' );
```

### Composer packages
If a 3rd party extension requires some Composer packages to be installed, just create
a `config/composer.local.json` file (if one is not there already) and add to it
`merge-plugin` syntax that includes the extension's `composer.json` file, e.g.:

```json
{
	"extra": {
		"merge-plugin": {
			"include": [
				"user-extensions/SomeExtension/composer.json"
			]
		}
	}
}
```

Note: the `require` section of `config/composer.local.json` is ignored; thus
you won't be able to install new extensions via Composer, only dependencies.

## Installing 3rd party skins
In order to install a 3rd party skin, simply place it in the `./skins`
directory and add a `wfLoadSkin` call to `./config/LocalSettings.php`, e.g.:

```php
wfLoadSkin( 'MyCustomSkin' );
```
