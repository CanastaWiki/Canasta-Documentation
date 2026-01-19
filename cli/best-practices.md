# Best practices and security

This page covers security considerations and best practices for managing Canasta installations.

## Contents

- [Security Considerations](#security-considerations)
  - [Password Storage](#password-storage)
  - [Root Access](#root-access)
  - [Network Exposure](#network-exposure)
- [Best Practices](#best-practices)
  - [Backups](#backups)
  - [Before Upgrading](#before-upgrading)
  - [Managing Multiple Installations](#managing-multiple-installations)
- [Post-Installation Notes](#post-installation-notes)
  - [Email Configuration](#email-configuration)
  - [Wiki ID Naming Rules](#wiki-id-naming-rules)

---

## Security considerations

### Password storage

- **Admin passwords** are stored in plaintext files at `config/admin-password_{wikiid}`
- **Database passwords** are stored in plaintext in the `.env` file
- Ensure proper file permissions on the installation directory to restrict access to these files
- Consider using environment variables when passing passwords on the command line to avoid exposing them in shell history:
  ```bash
  sudo canasta create -i mywiki -w main -a admin --rootdbpass "$ROOT_DB_PASS"
  ```

### Root access

The CLI requires root/sudo access for:
- Docker operations
- Writing to the configuration registry at `/etc/canasta/conf.json`
- Managing container volumes and networks

### Network exposure

- By default, Canasta exposes ports for HTTP/HTTPS traffic
- Caddy handles SSL/TLS termination automatically
- Review your `docker-compose.override.yml` if you need to customize port bindings or network settings

---

## Best practices

### Backups

- Set up regular backups using `canasta restic` before making significant changes
- Always take a backup before running `canasta upgrade`
- Store restic passwords securely and separately from your server
- Test your backup restoration process periodically

### Before upgrading

1. Take a backup:
   ```bash
   sudo canasta restic take-snapshot -t "pre-upgrade-$(date +%Y%m%d)" -i mywiki
   ```
2. Review the Canasta release notes for any breaking changes
3. Run the upgrade:
   ```bash
   sudo canasta upgrade -i mywiki
   ```

### Managing multiple installations

- Use descriptive instance IDs that indicate the purpose (e.g., `company-wiki`, `docs-internal`)
- Keep a record of which wikis are in each installation if using wiki farms
- Use `canasta list` regularly to review your installations

---

## Post-installation notes

### Email configuration

Email functionality is **not enabled by default**. To enable email for your wiki, you must configure the `$wgSMTP` setting in your LocalSettings.php. See the [MediaWiki SMTP documentation](https://www.mediawiki.org/wiki/Manual:$wgSMTP) for configuration options.

### Wiki ID naming rules

Wiki IDs must follow these rules:
- Only alphanumeric characters, hyphens (`-`), and underscores (`_`) are allowed
- Must start and end with an alphanumeric character
- No spaces or special characters

Valid examples: `mywiki`, `my-wiki`, `wiki_1`, `MyWiki2024`

Invalid examples: `my wiki`, `-mywiki`, `wiki!`, `mywiki-`
