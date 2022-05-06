#! /bin/bash
sudo hostnamectl set-hostname ansible-server
sudo apt-get update
sudo apt-get install -y awscli
sudo apt-get install -y git
sudo apt-get install -y ansible
sudo apt-get install -y python3-pip
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-11-jdk
pip3 install boto3
ansible-galaxy collection install amazon.aws
mkdir -p /home/ubuntu/git
git clone https://github.com/dzbeda/opsschool-mid-project.git /home/ubuntu/git
