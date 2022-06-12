To run Terraform manifest you need to install terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
then you need to rename file terraform.tfvars.simple to terraform.tfvars and fill in empty spaces in variable's values fields. 
do ```terraform init``` in console (bash, whatever) and ```terraform plan```. It will show what resources will be created. Then run ```terraform apply```. Now its done.
