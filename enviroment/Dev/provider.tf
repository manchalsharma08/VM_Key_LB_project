terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id = "c600c9bd-13dc-4612-83ce-085c20851001"
  subscription_id = "e218c587-9161-4518-91c3-1eb54c4095e8"
}
