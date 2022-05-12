## Prerequisites ##
1. Linux based server with the follwoing packages 
2. Ansible - how to install ?
    1. 
3. Terraform - How to install ?
    1.  
4. Git installation - How to install ?
    1.  
4. AWScli installation - How to install ?
    1. 
5. Update AWS credentials as Environment variables - Run the follwoing command
    1. export AWS_ACCESS_KEY_ID=XXXX
    2. export AWS_SECRET_ACCESS_KEY=XXXX 


## Mid-project installation steps ##

1. Open a new folder named “mid-project”  - run the following commands 
    1. mkdir mid-project
    2. cd mid-project
2. Clone the repo - run the following commands 
    1. Git clone https://github.com/dzbeda/opsschool-mid-project.git
3. Move to the terraform folder - run the following commands 
    1. cd terraform 
4. Update relevant parameters in terraform.tfvars
    1. Instances type
    2. AMI 
    3. AWS-Region 
    4. ETC
5. Run terraform plan - run the following commands 
    1. terraform plan –out project 
6. Apply terraform plan - run the following commands    
    1. terraform apply project 
7. Cross your fingers and hope for the good
