# Canasta CLI

The Canasta command line interface (CLI) is a tool written in Go for managing Canasta MediaWiki installations. It handles creation, import, backup, and management of multiple Canasta instances using Docker Compose as the orchestrator. A future Kubernetes orchestrator is planned to provide greater scalability and supporting tooling for managing and monitoring the cluster. The CLI supports both single wiki installations and wiki farms (multiple wikis in one installation).

## Wiki farms

A wiki farm allows you to run multiple wikis within the same Canasta installation. All wikis in a farm share the same MediaWiki software, but each wiki has its own database and image directory and can enable different extensions and skins.

With the Canasta CLI, you can:

- **Create** a new Canasta installation with an initial wiki using the [create](cli/wiki-management.md#canasta-create) command
- **Add** additional wikis to an existing installation using the [add](cli/wiki-management.md#canasta-add) command
- **Remove** wikis from an installation using the [remove](cli/wiki-management.md#canasta-remove) command
- **List** all installations and their wikis using the [list](cli/wiki-management.md#canasta-list) command
- **Manage extensions and skins** for specific wikis using the `-w` flag with the [extension](cli/maintenance.md#canasta-extension) and [skin](cli/maintenance.md#canasta-skin) commands
- **Delete** a Canasta installation and all wikis that it hosts using the [delete](cli/wiki-management.md#canasta-delete) command

### URL schemes

Wikis in a farm can be accessed using different URL schemes:

- **Path-based**: Multiple wikis share the same domain with different paths (e.g., `example.com`, `example.com/wiki2`, `example.com/docs`)
- **Subdomain-based**: Each wiki uses a different subdomain (e.g., `wiki.example.com`, `docs.example.com`)
- **Mixed**: A combination of paths and subdomains

Subdomain-based routing requires that the subdomains are configured correctly in DNS to point to your Canasta server. Caddy handles SSL/HTTPS automatically for all configured domains. See the [canasta add](cli/wiki-management.md#canasta-add) command for examples of each URL scheme.

---

## Global flags

```
Flags:
  -d, --docker-path string   Path to docker compose binary
  -h, --help                 Help for canasta
  -v, --verbose              Verbose output
```

Most commands also accept these flags to identify a Canasta installation:

- `-i, --id`: Canasta instance ID (the name you gave when creating the installation)
- `-p, --path`: Path to the Canasta installation directory

If you run commands from within the Canasta installation directory, the `-i` flag is not required.

## Getting help

Use `canasta help` or `canasta --help` to see the list of available commands. For help with a specific command, use:

```bash
canasta [command] --help
```

For example:
```bash
canasta create --help
```

---

## Documentation

| Section | Description |
|---------|-------------|
| [Installation](cli/installation.md) | Pre-requisites, installing, and uninstalling the CLI |
| [Wiki management](cli/wiki-management.md) | Creating, importing, and managing wikis and wiki farms |
| [Maintenance](cli/maintenance.md) | Extensions, skins, maintenance scripts, and lifecycle commands |
| [Development mode](cli/devmode.md) | Live code editing and Xdebug debugging for development |
| [Backup](cli/backup.md) | Backup and restore with restic |
| [Canasta](cli/canasta.md) | Upgrade and version commands |
| [Best practices](cli/best-practices.md) | Security considerations and best practices |
| [Troubleshooting](cli/troubleshooting.md) | Common issues and debugging |

---

## Configuration files

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

The CLI maintains a registry of installations in a `conf.json` file. The location depends on the operating system and whether running as root:

- **Linux (root)**: `/etc/canasta/conf.json`
- **Linux (non-root)**: `~/.config/canasta/conf.json`
- **macOS**: `~/Library/Application Support/canasta/conf.json`

Example structure:
```json
{
  "Orchestrators": {},
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
