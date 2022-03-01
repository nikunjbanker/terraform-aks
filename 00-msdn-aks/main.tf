//Refrence 
//1. https://learnk8s.io/terraform-aks
//2. https://registry.terraform.io/modules/sculley/traefik/kubernetes/latest (TODO)
//3. https://github.com/sculley/terraform-kubernetes-traefik (TODO)
//4. 
terraform {
  backend "azurerm" {
    storage_account_name = "tfstatedci"
    container_name       = "tfstate"
    key                  = "${var.environment}.terraform.tfstate" #"dev.terraform.tfstate"

    //access_key = "<COPY YOUR STORAGE ACCESS KEY HERE>"
    # rather than defining this inline, the SAS Token can also be sourced
    # from an Environment Variable - more information is available below.
    //sas_token =  "?sv=2020-02-10&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-06-18T15:45:20Z&st=2021-06-18T07:45:20Z&spr=https&sig=xqEMb4g770DPB%2F8V1M9YONIMSEWzc7taVvj7DnAoZeE%3D" //var.sas_token
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aks-cluster" {
  source = "./moduels/aks-cluster"
  environment = var.environment
  node_count = 1
  kuberenetes-version = "1.19.11"
}

# resource "azurerm_resource_group" "rg" {
#   name     = "aks-cluster-ci-rg-01"
#   location = "centralindia"

#    tags = {
#     Environment = "development",
#     CreatedBy = "Nikunj"
#   }
# }
