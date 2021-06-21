resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "aks${var.environment}"
  location   = var.location
  dns_prefix = "aks${var.environment}"

  resource_group_name = var.rgname
  kubernetes_version  = var.kuberenetes-version

  default_node_pool {
    name       = "aks${var.environment}"
    node_count = "1"
    vm_size    = "Standard_D2s_v3"
    orchestrator_version  = var.kuberenetes-version
  }

 identity {
    type = "SystemAssigned"
  }

   tags = {
    Environment = var.environment,
    CreatedBy = "Nikunj"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "npl001" {
  name                  = "npl001"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_D2ds_v4"
  node_count            = var.node_count
  orchestrator_version  = var.kuberenetes-version

  tags = {
    Environment = var.environment,
    CreatedBy = "Nikunj"
  }
}