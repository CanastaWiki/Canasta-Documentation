#!/bin/sh
set -e

# This script is an EXAMPLE of a script that can prepare your host for Canasta by installing the 
# proper Docker software used by the Canasta Stack when Docker Engine is your container engine
# and Docker Compose is your orchestrator

# This example is specific to Ubuntu

# This example is to prepare a TEST host. Using it on a live system, production environment or daily driver is 
# NOT recommended.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Cleanup any old (deprecated) software
sudo apt autoremove

# Test the Docker installation
sudo docker run hello-world