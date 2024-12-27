variable "name" { default = "dynamic-aws-creds-operator" }
variable "region" { default = "eu-central-1" }
variable "path" { default = "../vault-admin-workspace/terraform.tfstate" }
variable "ttl" { default = "1" }
 
terraform {
 backend "local" {
   path = "terraform.tfstate"
 }
}
 
data "terraform_remote_state" "admin" {
 backend = "local"
 
 config = {
   path = var.path
 }
}
 
data "vault_aws_access_credentials" "creds" {
 backend = data.terraform_remote_state.admin.outputs.backend
 role    = data.terraform_remote_state.admin.outputs.role
}
 
provider "aws" {
 region     = var.region
 access_key = data.vault_aws_access_credentials.creds.access_key
 secret_key = data.vault_aws_access_credentials.creds.secret_key
}
 
resource "aws_s3_bucket" "spacelift-test1-s3" {
   bucket = "spacelift-test1-s3"
   acl = "private"  
}
Along with main.tf, let’s create version.tf for AWS and vault version.

terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "3.23.0"
   }
}
