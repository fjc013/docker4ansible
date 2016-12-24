#!/bin/bash
# -*- mode: bash -*-
# vi: set ft=bash :

# sudo apt-get update

echo "Installing common items and ansible dependencies"
sudo apt-get install curl unzip software-properties-common -y
# sudo easy_install pip

echo "Installing ansible and whois (for mkpasswd)"
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y
sudo apt-get install whois -y

# echo "Installing ansible dependencies"
#/usr/local/bin/pip install git+git://github.com/openstack/python-novaclient
#/usr/local/bin/pip install docker-py
#/usr/local/bin/pip install pyrax

#echo "Removing the default /etc/ansible directory, and symlink it to the vagrant folder"
#rm -rf /etc/ansible
#ln -s /vagrant/ansible/etc/ansible/ /etc/ansible

echo "Creating the ansible log file"
sudo touch /var/log/ansible.log
sudo chmod 777 /var/log/ansible.log

#echo "Moving vault.secret due to Vagrant permission defaults"
#cp /vagrant/ansible/vault.secret /tmp/vault.secret; chmod 644 /tmp/vault.secret
