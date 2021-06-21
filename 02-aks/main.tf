//Refrence https://learnk8s.io/terraform-aks
terraform {
  backend "azurerm" {
    storage_account_name = "tfstatedci"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"

    //access_key = "<COPY YOUR STORAGE ACCESS KEY HERE>"
    # rather than defining this inline, the SAS Token can also be sourced
    # from an Environment Variable - more information is available below.
    sas_token = "?sv=2020-02-10&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-06-18T01:41:10Z&st=2021-06-17T17:41:10Z&spr=https&sig=%2ByJwV%2FlrlQ8sEiuoZnQEt94X%2BZCuqpfSq7u4OUs8H6A%3D"
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

variable "location" {
  type    = string
  default = "centralindia"
}

variable "rgname" {
  type    = string
  default = "aks-cluster-ci-rg-01"
}

# resource "azurerm_resource_group" "rg" {
#   name     = "aks-cluster-ci-rg-01"
#   location = "centralindia"

#    tags = {
#     Environment = "development",
#     CreatedBy = "Nikunj"
#   }
# }

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "aksdev"
  location   = var.location
  dns_prefix = "aksdev"

  resource_group_name = var.rgname
  kubernetes_version  = "1.18.17"

  default_node_pool {
    name       = "aksdev"
    node_count = "1"
    vm_size    = "Standard_D2s_v3"
  }

 identity {
    type = "SystemAssigned"
  }

   tags = {
    Environment = "development",
    CreatedBy = "Nikunj"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "npl001" {
  name                  = "npl001"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_D2ds_v4"
  node_count            = 1

  tags = {
    Environment = "development",
    CreatedBy = "Nikunj"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
