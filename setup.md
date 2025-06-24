# Setup

## Prerequisites
Canasta officially supports host systems which satisfy the following requirements:

- Ubuntu, Debian, Red Hat, Fedora, and CentOS
- Capable of running Docker Engine (NOT Docker Desktop)
  - [Docker's requirements](https://docs.docker.com/desktop/install/linux-install/)
- x86-64 (also known as AMD64) and ARM64v8 (technically known as AArch64)

Other similar systems may work, but are not supported. You may use them at your own risk.

Canasta is known to work on Windows 11 when Docker Desktop runs using Windows Subsystem for Linux 2 instead of Hyper-V, but this behavior is not officially supported. See this email thread for more details: ["I got Canasta working on Windows"](https://groups.google.com/g/canasta-wiki/c/Ou_HIG_bjkc).

## Quick setup
Canasta requires the use of Docker, and then additionally either Docker Compose or Kubernetes as an orchestration framework.
For most users, Docker Compose is the best choice; the following instructions are specifically for the use of Docker Compose.

### Before starting
You should have both Docker Engine and Docker Compose installed. This is very fast and easy to do on common Linux distributions such as Debian, Ubuntu, Red Hat, and CentOS. By installing Docker Engine from `apt` or `yum`, you get Docker Compose along with it. See the following install guides for each OS:

* [Debian](https://docs.docker.com/engine/install/debian/)
* [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [CentOS](https://docs.docker.com/engine/install/centos/)
* More available at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

## Recommended: CLI installation
The easiest, and recommended, approach to set up Canasta installations is to use the [Canasta CLI](https://github.com/CanastaWiki/Canasta-CLI) (command-line interface). It lets you install and use Canasta without having to know anything about Docker or Docker Compose. Then, once it is installed, the CLI can be used to easily create, import, start, stop, manage extension/skins, and back up Canasta installations.

Note: The Canasta CLI currently only supports installing the latest version of Canasta. Currently, the Canasta CLI only supports installing Canasta 3.0 (MediaWiki 1.43). If you want to install Canasta 1.2 (which uses MediaWiki 1.35), or Canasta 2.0 (which uses MediaWiki 1.39), follow the [manual installation instructions](#manual-installation).

The following covers the installation, and a few of the commands, of the Canasta CLI.
For complete documentation on the CLI, visit the [CLI page](cli.md).

### Installation
* Run the following line to install the Canasta CLI (Be sure you have write permissions in the current working directory):

```
curl -fsL https://raw.githubusercontent.com/CanastaWiki/Canasta-CLI/main/install.sh | bash
``` 
* If prompted, enter your local system password (because the installer and CLI require `sudo` usage).

### Create a new wiki
* Run the following command to create a new Canasta installation with default configurations.
```
sudo canasta create -i canastaId -n example.com -w "Canasta Wiki" -a admin -o compose
```
* Visit your wiki at its URL, "https://example.com" as in the above example (or http://localhost if installed locally or if you did not specify any domain)

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

## Manual installation

### Import existing wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose` and `cd` into that directory
* If you need to use Canasta 1.2 instead of Canasta 1.3, do `git checkout 1.2.x`
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Drop your database dump (in either a `.sql` or `.sql.gz` file) into the `_initdb/` directory
* Place your existing `LocalSettings.php` in the `config/` directory and change your database configuration to be the following:
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see [Configuration](#Configuration) section)
* Navigate to the repo directory and run `docker compose up -d`
* Visit your wiki at its URL (or `https://localhost` if installed locally)

### Create new wiki
* Clone the stack repository from `https://github.com/CanastaWiki/Canasta-DockerCompose` and `cd` into that directory
* If you need to use Canasta 1.2 instead of Canasta 1.3, do `git checkout 1.2.x`
* Copy `.env.example` to `.env` and customize as needed (more details on how to configure it are in the [Configuration](#Configuration) section)
* Navigate to the repo directory and run `docker compose up -d`
* Navigate to its URL (or `https://localhost` if installed locally) and run the MediaWiki setup wizard with the following info:
  * Database host: `db`
  * Database user: `root`
  * Database password: `mediawiki` (by default; see [Configuration](#Configuration) section)
* Place your new `LocalSettings.php` in the `config/` directory
  * We've already added a file in the `config/settings/` directory to enable the Vector skin by default, so your wiki will work right off the bat. But feel free to delete this if you are going to use another skin.
  * Be sure to add `wfLoadExtension( 'VisualEditor' );` for VisualEditor, etc. (More information about installing extensions can be found at the extensions setup page.)
* Run `docker compose down`, then `docker compose up -d` (this is important because it initializes your `LocalSettings.php` for Canasta)
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
* `USE_EXTERNAL_DB` - specifies that the database to be used is not the MySQL one provided in Canasta, default is `false`

You can add/modify extensions and skins using the following mount points:

* `./config` - persistent bind-mount which stores the `LocalSettings.php` file,
volumed in as `mediawiki/config/LocalSettings.php -> /var/www/mediawiki/w/LocalSettings.php`
* `./images` - persistent bind-mount which stores the wiki images,
volumed in as `mediawiki/images -> /var/www/mediawiki/w/images`
* `./skins` - persistent bind-mount which stores user-installed skins,
volumed in as `/var/www/mediawiki/w/user-skins`
* `./extensions` - persistent bind-mount which stores user-installed extensions,
volumed in as `/var/www/mediawiki/w/user-extensions`
* `./_initdb` - persistent bind-mount which can be used to initialize the database container
with a mysql dump. You can place `.sql` or `.gz` database dump there. This is optional and
intended to be used for migrations only.

The directory `config/settings/` comes preloaded with one file: `CanastaFooterIcon.php`, which adds a "Powered by Canasta" icon to the bottom of every wiki page. If you want to remove this icon, you can simply delete this file.

If you are using Docker Compose, you can also make configurations to the overall environment by editing the file `docker-compose.override.yml`.

Additionally, MediaWiki (and its extensions and skins) can be configured in all sorts of ways.
MediaWiki alone has over 1,000 configuration settings; see [here](https://www.mediawiki.org/wiki/Special:MyLanguage/Category:MediaWiki_configuration_settings) for one listing of them.

## Enabling/disabling extensions
In `LocalSettings.php` you can add an extension by picking its name from the [list of bundled extensions](https://canasta.wiki/contents/#extensions-included-in-canasta) and adding a `wfLoadExtension` call for it, e.g.:

```php
wfLoadExtension( 'Cite' );
```

You can also add such a call to any file in the `config/settings/` directory, to achieve the same result.

## Enabling/disabling skins
In `LocalSettings.php` you can add a skin by picking its name from the [list of bundled skins](https://canasta.wiki/contents/#skins-included-in-canasta) and adding a `wfLoadSkin` call for it, e.g.:

```php
wfLoadSkin( 'Timeless' );
```

You can also add such a call to any file in the `config/settings/` directory, to achieve the same result.

## Installing additional extensions
To install a non-Canasta extension, simply place it in the `./extensions`
directory and add a `wfLoadExtension` call to `./config/LocalSettings.php`, e.g.:

```php
wfLoadExtension( 'MyCustomExtension' );
```

### Composer packages
If an additional (non-Canasta) extension requires some Composer packages to be installed, just
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

## Installing additional skins
In order to install a non-Canasta skin, simply place it in the `./skins`
directory and add a `wfLoadSkin` call to `./config/LocalSettings.php`, e.g.:

```php
wfLoadSkin( 'MyCustomSkin' );
```

## Using hardened image (Iron Bank Canasta)
The United States Department of Defense (DoD) publicly releases a hardened version of Canasta, which means it's been specially patched and vetted to be secure enough for internal use in the U.S. military. While it might be a version or two behind, it has been cleared of security vulnerabilities by the DoD.

The hardened version of Canasta (Iron Bank Canasta) has significant internal changes made, but aims to replicate the functionality offered by the standard release. Changes notably include, but not limited to:

- The use of the DoD's hardened version of Red Hat (RHEL) instead of Debian
- Apache is exposed to port `8080` instead of port `80`

Canasta 1.2.0, MediaWiki 1.35.8: `registry1.dso.mil/ironbank/opensource/canastawiki/canasta:1.35.8`

Repository: https://repo1.dso.mil/dsop/opensource/canastawiki/canasta

**Disclaimer**: The U.S. Department of Defense does not sponsor or endorse Canasta in any way, but is kind enough to make their hardened version of Canasta available to the public. Similarly, the Canasta Project does not offer any guarantees that Iron Bank Canasta will function the exact same way as standard Canasta. Neither the Canasta Project nor the DoD provides official support for Iron Bank Canasta.

### Setup instructions
#### 1. Create dso.mil account

Make an account on `dso.mil` below, which requires MFA or DoD Common Access Card but is open to the public.

[https://login.dso.mil/register](https://login.dso.mil/register)

#### 2. Get credentials

Once signed in, access Registry 1 to retrieve your username and personal CLI secret for Docker login. (This is analogous to a personal access token on GitHub.)

[https://registry1.dso.mil/](https://registry1.dso.mil/)

At top right, choose your profile > CLI secret > copy

#### 3. Log in to dso.mil

In the terminal of your Docker environment, connect Docker with the registry:

```
docker login https://registry1.dso.mil/ 
```

The first time you run this, it will prompt for your username and password. Use the credentials from Step 2, with password='CLI secret' (i.e. the personal access token) from your user profile at https://registry1.dso.mil/. 

#### 4. Download Iron Bank images

Pull the images to your machine:

```
docker pull registry1.dso.mil/ironbank/opensource/canastawiki/canasta:1.35.6
docker pull registry1.dso.mil/ironbank/opensource/mariadb/mariadb:10.6.7
```

#### 5. Switch to using these images

Change the image your orchestrator uses (by editing `docker-compose.override.yml` if you use our Docker Compose stack) to the following:

- `web`: `registry1.dso.mil/ironbank/opensource/canastawiki/canasta:1.35.8`
- `db`: `registry1.dso.mil/ironbank/opensource/mariadb/mariadb:10.6.7`

For instance, the `docker-compose.override.yml` file might look like this:

```
version: '3.7'
# The above version is the Docker Compose manifest's version, not the Canasta Docker Compose stack's version.
#
# --- Canasta Stack for Docker Compose ---
#
# If you need to make changes to the stack, make them here.
# Only edits to docker-compose.override.yml are officially supported by Canasta.
#
# Uncomment the commented services and add lines below them if you would like to make additional customizations to them.
services:
  db:
    image: registry1.dso.mil/ironbank/opensource/mariadb/mariadb:10.6.7
  web:
    image: registry1.dso.mil/ironbank/opensource/canastawiki/canasta:1.35.8
  #elasticsearch:
  #caddy:
  #varnish:
```

#### 6. Additional setup

Additional considerations, such as Apache now using port `8080` instead of `80`, should be made when adapting your wiki to using Iron Bank Canasta.

#### After initial setup

It will be necessary to repeat the above login steps for each new session to relogin.
