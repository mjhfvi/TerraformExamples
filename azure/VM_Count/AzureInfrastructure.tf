############################################################################################################
# Resource File For Terraform windows 10 20h1 with public IP on Azure Source: https://github.com/jmassardo/Azure-WinRM-Terraform
############################################################################################################

provider "azurerm" { # Setup the infrastructure components required to create the environment
  features {}
}

resource "azurerm_resource_group" "rg" {                                 # Create a resource group to contain all the objects
  name     = "${var.azure_rg_name}-${join("", split(":", timestamp()))}" #Removing the colons since Azure doesn't allow them.
  location = var.azure_region
}

resource "azurerm_virtual_network" "vnet" { # Create the virtual network
  name                = "${var.azure_rg_name}_Network"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" { # Create the individual subnet for the servers
  name                 = "${var.azure_rg_name}Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg" { # create the network security group to allow inbound access to the servers
  name                = "${var.azure_rg_name}_nsg"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name

  security_rule { # create a rule to allow RDP inbound to all nodes in the network
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*" # Use a Variables from File, var.source_address_prefix
    destination_address_prefix = "*"
  }

  security_rule { # create a rule to allow WinRM inbound to all nodes in the network. Note the priority. All rules but have a unique priority
    name                       = "Allow_WinRM"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*" # Use a Variables from File, var.source_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sg_assoc" { # Associate NSG with Subnet so systems are protected
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

############################################################################################################
# use "terraform output -raw public_ip" to output only the IP Terminal
## End of Terraform Script
############################################################################################################
