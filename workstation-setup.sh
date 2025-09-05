#!/bin/bash
set -e

echo "===== Updating system ====="
sudo apt update -y && sudo apt upgrade -y

echo "===== Installing prerequisites ====="
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gpg \
    software-properties-common \
    gnupg \
    lsb-release \
    unzip \
    wget \
    git

# ---------------------------
# Docker & Docker Compose
# ---------------------------
echo "===== Installing Docker ====="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "===== Enabling Docker ====="
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install Docker Compose v2 (CLI plugin already installed above)
sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose || true

# ---------------------------
# Kubectl
# ---------------------------
echo "===== Installing kubectl ====="
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

sudo apt-get update
sudo apt-get install -y kubectl


# ---------------------------
# Ansible
# ---------------------------
echo "===== Installing Ansible ====="
sudo apt install -y ansible

# ---------------------------
# Trivy
# ---------------------------
echo "===== Installing Trivy ====="
sudo apt-get install -y rpm
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/trivy.gpg
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update -y
sudo apt install -y trivy

# ---------------------------
# JDK 17
# ---------------------------
echo "===== Installing OpenJDK 17 ====="
sudo apt install -y openjdk-17-jdk

# ---------------------------
# Jenkins
# ---------------------------
echo "===== Installing Jenkins ====="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# ---------------------------
# Node.js & npm
# ---------------------------
echo "===== Installing Node.js (LTS) & npm ====="
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g npm@latest

# ---------------------------
# Terraform
# ---------------------------
echo "===== Installing Terraform ====="
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt install -y terraform

# ---------------------------
# Maven
# ---------------------------
echo "===== Installing Maven ====="
sudo apt install -y maven


# ---------------------------
# AWS CLI v2
# ---------------------------
echo "===== Installing AWS CLI v2 ====="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# ---------------------------
# Python 3 & Pip
# ---------------------------
echo "===== Installing Python 3 & Pip ====="
sudo apt install -y python3 python3-pip python3-venv

# ---------------------------
# Helm
# ---------------------------
echo "===== Installing Helm ====="
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y


echo "===== Installation Completed Successfully! ====="
echo "⚠️ Please log out and log back in (or run 'newgrp docker') to use Docker without sudo."
