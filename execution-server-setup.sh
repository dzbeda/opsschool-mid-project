#! /bin/bash
set -e
## Update apt index
sudo apt-get update
## Install supported packages
echo " ### Start installing supported packages ###"
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install -y awscli
sudo apt-get install -y git
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-11-jdk
pip3 install boto3
pip3 install --upgrade awscli
## Install ansible
echo " ### Start installing Ansible ###"
sudo pip3 install ansible
ansible-galaxy collection install amazon.aws
# Clone project repo
echo " ### Cloning repo ###"
mkdir mid-project
git clone https://github.com/dzbeda/opsschool-mid-project.git mid-project
# Install terraform 
echo " ### Start installing Terraform ###"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
# Install kubectl
echo "Start installing Kubectl - version 1.23.6 "
curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin
## Install ekscli
echo " ### Start installing EKScli ###"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
## Install Helm
echo " ### Start installing Helm ###"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
# Update SSH configuartion
echo " ### Update ssh_config ###"
sudo chmod o+w /etc/ssh/ssh_config
sudo echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
sudo chmod o-w /etc/ssh/ssh_config
