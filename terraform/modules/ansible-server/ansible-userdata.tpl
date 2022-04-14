#! /bin/bash
sudo hostnamectl set-hostname ansible-server
sudo apt-get update
sudo apt-get install -y awscli
sudo apt-get install -y git
sudo apt-get install -y ansible
sudo apt-get install -y python3-pip
sudo pip3 install boto3
ansible-galaxy collection install amazon.aws
mkdir -p /home/ubuntu/ansible
cat /home/ubuntu/.ssh/authorized_keys >> /home/ubuntu/.ssh/id_rsa.pub
git clone https://github.com/dzbeda/opsschool-mid-project.git /home/ubuntu/ansible
