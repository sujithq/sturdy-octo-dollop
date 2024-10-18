terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
  }

  required_version = ">=1.9.5"
  
  backend "azurerm" { }  
}

# Configure AzureRM Provider
provider "azurerm" {
  features {}
}