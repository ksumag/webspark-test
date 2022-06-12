/*variable "my-access-key" {
    description = "accsess AWS"
    type = string
    
} 
variable "my-secret-key" {
    description = "secret AWS"
    type = string
    
} */

variable "DomainName" {
    description = "The DNS name of an existing Amazon Route 53 hosted zone"
    type = string
    
} 

variable "BucketName" {
    description = "Amazon S3 files bucket name"
    type = string
} 

variable "HostedZoneId" {
    description = "Amazon Route53 Hosted Zone Id for DomainName"
    type = string
} 

variable "CertificateArn" {
    description = "ACertificate Link"
    type = string
} 




