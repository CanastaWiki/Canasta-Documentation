# Backup and restore with restic

Canasta includes integration with [restic](https://restic.net) for automated backups to AWS S3-compatible storage.

## Contents

- [Setup](#setup)
- [Common flags](#common-flags)
- [canasta restic init](#canasta-restic-init) - Initialize a restic repository
- [canasta restic take-snapshot](#canasta-restic-take-snapshot) - Create a backup snapshot
- [canasta restic view](#canasta-restic-view) - View available snapshots
- [canasta restic restore](#canasta-restic-restore) - Restore from a snapshot
- [canasta restic list](#canasta-restic-list) - List files in a snapshot
- [canasta restic forget](#canasta-restic-forget) - Remove a snapshot
- [canasta restic diff](#canasta-restic-diff) - Compare two snapshots
- [canasta restic check](#canasta-restic-check) - Check repository integrity
- [canasta restic unlock](#canasta-restic-unlock) - Remove repository locks

---

## Setup

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

---

## Common flags

These flags apply to all restic subcommands:

| Flag | Short | Default | Description |
|------|-------|---------|-------------|
| `--id` | `-i` | | Canasta instance ID |
| `--path` | `-p` | Current directory | Path to the Canasta installation |
| `--verbose` | `-v` | `false` | Verbose output |

---

## canasta restic init

Initialize a restic repository in the configured S3 bucket.

**Usage:**
```
canasta restic init [flags]
```

**Example:**

```bash
sudo canasta restic init -i mywiki
```

---

## canasta restic take-snapshot

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

---

## canasta restic view

View all available snapshots.

**Usage:**
```
canasta restic view [flags]
```

**Example:**

```bash
sudo canasta restic view -i mywiki
```

---

## canasta restic restore

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

---

## canasta restic list

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

---

## canasta restic forget

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

---

## canasta restic diff

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

---

## canasta restic check

Check the integrity of the restic repository.

**Usage:**
```
canasta restic check [flags]
```

**Example:**

```bash
sudo canasta restic check -i mywiki
```

---

## canasta restic unlock

Remove locks created by other restic processes.

**Usage:**
```
canasta restic unlock [flags]
```

**Example:**

```bash
sudo canasta restic unlock -i mywiki
```
