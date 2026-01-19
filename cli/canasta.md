# Canasta Commands

This page documents the Canasta CLI commands for upgrading and checking the version of Canasta.

## Contents

- [canasta upgrade](#canasta-upgrade) - Upgrade a Canasta installation
- [canasta version](#canasta-version) - Display version information

---

## canasta upgrade

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

## canasta version

Display the Canasta CLI version information.

**Usage:**
```
canasta version
```
