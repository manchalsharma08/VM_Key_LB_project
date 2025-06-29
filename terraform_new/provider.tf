terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "pipe-rg"
    storage_account_name = "pipestorage9875903"
    container_name       = "pipecontainer"
    key                  = "pipe.terraform.tfstate" 
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "7602ad0d-b3e4-4824-a88d-a49042a4adc4"
  subscription_id = "3a734e32-021d-4243-89ff-c3495e6aa4da"
}

data "azurerm_client_config" "current" {}