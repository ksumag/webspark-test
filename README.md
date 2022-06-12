================================================================
## RUN ON TERRAFORM (Right choice;) )
To run Terraform manifest you need to install terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
then you need to rename file terraform.tfvars.simple to terraform.tfvars and fill in empty spaces in variable's values fields. 
do ```terraform init``` in console (bash, whatever) and ```terraform plan```. It will show what resources will be created. Then run ```terraform apply```. Now its done. For working test you can use yours aws cli:  
```aws s3 cp ./index.html s3://${bucketname}/ ``` .

To erase what you have done you need type ```terraform destroy```. Bucket must be cleaned before that. 

===================================================================
## RUN ON AWS CLODFORMATION (AWS_CLI)
To run task from aws cli you neet to write in test.yml yours parameters values and run 

 ``` 
 aws cloudformation create-stack --stack-name $name --template-body file://$PWD/test.yml 
 ```

 or try to run with ovverriide parameters like this

 ``` 
 aws cloudformation create-stack --stack-name $name --template-body $PWD/test.yml --parameters ParameterKey=DomainName,ParameterValue=$DomainName --parameters ParameterKey=BucketName, ParameterValue=$BucketName --parameters ParameterKey=HostedZoneId, ParameterValue=$HostedZoneId --parameters ParameterKey=CertificateArn, ParameterValue=$CertificateArn 
 ```

===================================================================