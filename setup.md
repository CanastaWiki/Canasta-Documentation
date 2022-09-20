# Setup

## Quick setup
Quick setup instructions assume you are using Docker Compose. For most users, using Docker Compose is the best choice.

### Before starting
You should have Docker Engine and Docker Compose installed. This is very fast and easy to do on common Linux distros such as Debian, Ubuntu, Red Hat, and CentOS. By installing Docker Engine from `apt` or `yum`, you get Docker Compose along with it. See the following install guides for each OS:

* [Debian](https://docs.docker.com/engine/install/debian/)
* [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [CentOS](https://docs.docker.com/engine/install/centos/)
* More available at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

## Recommended: CLI Installation
### What is Canasta CLI
[Canasta CLI](https://github.com/CanastaWiki/Canasta-CLI) (Command Line Interface) is a tool to manage Canasta installations. It can create, import, start, stop, manage extension/skins with commands. Specific details about the Canasta installation could be altered by passing in values via keyword arguments.

### Why is it recommended
Canasta CLI, simplifies the process of creating and managing a Canasta installation. Even without the knowledge of Docker and Docker-Compose, one can get started with a Canasta instance using the CLI. Simple command to [create a new wiki](#create-a-new-wiki) helps to get started in minutes.

### Installation
* Run the following line to install the Canasta CLI:

```
curl -fsL https://raw.githubusercontent.com/CanastaWiki/Canasta-CLI/main/install.sh | bash
``` 

### Create a new wiki
* Run the following command to create a new Canasta installation with default configurations.
```
sudo canasta create -i canastaId -n example.com -w Canasta Wiki -a admin -o docker-compose
```
* Visit your wiki at its URL, "https://example.com" as in the above example (or http://localhost if installed locally or if you did not specify any domain)
* For more info on finishing up your installation, visit [After Installation](#after-installation).

### Import an existing wiki
* Place all the files mentioned below in the same directory for ease of use.
* Create a .env file and customize as needed (more details on how to configure it at [Configuration](#Configuration), and for an example see [.env.example](https://github.com/CanastaWiki/Canasta-DockerCompose/blob/main/.env.example)).
* Drop your database dump (in either a .sql or .sql.gz file).
* Place your existing LocalSettings.php and change your database configuration to be the following:
  * Database host: db
  * Database user: root
  * Database password: mediawiki (by default; see [Configuration](#Configuration))
* Then run the following command:
```
sudo canasta import -i importWikiId -d ./backup.sql.gz -e ./.env -l ./LocalSettings.php  
```
* Visit your wiki at its URL (or http://localhost if installed locally or if you did not specify any domain).
* For more info on finishing up your installation, visit [After Installation](#after-installation).

### Enable/disable an extension
* To enable a Canasta extension, run the following command:
```
sudo canasta extension enable Bootstrap -i canastaId
```

### Enable/disable a skin
* To enable a Canasta skin, run the following command:
```
sudo canasta skin enable Vector -i canastaId
```

* Note: For more info on using the cli visit the [CLI page](cli.md)

## Manual Installation

### Import existing wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose` and `cd` into that directory
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Drop your database dump (in either a `.sql` or `.sql.gz` file) into the `_initdb/` directory
* Place your existing `LocalSettings.php` in the `config/` directory and change your database configuration to be the following:
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see [Configuration](#Configuration) section)
* Navigate to the repo directory and run `docker-compose up -d`
* Visit your wiki at its URL (or `http://localhost` if installed locally)
* For more info on finishing up your installation, go to the "After installation" section.

### Create new wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose` and `cd` into that directory
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Navigate to the repo directory and run `docker-compose up -d`
* Navigate to its URL (or `http://localhost` if installed locally) and run the MediaWiki setup wizard with the following info:
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see [Configuration](#Configuration) section)
* Place your new `LocalSettings.php` in the `config/` directory
  * Be sure to add `cfLoadSkin( 'Vector' );` to enable the Vector skin, `cfLoadExtension( 'VisualEditor' );` for VisualEditor, etc. (More information about installing extensions can be found at the extensions setup page.)
* Run `docker-compose down`, then `docker-compose up -d` (this is important because it initializes your `LocalSettings.php` for Canasta)
* Visit your wiki at its URL (or `http://localhost` if installed locally)
* For more info on finishing up your installation, go to the "After installation" section.

### After installation
There's several things you can do to polish up your wiki so it's ready for use:

* To add popular extensions quickly, visit the [Canasta extensions](#enabling-extensions) page to explore your choices.
* Add a skin to your wiki by choosing a skin and add a `cfLoadSkin` call to `LocalSettings.php`. For instance, to install Vector, add: `cfLoadSkin( 'Vector' );` to `LocalSettings.php`.
* All `.php` files in the `config/settings/` directory will be loaded as if their contents were in `LocalSettings.php`. In addition, if you want to remove the Canasta footer icon, you can remove the `config/settings/CanastaFooterIcon.php` file.

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
If a 3rd party extension requires some Composer packages to be installed, just
add a line for the extension's `composer.json` file to the
`config/composer.local.json` file, e.g.:

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
