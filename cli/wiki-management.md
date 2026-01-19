# Wiki and wiki farm management commands

This page documents the Canasta CLI commands for creating, importing, and managing wikis and wiki farms.

## Contents

- [canasta create](#canasta-create) - Create a new Canasta installation
- [canasta import](#canasta-import) - Import an existing MediaWiki installation
- [canasta add](#canasta-add) - Add a wiki to a wiki farm
- [canasta remove](#canasta-remove) - Remove a wiki from a wiki farm
- [canasta delete](#canasta-delete) - Delete an entire Canasta installation
- [canasta list](#canasta-list) - List all Canasta installations
- [Wiki farm example](#wiki-farm-example) - Complete workflow for creating a wiki farm

---

## canasta create

Create a new Canasta installation.

**Usage:**
```
canasta create [flags]
```

**Required flags:**

| Flag | Short | Description |
|------|-------|-------------|
| `--id` | `-i` | Canasta instance ID (must be alphanumeric with optional hyphens/underscores) |
| `--admin` | `-a` | Initial wiki admin username |

**Optional flags:**

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

## canasta import

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

**Before importing:**
1. Create a `.env` file (see [.env.example](https://github.com/CanastaWiki/Canasta-DockerCompose/blob/main/.env.example))
2. Prepare your database dump (.sql or .sql.gz)
3. Update your LocalSettings.php database configuration:
   - Database host: `db`
   - Database user: `root`
   - Database password: Use the password from your `.env` file

---

## canasta add

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

## canasta remove

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

## canasta delete

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

## canasta list

List all Canasta installations managed by the CLI.

**Usage:**
```
canasta list
```

**Example:**

```bash
sudo canasta list
```

**Example output:**

```
Canasta ID  Wiki ID  Server Name  Server Path  Installation Path              Orchestrator
myfarm      wiki1    example.com  /            /home/user/myfarm              compose
myfarm      wiki2    example.com  /docs        /home/user/myfarm              compose
mywiki      main     localhost    /            /home/user/mywiki              compose
```

This displays all registered installations and wikis, showing:
- **Canasta ID**: The installation identifier
- **Wiki ID**: The wiki identifier within the installation
- **Server Name**: The domain name for the wiki
- **Server Path**: The URL path for the wiki
- **Installation Path**: The filesystem path to the installation
- **Orchestrator**: The orchestrator being used

---

## Wiki farm example

This example demonstrates creating a wiki farm with multiple wikis using different URL schemes.

**1. Create the initial installation with the first wiki:**
```bash
sudo canasta create -i myfarm -w mainwiki -n example.com -a admin
```

**2. Add a wiki using a path on the same domain:**
```bash
sudo canasta add -i myfarm -w docs -u example.com/docs -t "Documentation Wiki" -a admin
```

**3. Add a wiki using a subdomain:**
```bash
sudo canasta add -i myfarm -w community -u community.example.com -a admin
```

**4. View all wikis in the farm:**
```bash
sudo canasta list
```

**5. Manage extensions for a specific wiki:**
```bash
sudo canasta extension enable SemanticMediaWiki -i myfarm -w docs
```

**6. Remove a wiki from the farm:**
```bash
sudo canasta remove -i myfarm -w community
```
