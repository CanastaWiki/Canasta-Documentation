# Maintenance commands

This page documents the Canasta CLI commands for managing extensions, skins, running maintenance scripts, and controlling the Canasta installation lifecycle.

## Contents

- [canasta extension](#canasta-extension) - Manage extensions
  - [canasta extension list](#canasta-extension-list)
  - [canasta extension enable](#canasta-extension-enable)
  - [canasta extension disable](#canasta-extension-disable)
- [canasta skin](#canasta-skin) - Manage skins
  - [canasta skin list](#canasta-skin-list)
  - [canasta skin enable](#canasta-skin-enable)
  - [canasta skin disable](#canasta-skin-disable)
- [canasta maintenance](#canasta-maintenance) - Run maintenance scripts
  - [canasta maintenance update](#canasta-maintenance-update)
  - [canasta maintenance script](#canasta-maintenance-script)
- [canasta start](#canasta-start) - Start the installation
- [canasta stop](#canasta-stop) - Stop the installation
- [canasta restart](#canasta-restart) - Restart the installation

---

## canasta extension

Manage Canasta extensions for a wiki installation.

**Common Flags (apply to all subcommands):**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
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

## canasta skin

Manage Canasta skins for a wiki installation.

**Common Flags (apply to all subcommands):**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
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

## canasta maintenance

Run maintenance scripts for a Canasta installation.

**Common Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |

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

## canasta start

Start a Canasta installation.

**Usage:**
```
canasta start [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--dev` | `-D` | | Start in development mode with Xdebug (see [Development mode](devmode.md)) |
| `--no-dev` | | | Start without development mode (disable dev mode) |

**Examples:**

```bash
sudo canasta start -i mywiki
```

Enable dev mode on an existing installation:
```bash
sudo canasta start -i mywiki --dev
```

---

## canasta stop

Stop a Canasta installation.

**Usage:**
```
canasta stop [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |

**Example:**

```bash
sudo canasta stop -i mywiki
```

---

## canasta restart

Restart a Canasta installation.

**Usage:**
```
canasta restart [flags]
```

**Flags:**

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--verbose` | `-v` | `false` | Verbose output |
| `--dev` | `-D` | | Restart in development mode with Xdebug (see [Development mode](devmode.md)) |
| `--no-dev` | | | Restart without development mode (disable dev mode) |

**Examples:**

```bash
sudo canasta restart -i mywiki
```

Enable dev mode:
```bash
sudo canasta restart -i mywiki --dev
```

Disable dev mode:
```bash
sudo canasta restart -i mywiki --no-dev
```
