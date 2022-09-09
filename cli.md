# Canasta CLI
The Canasta command line interface, written in Go.

## Before starting
You should have Docker Engine and Docker Compose installed. This is very fast and easy to do on common Linux distros such as Debian, Ubuntu, Red Hat, and CentOS. By installing Docker Engine from `apt` or `yum`, you get Docker Compose along with it. See the following install guides for each OS:

* [Debian](https://docs.docker.com/engine/install/debian/)
* [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [CentOS](https://docs.docker.com/engine/install/centos/)
* More available at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

## Installation
* Then, run the following line to install the Canasta CLI:

```
curl -fsL https://raw.githubusercontent.com/CanastaWiki/Canasta-CLI/main/install.sh | bash
``` 

## All available commands

```
A CLI tool to create, import, start, stop and backup multiple Canasta installations

Usage:
  sudo canasta [command]

Available Commands:
  list        List all Canasta installations
  create      Create a Canasta installation
  import      Import a wiki installation
  start       Start the Canasta installation
  stop        Shuts down the Canasta installation
  restart     Restart the Canasta installation
  skin        Manage Canasta skins
  extension   Manage Canasta extensions
  restic      Use restic to backup and restore Canasta
  maintenance Run maintenance update jobs
  delete      Delete a Canasta installation
  help        Help about any command

Flags:
  -h, --help      help for canasta
  -v, --verbose   Verbose output


Use "sudo canasta [command] --help" for more information about a command.
```
## Create a new wiki
* Run the following command to create a new Canasta installation with default configurations.
```
sudo canasta create -i canastaId -n example.com -w Canasta Wiki -a admin -o docker-compose
```
* Visit your wiki at its URL, "https://example.com" as in the above example (or http://localhost if installed locally or if you did not specify any domain)
* For more info on finishing up your installation, visit https://canasta.wiki/setup/#after-installation.

## Import an existing wiki
* Place all the files mentioned below in the same directory for ease of use.
* Create a .env file and customize as needed (more details on how to configure it at https://canasta.wiki/setup/#configuration, and for an example see https://github.com/CanastaWiki/Canasta-DockerCompose/blob/main/.env.example).
* Drop your database dump (in either a .sql or .sql.gz file).
* Place your existing LocalSettings.php and change your database configuration to be the following:
```
Database host: db
Database user: root
Database password: mediawiki (by default; see https://canasta.wiki/setup/#configuration)
```
* Then run the following command:
```
sudo canasta import -i importWikiId -d ./backup.sql.gz -e ./.env -l ./LocalSettings.php  
```
* Visit your wiki at its URL (or http://localhost if installed locally or if you did not specify any domain).
* For more info on finishing up your installation, visit https://canasta.wiki/setup/#after-installation.

## Enable/disable an extension
* To list all Canasta extensions (https://canasta.wiki/documentation/#extensions-included-in-canasta) that can be enabled or disabled with the CLI, run the following command:
```
sudo canasta extension list -i canastaId
```
* To enable a Canasta extension, run the following command:
```
sudo canasta extension enable Bootstrap -i canastaId
```
* To disable a Canasta extension, run the following command:
```
sudo canasta extension disable VisualEditor -i canastaId
```
* To enable/disable multiple Canasta extensions, separate the extensions with a ',':
```
sudo canasta extension enable VisualEditor,PluggableAuth -i canastaId
```
* Note: The extension names are case-sensitive.


## Enable/disable a skin
* To list all Canasta skins (https://canasta.wiki/documentation/#skins-included-in-canasta) that can be enabled or disabled with the CLI, run the following command:
```
sudo canasta skin list -i canastaId
```
* To enable a Canasta skin, run the following command:
```
sudo canasta skin enable Vector -i canastaId
```
* To disable a Canasta skin, run the following command:
```
sudo canasta skin disable Refreshed -i canastaId
```
* To enable/disable multiple Canasta extensions, separate the extensions with a ',':
```
sudo canasta skin enable CologneBlue,Modern -i canastaId
```
* Note: the skin names are case-sensitive.

## Restic Documentation
* More about restic at https://restic.net
* The current version is configured for using AWS S3 based repositories
* It uses restic's [dockerized binary](https://hub.docker.com/r/restic/restic)

### How to get started
1. Add these environment variables to your Canasta's `.env`.Follow the steps at https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds-create to obtain ACCESS_KEY_ID and SECRET_ACESS_KEY
```
AWS_S3_API=s3.amazonaws.com
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET=
RESTIC_PASSWORD=
```
2. When using restic for the first time in a Canasta installation please run the following command to initialize a restic repo in AWS S3 Bucket specified in the `.env` file.
```
sudo canata restic init -i canastaId
```
Now you should be able to use any of the available commands.

### Available Restic Commands:
  ```
  check         Check restic snapshots
  diff          Show difference between two snapshots
  forget        Forget restic snapshots
  init          Initialize a restic repo
  list          List files in a snapshost
  restore       Restore restic snapshot
  take-snapshot Take restic snapshots
  unlock        Remove locks other processes created
  view          View restic snapshots
  ```
Use "sudo canasta restic [command] --help" for more information about a command.

## Uninstall
* To uninstall the CLI, delete the binary file from the installation folder (default: /usr/local/bin/canasta)
```
sudo rm /usr/local/bin/canasta && sudo rm /etc/canasta/conf.json
```
* Note: The argument "-i canastaId" is not necessary for any command when the command is run from the Canasta installation directory.
