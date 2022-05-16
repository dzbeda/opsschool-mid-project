# The Kandula project #
  OpsSchool - Mid project 


## Mid-project installation ##
The project execution is divided into 3 main steps

1. Prerequisites
2. Execution server installation  
3. Kandula project execution  


There are 2 options to install the execution server 
1. Automatic installation
2. Manual installation 

### Prerequisites ###
1. Linux based server -  Ubuntu distribution
2. Create S3 bucket - This is required in order to save the TFstate file of Terraform

### Execution server installation ###

#### Automatic Installation ####

1. Download the execution-server-setup.sh
2. update file permission - Run the following command
    1. chmod 777 execution-server-setup.sh
3. Run the script - Run the following command
    1. ./execution-server-setup.sh


#### Manual installation ####

1. Update index repo - How to install ? Run the following command
    1. sudo apt-get update
2. Install supported packages - How to install ? Run the following command
    1. sudo apt-get install -y python3
    2. udo apt-get install -y python3
    3. sudo apt-get install -y python3-pip
    4. sudo apt-get install -y awscli
    5. sudo apt-get install -y git
    6. sudo apt-get install -y unzip
    7. sudo apt-get install -y openjdk-11-jdk
    8. pip3 install boto3
    9. pip3 install --upgrade awscli
3. Install Ansible - how to install ? Run the following command
    1. sudo pip3 install ansible
    2. ansible-galaxy collection install amazon.aws
4. Terraform - How to install ? Run the following command
    1.  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    2. sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    3. sudo apt install terraform
5. Install kubectl - How to install ? Run the following command  ; Cuurenlt version 123.6 is being installed since version 1.24 have a bug
    1. curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
    2. chmod +x kubectl
    3. sudo mv ./kubectl /usr/local/bin
6. Install ekscli - How to install ? Run the following command
    1. curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    2. sudo mv /tmp/eksctl /usr/local/bin
7. Update "/etc/ssh/ssh_config" file with the follwoing "StrictHostKeyChecking no"
8. Clone repo - How to install ? Run the following command
    1. Open a new folder named “mid-project”  - run the following commands 
      1. mkdir mid-project
    2. cd mid-project
    3. Clone the repo - run the following commands 
      1. Git clone https://github.com/dzbeda/opsschool-mid-project.git mid-project


### Kandula project execution ###
1. **Update AWS credentials as Environment variables - Run the following command**
     1. export AWS_ACCESS_KEY_ID=XXXX
     2. export AWS_SECRET_ACCESS_KEY=XXXX 
2. Move to the terraform folder - run the following commands 
    1. cd mid-project
    2. cd terraform 
3. Update the S3 bucket name in "provider.tf" file under "backend "s3" --> bucket" section
4. Update relevant parameters in "terraform.tfvars" file
    1. **Ip address of the machine from which you are running TF (bastion_enable_ip_for_ssh)**
    2. AWS-Region
    3. Instances type
    4. ETC
4. Intilize Terraform -  run the following commands 
    1. terraform init ; If everything passed move to the next step
5. Verify the project plan - run the following commands 
    1. terraform plan -out project ; If everything passed move to the next step (Please note that sometimes copy-paste update the "-" character)
5. Apply terraform plan - run the following commands  (Please note that sometimes copy-paste update the "-" character)   
    1. terraform apply project 
6. Cross your fingers and hope for the good
