variable "location" {
  type    = string
  default = "centralindia"
}

variable "rgname" {
  type    = string
  default = "aks-cluster-ci-rg-01"
}

variable "node_count" {
  type = number
  default = 1
}

variable "environment" {
  type = string
}

variable "kuberenetes-version"{
  type = string
}