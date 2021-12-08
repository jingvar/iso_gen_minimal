#!/bin/bash
set -xe
echo "ubuntu-live" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "deb http://archive.ubuntu.com/ubuntu focal universe" >> /etc/apt/sources.list
apt-get update && apt-get install  -y --no-install-recommends \
   linux-generic \
   live-boot \
   systemd-sysv \
   apt-transport-https \
   openssh-server \
   curl \
   gnupg \
   iptables \
   ifenslave \
   bridge-utils \
   tcpdump \
   iputils-ping \
   vlan \
   locales \
   lsb-release \
   ebtables \
   sudo

# ensure we support bonding and 802.1q
echo 'bonding' >> /etc/modules
echo '8021q' >> /etc/modules

locale-gen en_US.UTF-8
systemctl enable systemd-networkd
echo 'br_netfilter' >> /etc/modules

apt-get install  -y --no-install-recommends \
   cloud-init git vim less wget 

echo 'devusr        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers
echo 'devusr:r00tme' | chpasswd
