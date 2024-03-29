#!/bin/sh
set -e

# This script is an EXAMPLE of a script that can prepare a cloud host for Canasta by installing the 
# proper Docker software used by the Canasta Stack when Docker Engine is your container engine
# and Docker Compose is your orchestrator, in a 'headless' (server) environment. In other words,
# This script is useful when you are not working on a local machine where Docker Desktop would be 
# the preferred way of preparing the host.

# This example is specific to Ubuntu Linux

# This example is to prepare a TEST host. Using it on a live system, production environment or daily driver is 
# NOT recommended as it does not make any claims of being complete. For instance, no system hardening is part of 
# this example.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker software
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Cleanup any old (deprecated) software
sudo apt -y autoremove

# Test the Docker installation
sudo docker run hello-world