# Canasta CLI Installation

This page covers installing and uninstalling the Canasta command line interface (CLI).

## Contents

- [Pre-requisites](#pre-requisites)
- [Installation](#installation)
- [Uninstall](#uninstall)

---

## Pre-requisites

Before using the Canasta CLI, you must have both Docker Engine and Docker Compose installed.

### Windows and macOS

Docker Compose is included in [Docker Desktop](https://www.docker.com/products/docker-desktop) for Windows and macOS.

### Linux

Linux is the most-tested and preferred OS environment as the host for Canasta. Installing the requirements is fast and easy to do on common Linux distributions such as Debian, Ubuntu, Red Hat, and CentOS. While you can get up and running with all the Docker requirements by installing Docker Desktop on Linux, if you are using a 'server environment' (no GUI), the recommended way to install is to **uninstall** any distribution-specific software and [install Docker software using the Docker repositories](https://docs.docker.com/compose/install/linux/#install-using-the-repository). (The link is the install guide for Docker Compose which will also install the Docker Engine.)

### Example

Essentially, preparing your Linux server to be a Canasta host by installing the Docker suite of software includes something like
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin` once you've
added the Docker repositories to your system. A full example script for Ubuntu can be found at [example-prepare-ubuntu-headless.sh](../example-prepare-ubuntu-headless.sh)

---

## Installation

Run the following line to install the Canasta CLI (be sure you have write permissions in the current working directory):

```
curl -fsL https://raw.githubusercontent.com/CanastaWiki/Canasta-CLI/main/install.sh | bash
```

---

## Uninstall

To uninstall the Canasta CLI:

```bash
sudo rm /usr/local/bin/canasta
sudo rm -r /etc/canasta
```

**Note:** This only removes the CLI. To delete Canasta installations, use `canasta delete` for each installation first.
