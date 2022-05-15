#! /bin/bash
sudo apt-get update
## Install python and packages
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install python-boto3
sudo pip3 install boto3
sudo pip3 install --upgrade awscli
## Install ansible and supported packages
sudo apt-get install -y ansible
ansible-galaxy collection install amazon.aws
##Install AWSCLI
sudo apt-get install -y awscli
## Install terraform 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
# Install additional packages
sudo apt-get install -y git
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-11-jdk
# Create folders 
mkdir mid-project
# Clone project 
git clone https://github.com/dzbeda/opsschool-mid-project.git mid-project
## Update SSH configuartion 
sudo chmod o+w /etc/ssh/ssh_config
sudo echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
sudo chmod o-w /etc/ssh/ssh_config
## Install kubectl
curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin
## Install ekscli
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
