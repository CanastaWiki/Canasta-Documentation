# Canasta CLI

The Canasta command line interface (CLI) is a tool written in Go for managing Canasta MediaWiki installations. It handles creation, import, backup, and management of multiple Canasta instances using Docker Compose as the orchestrator. The CLI supports both single wiki installations and wiki farms (multiple wikis in one installation).

## Pre-requisites

Before using the Canasta CLI, you must have both Docker Engine and Docker Compose installed.

### Windows and macOS

Docker Compose is included in [Docker Desktop](https://www.docker.com/products/docker-desktop) for Windows and macOS.

### Linux

Linux is the most-tested and preferred OS environment as the host for Canasta. Installing the requirements is fast and easy to do on common Linux distributions such as Debian, Ubuntu, Red Hat, and CentOS. While you can get up and running with all the Docker requirements by installing Docker Desktop on Linux, if you are using a 'server environment' (no GUI), the recommended way to install is to **uninstall** any distribution-specific software and [install Docker software using the Docker repositories](https://docs.docker.com/compose/install/linux/#install-using-the-repository). (The link is the install guide for Docker Compose which will also install the Docker Engine.)

### Example

Essentially, preparing your Linux server to be a Canasta host by installing the Docker suite of software includes something like
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin` once you've
added the Docker repositories to your system. A full example script for Ubuntu can be found at [example-prepare-ubuntu-headless.sh](example-prepare-ubuntu-headless.sh)

## Installation

Run the following line to install the Canasta CLI (be sure you have write permissions in the current working directory):

```
curl -fsL https://raw.githubusercontent.com/CanastaWiki/Canasta-CLI/main/install.sh | bash
```

## Command Overview

```
A CLI tool to create, import, start, stop and backup multiple Canasta installations

Usage:
  canasta [flags]
  canasta [command]

Available Commands:
  add         Add a new wiki to a Canasta instance
  create      Create a Canasta installation
  delete      Delete a Canasta installation
  extension   Manage Canasta extensions
  help        Help about any command
  import      Import a wiki installation
  list        List all Canasta installations
  maintenance Use to run update and other maintenance scripts
  remove      Remove a wiki from a Canasta instance
  restart     Restart the Canasta installation
  restic      Use restic to backup and restore Canasta
  skin        Manage Canasta skins
  start       Start the Canasta installation
  stop        Shuts down the Canasta installation
  upgrade     Upgrade a Canasta installation to the latest version
  version     Show the Canasta version

Flags:
  -d, --docker-path string   Path to docker compose binary
  -h, --help                 Help for canasta
  -v, --verbose              Verbose output

Use "canasta [command] --help" for more information about a command.
```

## Instance Identification

Most commands accept either of these flags to identify a Canasta installation:

- `-i, --id`: Canasta instance ID (the name you gave when creating the installation)
- `-p, --path`: Path to the Canasta installation directory

If you run commands from within the Canasta installation directory, the `-i` flag is not required.

---

## Commands Reference

### canasta create

Create a new Canasta installation.

**Usage:**
```
canasta create [flags]
```

**Required Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--id` | `-i` | Canasta instance ID (must be alphanumeric with optional hyphens/underscores) |
| `--admin` | `-a` | Initial wiki admin username |

**Optional Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--path` | `-p` | Current directory | Directory where the installation will be created |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use (currently only `compose` is supported) |
| `--wiki` | `-w` | | ID of the wiki (required if `--yamlfile` is not provided) |
| `--site-name` | `-t` | Wiki ID | Display name of the wiki |
| `--domain-name` | `-n` | `localhost` | Domain name for the wiki |
| `--password` | `-s` | Auto-generated | Initial wiki admin password |
| `--yamlfile` | `-f` | | Path to a custom wikis.yaml file |
| `--keep-config` | `-k` | `false` | Keep config files on installation failure |
| `--override` | `-r` | | File to copy as docker-compose.override.yml |
| `--rootdbpass` | | Auto-generated | Root database password |
| `--wikidbuser` | | `root` | Wiki database username |
| `--wikidbpass` | | Auto-generated | Wiki database password |
| `--envfile` | `-e` | | Path to .env file with password overrides |

**Examples:**

Create a basic wiki:
```bash
sudo canasta create -i mywiki -w main -n example.com -a admin
```

Create with custom admin password:
```bash
sudo canasta create -i mywiki -w main -n example.com -a admin -s "MySecurePassword123"
```

Create with custom database passwords (using environment variables to avoid shell history):
```bash
sudo canasta create -i mywiki -w main -n example.com -a admin \
  --rootdbpass "$ROOT_DB_PASS" --wikidbpass "$WIKI_DB_PASS"
```

Create with a custom wikis.yaml file:
```bash
sudo canasta create -i mywiki -a admin -f ./my-wikis.yaml
```

**Notes:**
- If passwords are not provided, they are auto-generated and saved to the config directory
- Admin password is saved to `config/admin-password_{wikiid}`
- Database passwords are saved to the `.env` file
- After installation, visit your wiki at its URL (e.g., https://example.com or http://localhost)

---

### canasta import

Import an existing MediaWiki installation into Canasta.

**Usage:**
```
canasta import [flags]
```

**Required Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--id` | `-i` | Canasta instance ID |

**Optional Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--path` | `-p` | Current directory | Directory for the installation |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use |
| `--domain-name` | `-n` | `localhost` | Domain name |
| `--database` | `-d` | | Path to database dump (.sql or .sql.gz) |
| `--localsettings` | `-l` | | Path to existing LocalSettings.php |
| `--env` | `-e` | | Path to existing .env file |
| `--override` | `-r` | | File to copy as docker-compose.override.yml |
| `--keep-config` | `-k` | `false` | Keep config files on failure |

**Example:**

```bash
sudo canasta import -i importedwiki -d ./backup.sql.gz -e ./.env -l ./LocalSettings.php
```

**Before Importing:**
1. Create a `.env` file (see [.env.example](https://github.com/CanastaWiki/Canasta-DockerCompose/blob/main/.env.example))
2. Prepare your database dump (.sql or .sql.gz)
3. Update your LocalSettings.php database configuration:
   - Database host: `db`
   - Database user: `root`
   - Database password: `mediawiki` (default)

---

### canasta add

Add a new wiki to an existing Canasta instance (wiki farm).

**Usage:**
```
canasta add [flags]
```

**Required Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--wiki` | `-w` | ID of the new wiki |
| `--url` | `-u` | URL of the new wiki (domain/path format, e.g., 'localhost/wiki2') |
| `--id` | `-i` | Canasta instance ID |
| `--admin` | `-a` | Admin username for the new wiki |

**Optional Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use |
| `--site-name` | `-t` | Wiki ID | Display name of the wiki |
| `--database` | `-d` | | Path to existing database dump |
| `--password` | `-s` | Auto-generated | Admin password for the new wiki |
| `--wikidbuser` | | `root` | Wiki database username |

**Examples:**

Add a wiki at a subdomain:
```bash
sudo canasta add -i mywiki -w soccerwiki -u soccer.example.com -a admin
```

Add a wiki at a path:
```bash
sudo canasta add -i mywiki -w docs -u example.com/docs -t "Documentation Wiki" -a admin
```

Import an existing wiki database:
```bash
sudo canasta add -i mywiki -w imported -u example.com/imported -a admin -d ./backup.sql.gz
```

**URL Format:**
- Use domain/path format without the protocol (http/https)
- Examples: `localhost/wiki2`, `example.com/docs`, `wiki.example.com`
- Multiple wikis can share the same domain with different paths
- Subdomains are treated as separate domains

---

### canasta remove

Remove a wiki from a Canasta instance (wiki farm).

**Usage:**
```
canasta remove [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--wiki` | `-w` | | ID of the wiki to remove (required) |
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |

**Example:**

```bash
sudo canasta remove -i mywiki -w soccerwiki
```

**Warning:** This command will delete the wiki and its corresponding database. You will be prompted for confirmation.

---

### canasta delete

Delete an entire Canasta installation.

**Usage:**
```
canasta delete [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |

**Example:**

```bash
sudo canasta delete -i mywiki
```

**Warning:** This command stops and removes all containers, volumes, and configuration files for the installation.

---

### canasta list

List all Canasta installations managed by the CLI.

**Usage:**
```
canasta list
```

**Example:**

```bash
sudo canasta list
```

This displays all registered installations including their IDs, paths, and the wikis within each installation.

---

### canasta start

Start a Canasta installation.

**Usage:**
```
canasta start [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use |

**Example:**

```bash
sudo canasta start -i mywiki
```

---

### canasta stop

Stop a Canasta installation.

**Usage:**
```
canasta stop [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use |

**Example:**

```bash
sudo canasta stop -i mywiki
```

---

### canasta restart

Restart a Canasta installation.

**Usage:**
```
canasta restart [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--orchestrator` | `-o` | `compose` | Orchestrator to use |
| `--verbose` | `-v` | `false` | Verbose output |

**Example:**

```bash
sudo canasta restart -i mywiki
```

---

### canasta upgrade

Upgrade a Canasta installation to the latest version.

**Usage:**
```
canasta upgrade [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |

**Example:**

```bash
sudo canasta upgrade -i mywiki
```

This command:
1. Pulls the latest changes from the Canasta repository
2. Pulls the latest Docker images
3. Restarts the containers
4. Flushes the cache

---

### canasta version

Display the Canasta CLI version information.

**Usage:**
```
canasta version
```

---

## Extension Management

### canasta extension

Manage Canasta extensions for a wiki installation.

**Common Flags (apply to all subcommands):**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--wiki` | `-w` | | ID of specific wiki in the farm (optional) |
| `--verbose` | `-v` | `false` | Verbose output |

### canasta extension list

List all available Canasta extensions.

**Usage:**
```
canasta extension list [flags]
```

**Example:**

```bash
sudo canasta extension list -i mywiki
```

### canasta extension enable

Enable one or more Canasta extensions.

**Usage:**
```
canasta extension enable EXTENSION1,EXTENSION2,... [flags]
```

**Examples:**

Enable a single extension:
```bash
sudo canasta extension enable Bootstrap -i mywiki
```

Enable multiple extensions:
```bash
sudo canasta extension enable VisualEditor,PluggableAuth -i mywiki
```

Enable for a specific wiki in a farm:
```bash
sudo canasta extension enable Bootstrap -i mywiki -w soccerwiki
```

### canasta extension disable

Disable one or more Canasta extensions.

**Usage:**
```
canasta extension disable EXTENSION1,EXTENSION2,... [flags]
```

**Examples:**

```bash
sudo canasta extension disable VisualEditor -i mywiki
sudo canasta extension disable VisualEditor,PluggableAuth -i mywiki
```

**Note:** Extension names are case-sensitive.

---

## Skin Management

### canasta skin

Manage Canasta skins for a wiki installation.

**Common Flags (apply to all subcommands):**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--wiki` | `-w` | | ID of specific wiki in the farm (optional) |
| `--verbose` | `-v` | `false` | Verbose output |

### canasta skin list

List all available Canasta skins.

**Usage:**
```
canasta skin list [flags]
```

**Example:**

```bash
sudo canasta skin list -i mywiki
```

### canasta skin enable

Enable one or more Canasta skins.

**Usage:**
```
canasta skin enable SKIN1,SKIN2,... [flags]
```

**Examples:**

```bash
sudo canasta skin enable Vector -i mywiki
sudo canasta skin enable CologneBlue,Modern -i mywiki
```

### canasta skin disable

Disable one or more Canasta skins.

**Usage:**
```
canasta skin disable SKIN1,SKIN2,... [flags]
```

**Example:**

```bash
sudo canasta skin disable Refreshed -i mywiki
```

**Note:** Skin names are case-sensitive.

---

## Maintenance Commands

### canasta maintenance

Run maintenance scripts for a Canasta installation.

**Common Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |

### canasta maintenance update

Run standard maintenance update jobs (update.php, runJobs.php, and Semantic MediaWiki rebuildData.php).

**Usage:**
```
canasta maintenance update [flags]
```

**Example:**

```bash
sudo canasta maintenance update -i mywiki
```

### canasta maintenance script

Run a specific maintenance script.

**Usage:**
```
canasta maintenance script "[scriptname.php] [args]" [flags]
```

**Examples:**

```bash
sudo canasta maintenance script "rebuildall.php" -i mywiki
sudo canasta maintenance script "importDump.php /path/to/dump.xml" -i mywiki
```

---

## Backup and Restore with Restic

Canasta includes integration with [restic](https://restic.net) for automated backups to AWS S3-compatible storage.

### Setup

1. Add these environment variables to your `.env` file:
```
AWS_S3_API=s3.amazonaws.com
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_S3_BUCKET=your-bucket-name
RESTIC_PASSWORD=your-restic-password
```

2. Initialize the restic repository:
```bash
sudo canasta restic init -i mywiki
```

### Common Flags (apply to all restic subcommands)

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--verbose` | `-v` | `false` | Verbose output |

### canasta restic init

Initialize a restic repository in the configured S3 bucket.

**Usage:**
```
canasta restic init [flags]
```

**Example:**

```bash
sudo canasta restic init -i mywiki
```

### canasta restic take-snapshot

Create a new backup snapshot.

**Usage:**
```
canasta restic take-snapshot [flags]
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--tag` | `-t` | Tag for the snapshot (required) |

**Example:**

```bash
sudo canasta restic take-snapshot -t "daily-backup" -i mywiki
```

### canasta restic view

View all available snapshots.

**Usage:**
```
canasta restic view [flags]
```

**Example:**

```bash
sudo canasta restic view -i mywiki
```

### canasta restic restore

Restore from a snapshot.

**Usage:**
```
canasta restic restore [flags]
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--snapshot-id` | `-s` | Snapshot ID to restore (required) |
| `--skip-before-restore-snapshot` | `-r` | Skip taking a backup before restoring |

**Example:**

```bash
sudo canasta restic restore -s abc123def -i mywiki
```

By default, a backup snapshot is taken before restoring. Use `-r` to skip this.

### canasta restic list

List files in a snapshot.

**Usage:**
```
canasta restic list [flags]
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--tag` | `-t` | Snapshot ID (required) |

**Example:**

```bash
sudo canasta restic list -t abc123def -i mywiki
```

### canasta restic forget

Remove a snapshot from the repository.

**Usage:**
```
canasta restic forget [flags]
```

**Flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--tag` | `-t` | Snapshot ID to forget (required) |

**Example:**

```bash
sudo canasta restic forget -t abc123def -i mywiki
```

### canasta restic diff

Show differences between two snapshots.

**Usage:**
```
canasta restic diff [flags]
```

**Flags:**

| Flag | Description |
|------|-------------|
| `--tag1` | First snapshot ID (required) |
| `--tag2` | Second snapshot ID (required) |

**Example:**

```bash
sudo canasta restic diff --tag1 abc123 --tag2 def456 -i mywiki
```

### canasta restic check

Check the integrity of the restic repository.

**Usage:**
```
canasta restic check [flags]
```

**Example:**

```bash
sudo canasta restic check -i mywiki
```

### canasta restic unlock

Remove locks created by other restic processes.

**Usage:**
```
canasta restic unlock [flags]
```

**Example:**

```bash
sudo canasta restic unlock -i mywiki
```

---

## Wiki Farm (Multiple Wikis)

A wiki farm allows you to run multiple wikis within the same Canasta installation, sharing the same software but using different databases and image directories.

### Creating a Wiki Farm

1. Create the initial Canasta installation:
```bash
sudo canasta create -i myfarm -w mainwiki -n example.com -a admin
```

2. Add additional wikis:
```bash
sudo canasta add -i myfarm -w wiki2 -u example.com/wiki2 -a admin
sudo canasta add -i myfarm -w wiki3 -u wiki3.example.com -a admin
```

### URL Routing

- Multiple wikis can share the same domain with different paths (e.g., `example.com`, `example.com/wiki2`)
- Subdomains are treated as separate domains (e.g., `wiki3.example.com`)
- Caddy handles SSL/HTTPS for all configured domains

### Viewing All Wikis

```bash
sudo canasta list
```

### Managing Extensions/Skins per Wiki

Use the `-w` flag to target a specific wiki:
```bash
sudo canasta extension enable SemanticMediaWiki -i myfarm -w wiki2
```

---

## Configuration Files

Canasta installations have this structure:
```
{installation-path}/
  .env                           # Environment variables
  docker-compose.yml             # Docker Compose configuration
  docker-compose.override.yml    # Optional custom overrides
  config/
    wikis.yaml                   # Wiki farm configuration
    Caddyfile                    # Generated reverse proxy config
    SettingsTemplate.php         # Template for wiki settings
    admin-password_{wiki-id}     # Generated admin password per wiki
    {wiki-id}/
      Settings.php               # Wiki-specific settings
      LocalSettings.php          # Generated MediaWiki settings
```

## /etc/canasta/conf.json

The CLI maintains a registry of installations at `/etc/canasta/conf.json` (when running as root) or `~/.config/canasta/conf.json`.

Example structure:
```json
{
  "Installations": {
    "wiki1": {
      "Id": "wiki1",
      "Path": "/home/user/wiki1",
      "Orchestrator": "compose"
    },
    "wiki2": {
      "Id": "wiki2",
      "Path": "/home/user/canasta/wiki2",
      "Orchestrator": "compose"
    }
  }
}
```

---

## Uninstall

To uninstall the Canasta CLI:

```bash
sudo rm /usr/local/bin/canasta
sudo rm -r /etc/canasta
```

**Note:** This only removes the CLI. To delete Canasta installations, use `canasta delete` for each installation first.

---

## Security Considerations

### Password Storage

- **Admin passwords** are stored in plaintext files at `config/admin-password_{wikiid}`
- **Database passwords** are stored in plaintext in the `.env` file
- Ensure proper file permissions on the installation directory to restrict access to these files
- Consider using environment variables when passing passwords on the command line to avoid exposing them in shell history:
  ```bash
  sudo canasta create -i mywiki -w main -a admin --rootdbpass "$ROOT_DB_PASS"
  ```

### Root Access

The CLI requires root/sudo access for:
- Docker operations
- Writing to the configuration registry at `/etc/canasta/conf.json`
- Managing container volumes and networks

### Network Exposure

- By default, Canasta exposes ports for HTTP/HTTPS traffic
- Caddy handles SSL/TLS termination automatically
- Review your `docker-compose.override.yml` if you need to customize port bindings or network settings

---

## Post-Installation Notes

### Email Configuration

Email functionality is **not enabled by default**. To enable email for your wiki, you must configure the `$wgSMTP` setting in your LocalSettings.php. See the [MediaWiki SMTP documentation](https://www.mediawiki.org/wiki/Manual:$wgSMTP) for configuration options.

### Wiki ID Naming Rules

Wiki IDs must follow these rules:
- Only alphanumeric characters, hyphens (`-`), and underscores (`_`) are allowed
- Must start and end with an alphanumeric character
- No spaces or special characters

Valid examples: `mywiki`, `my-wiki`, `wiki_1`, `MyWiki2024`

Invalid examples: `my wiki`, `-mywiki`, `wiki!`, `mywiki-`

---

## Troubleshooting

### Checking Container Status

To see if your Canasta containers are running:
```bash
cd /path/to/installation
sudo docker compose ps
```

### Viewing Container Logs

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

### Accessing the Database

To connect to the MySQL database directly:
```bash
cd /path/to/installation
sudo docker compose exec db mysql -u root -p
```
Enter the root database password from your `.env` file when prompted.

### Running Commands Inside Containers

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

### Common Issues

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

---

## Best Practices

### Backups

- Set up regular backups using `canasta restic` before making significant changes
- Always take a backup before running `canasta upgrade`
- Store restic passwords securely and separately from your server
- Test your backup restoration process periodically

### Before Upgrading

1. Take a backup:
   ```bash
   sudo canasta restic take-snapshot -t "pre-upgrade-$(date +%Y%m%d)" -i mywiki
   ```
2. Review the Canasta release notes for any breaking changes
3. Run the upgrade:
   ```bash
   sudo canasta upgrade -i mywiki
   ```

### Managing Multiple Installations

- Use descriptive instance IDs that indicate the purpose (e.g., `company-wiki`, `docs-internal`)
- Keep a record of which wikis are in each installation if using wiki farms
- Use `canasta list` regularly to review your installations
