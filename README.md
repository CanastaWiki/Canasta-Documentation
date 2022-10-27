# Canasta
Canasta is an all-in-one MediaWiki package for sysadmins that makes it easy to manage MediaWiki, add extensions, and load starter content and data structures.

The base of Canasta is the Canasta tech stack, a MediaWiki stack made for easy deployment of enterprise-ready MediaWiki on production environments.

# Layout of the project
The project is comprised of several repos on GitHub.
* [Canasta](https://github.com/CanastaWiki/Canasta): This is where the Canasta Docker image's code lies. **If you are just using Canasta and not developing for it, you should not clone this repo, as it will be of no use to you**. Instead, you should use one of the stack repos. Power users can use this repo to build their own copy of the Canasta image, if they so desire.
* Stack repos: Canasta is ran as a collection of Docker containers (a "stack"). The configuration needed to make this work, along with MediaWiki configuration, are organized in a stack repo. It also takes care of downloading the Canasta image for you. This repo is a *template* you should use. To use it, **download this repo** so you can make modifications to it. You can even check-in your stack repo into source control. Depending on your orchestration software, we have different templates to get started from:
  * [Canasta for Docker Compose](https://github.com/CanastaWiki/Canasta-DockerCompose): For most users, Docker Compose is the best option. It's simple to use, included with Docker Engine when you install it from `apt` or `yum`, and lightweight.
  * Canasta for Kubernetes: More info coming soon. For now, the code remains on the Canasta repo, but this will be spun off into its own repo soon.

# Setup instructions
See the [Setup page](setup.md).

# Components
Supporting components of Canasta are not located directly in the Canasta image, but are part of the Canasta stack.
They are invoked on the `docker-compose.yml` file for Docker Compose installations
or the Kubernetes deployment manifest for Kubernetes installations.

Instructions below on handling the components are for Docker Compose only.
For Kubernetes information, please see the Kubernetes section below.

## Database
By default, the stack uses the `mysql:8.0` container for the database and stores MySQL
files in `mysql-data-volume` to make the database persist across container
restarts.

It is not necessary to use the volume and the database container. You can switch
to any external database server you wish by simply modifying the following values
under your `./config/LocalSettings.php` file (or by specifying your DB server during setup wizard):

```php
## Database settings
$wgDBserver = "my.custom.mysql.server.com";
$wgDBname = "customdatabasename";
$wgDBuser = "customuser";
$wgDBpassword = "custompassword";
```

If you switch to an external database server, feel free to remove the `mysql` service from
the `docker-compose.yml` file:

```yml
services:
  db: # <- remove whole branch
    ...
  web:
    ...
    links: # <- remove whole branch
      - db
    depends_on: # <- remove whole branch
      - db
```

### Backing up the database

To create a database backup, use the following command:

```bash
cd ~/path/to/canasta
docker-compose exec db /bin/bash \
  -c 'mysqldump $MYSQL_DATABASE -uroot -p"$MYSQL_ROOT_PASSWORD" 2>/dev/null | gzip | base64 -w 0' \
  | base64 -d \
  > backup_$(date +"%Y%m%d_%H%M%S").sql.gz
```

This will create `~/path/to/canasta/backup_<DATE>.sql.gz` file with a database backup.

### Deleting the database volume

If you need to start over or prune the database data, use the command below:

```bash
cd ~/path/to/canasta
docker-compose down --volumes
```

This will stop all the services and remove all the linked persistent volumes.

## Executing maintenance scripts

The image is bundled with automatic job-runner, transcoder and log-rotator scripts, but
if you need to run any other maintenance script you can do so using this command:

```bash
cd ~/path/to/canasta
docker-compose exec web php maintenance/rebuildall.php
```

The image is also configured to automatically run the `update.php` script on
start, so if you enable some extension that adds its own database tables (like `Semantic Mediawiki`),
you can add the DB tables by either restarting the stack via `docker-compose restart`, or just running the
`update.php` script like so:

```bash
cd ~/path/to/canasta
docker-compose exec web php maintenance/update.php --quick
```

## Elasticsearch

By default, the stack uses the `elasticsearch/elasticsearch:6.8.20` container and stores
indexes in the `elasticsearch` volume, to make the data persist across container
restarts.

Despite the fact that the Elasticsearch container is active by default, the wiki won't use it
until you make the necessary configuration changes in `LocalSettings.php`. For more information
about how to enable CirrusSearch, follow the initialization instructions in the
[Extensions setup](extensions-setup) page.

## Sitemap

The image includes a sitemap auto-generation script, which stores the resulting
sitemap to the volume `sitemap`, which is symlinked to `/var/www/mediawiki/w/sitemap`.

# Kubernetes
Canasta offers Kubernetes support for heavy-duty wikis needing the power provided by Kubernetes.
However, it is not for the faint of heart. We recommend smaller wikis use Docker Compose to manage their stack.

Configs are located in the `kubernetes` directory, organized with each file representing a
service (`web`, `db`, `elasticsearch`). The simplest way to run it is as below (make sure you
have a node configured or `minikube` for a development environment):

```bash
minikube start
cd ~/path/to/canasta
kubectl apply -f kubernetes
minikube service web
```

You will want to use `kubeadm` or other Kubernetes implementations for your production environment.
We aim to provide documentation on how to do this in the future.

The mount-bind directories are created at `/opt/mediawiki` root (you can change this by
modifying the conf files). If nothing exists at the given path, an empty directory will 
be created there as needed with permission set to 0755, having the same group and ownership 
as Kubelet. Make sure the `/opt/mediawiki/elasticsearch`, `/opt/mediawiki/images` and
`/opt/mediawiki/sitemap` directories are writable.

Note that the Kubernetes stack provided (same as the Docker Compose stack) does not include any
front-end load balancer or proxy web server, so it's up to you to route the requests to the
wiki pod/container.

Note that the Kubernetes stack provided relies on the [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
volume binding, so it's not intended to be used as a scalable solution (>1 pod per deployment) and
for some in-cloud Kubernetes deployments.

It is recommended to replace `hostPath` mounts with [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)s
 using [StorageClass](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
 
# Help and assistance

## Frequently asked questions
- **Why shouldn't we use the Canasta image's repo?**

The stack repo, regardless of which type you choose (Docker Compose, Kubernetes, etc.), will clone the appropriate Docker *image*, which is pre-built for your convenience and will be pulled when you first start up Canasta. The source code could technically be used to build the Docker image, but that is really not necessary; that would be like building your own binary from source code instead of just downloading the binary provided to you by the developers.

- **Why does Canasta use Apache instead of Nginx?**

Canasta uses Apache because the Wikimedia Foundation uses Apache to run Wikipedia and its other projects. By sticking as close to the Wikimedia Foundation's technology stack as possible, we get the best chance at running MediaWiki without bugs and in a sustainably maintainable way.

- **Does Canasta have a version that uses Nginx instead of Apache?**

At the moment, the base Canasta image does not offer an Nginx flavor. However, anyone is welcome to make a derivative image of Canasta (instructions to do this are on another page) and replace Apache with Nginx as desired.

## Troubleshooting

Please see the troubleshooting page for more info.

## More assistance
You can open an issue on the Canasta image's GitHub repo's issues page. [Canasta issues](https://github.com/CanastaWiki/Canasta/issues)

# About Canasta
## History
Project Canasta was launched by Yaron Koren, head of WikiWorks. Project Canasta is intended to make
Enterprise MediaWiki administration easier, while bringing the full power of MediaWiki and its extensions to the table.

## What's behind the name?
Canasta means "basket" in Spanish, alluding to Canasta's full-featured stack being like a single basket, complete with all of the tools needed.

## Principles

Canasta is built on the following principles:

- **Beginner friendly**. Canasta should be easy for a sysadmin to set up and configure.
- **Ease of installation and upgradability**. Canasta bundles everything needed to run MediaWiki and updating MediaWiki is as simple as pulling a new version of Canasta.
- **Ease of maintainability**. Canasta takes care of all of the routine maintenance aspects of MediaWiki without any further installations needed.
- **Convenience**. Canasta should have enhancements to allow for an easy-to-use administration experience. For example, Canasta bundles commonly-used extensions and skins used in the Enterprise MediaWiki community. In the future, Canasta aims to add support for enhanced capabilities to manage a MediaWiki instance, such as a Canasta wiki manager.
- **As backwards compatible with vanilla MediaWiki as possible**. Canasta should support drag-and-drop of a “normal” MediaWiki installation’s LocalSettings.php configuration. Sysadmins should be able to make most customizations just as they would with a “normal” install of MediaWiki, without referring to Canasta-specific documentation.
- **Stability**. Canasta will use an “ltsrel” compatibility policy. It will be kept up-to-date with the latest Long Term Support versions of MediaWiki and ignore intermediate versions. Canasta will be updated for all LTS minor releases. Extensions will be tied to specific git commits and will be updated infrequently.
- **Open source**. Canasta and its source code are free to be used and modified by everyone.
- **Customizability**. Sysadmins can use as little or as much of Canasta as you want by choosing which features to enable in their LocalSettings.php.
- **Extensibility**. Canasta should support “after-market” customization of the Canasta image. Derivative images should be able to make any change they want to Canasta, including overriding its base functionality.
- **Ready for source control**. Storing configuration on source control is an excellent DevOps practice for many reasons, including the ease of separating functionality from configuration and data. Canasta is built with this in mind. Simply follow Canasta’s “stack” repo structure and you’ll be able to place your Canasta config into source control.

Canasta supports two orchestrators for managing the stack: Docker Compose and Kubernetes.
