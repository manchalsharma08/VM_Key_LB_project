### Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.101.0"
    }
    
   
    random = {
      source = "hashicorp/random"
      version = "3.6.1"
    }
  }
 }
    
  


provider "azurerm" {
  features {}
}

provider "random" {
  # Configuration options
} 



/* ###  provider for random password 

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

provider "random" {
  # Configuration options
}  */