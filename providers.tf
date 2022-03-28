terraform {
    required_version = ">=0.12"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.0"
        }
    }
    
    backend "azurerm" {
        resource_group_name = "devops-terraform-intern-task-states"
        storage_account_name = "devopsinterntfstatestore"
        container_name = "tfvmstates"
        key = "tfvm.tfstate"
    }
}

provider "azurerm" {
    features {}
}