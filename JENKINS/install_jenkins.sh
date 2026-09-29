#!/bin/bash
set -eux

apt update
apt install -y fontconfig openjdk-21-jre wget gnupg ca-certificates curl git maven

mkdir -p /usr/share/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key -o /tmp/jenkins.key
gpg --dearmor --yes -o /usr/share/keyrings/jenkins.gpg /tmp/jenkins.key
chmod 644 /usr/share/keyrings/jenkins.gpg

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

apt update
apt install -y jenkins
systemctl enable --now jenkins

echo "jenkins is installed"
echo "initial password:"
cat /var/lib/jenkins/secrets/initialAdminPassword