# The Kandula project #
  OpsSchool - Mid project 


## Mid-project installation ##
The project execution is divided into 3 main steps

1. Prerequisites
2. Execution server installation  
3. Kandul project execution  


There are 2 options to install the execution server 
1. Automatic installation
2. Manual installation 

### Prerequisites ###
1. Linux based server
2. Cretae S3 bucket - This is required in order to save the TFstate file of Terraform

### Execution server installation ###

#### Automatic Installation ####

1. Download the execution-server-setup.sh
2. update file permission - Run the following command
    1. chmod 777 execution-server-setup.sh
3. Run the script - Run the following command
    1. ./execution-server-setup.sh
4. Update AWS credentials as Environment variables - Run the following command
    1. export AWS_ACCESS_KEY_ID=XXXX
    2. export AWS_SECRET_ACCESS_KEY=XXXX 


#### Manual installation ####

1. Install python3 - How to install ? Run the following command
    1. sudo apt-get install -y python3
    2. sudo apt-get install -y python3-pip
    3. sudo pip3 install boto3
2. Ansible - how to install ? Run the following command
    1. sudo apt-get install -y ansible
    2. ansible-galaxy collection install amazon.aws
3. Terraform - How to install ? Run the following command
    1.  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    2. sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    3. sudo apt install terraform
4. Git installation - How to install ? Run the following command
    1.  sudo apt-get install -y git
5. AWScli installation - How to install ? Run the following command
    1. sudo apt-get install -y awscli
6. Supported packages - How to install ? Run the following command
    1. sudo apt-get install -y unzip
    2. sudo apt-get install -y openjdk-11-jdk
7. Open a new folder named “mid-project”  - run the following commands 
    1. mkdir mid-project
    2. cd mid-project
8. Clone the repo - run the following commands 
    1. Git clone https://github.com/dzbeda/opsschool-mid-project.git mid-project


### Kandula project execution ###
> :warning:1. Update AWS credentials as Environment variables - Run the following command
    1. export AWS_ACCESS_KEY_ID=XXXX
    2. export AWS_SECRET_ACCESS_KEY=XXXX 
2. Move to the terraform folder - run the following commands 
    1. cd mid-project
    2. cd terraform 
3. Update the S3 bucket name in "provider.tf" file under "backend "s3" --> bucket" section
4. Update relevant parameters in "terraform.tfvars" file
> :warning:   1. Ip address of the machine from which you are running TF (bastion_enable_ip_for_ssh)
    2. AWS-Region
    3. Instances type
    4. ETC
4. Run terraform plan - run the following commands 
    1. terraform plan –out project ; If everything passed move to the next step
5. Apply terraform plan - run the following commands    
    1. terraform apply project 
6. Cross your fingers and hope for the good
