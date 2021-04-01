## Terraform Script to setup windows 10 20h1 with public IP on Azure and WinRM open

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {					# Create Resource Group
  name    						  = "${var.prefix}-resources"
  location 						  = var.location
}

resource "azurerm_virtual_network" "main" {					# Create Virtual Network
  name                			  = "${var.prefix}-network"
  address_space      		 	  = ["10.0.0.0/16"]
  location           		 	  = azurerm_resource_group.main.location
  resource_group_name 			  = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {						# Create Subnet
  name                 			  = "internal"
  resource_group_name  			  = azurerm_resource_group.main.name
  virtual_network_name 			  = azurerm_virtual_network.main.name
  address_prefixes     			  = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {				# Create Network Interface
  name                			  = "${var.prefix}-nic"
  resource_group_name 			  = azurerm_resource_group.main.name
  location            			  = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_public_ip" "main" {						# Create Public IP Address
  name                            = "${var.prefix}-public-ip"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  allocation_method               = "Dynamic"
  idle_timeout_in_minutes         = 30
}

resource "azurerm_windows_virtual_machine" "main" {			# Create Virtual Machine
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  patch_mode                 	  = "Manual"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  computer_name                   = "hostname01"
  enable_automatic_updates 		  = false
  provision_vm_agent         	  = true
  winrm_listener {										# Open Access to WinRM Protocol in VM
        protocol = "Http"
      }
  
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher 					  = "MicrosoftWindowsDesktop"
    offer     					  = "Windows-10"
    sku       					  = "20h1-pro-g2"
    version   					  = "latest"
  }

  os_disk {
    storage_account_type 		  = "Premium_LRS"
    caching              		  = "ReadWrite"
  }
  
}

resource "azurerm_network_security_group" "nsg" {			# Network Security Group
  name                            = "${var.prefix}-nsg"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location

  security_rule {											# Open Access to RDP Protocol for VM
    name                          = "RDP"
    priority                      = 100
    direction                     = "Inbound"
    access                        = "Allow"
    protocol                      = "Tcp"
    source_port_range             = 3389
    destination_port_range        = 3389
    source_address_prefix         = "*"
    destination_address_prefix    = "*"
  }
  
  security_rule {											# Open Access to WinRM Protocol for VM
    name                          = "WinRM"
    priority                      = 101
    direction                     = "Inbound"
    access                        = "Allow"
    protocol                      = "Tcp"
    source_port_range             = 5985
    destination_port_range        = 5985
    source_address_prefix         = "*"
    destination_address_prefix    = "*"
  }
}

output "virtual_machine_id" {								# Output Machine ID Information to Terminal
  value = azurerm_windows_virtual_machine.main.virtual_machine_id
}

output "public_ip" {										# Output Public IP Information to Terminal, use "public_ip_addresses" to get more then one
  value = azurerm_windows_virtual_machine.main.public_ip_address
}

# use "terraform output -raw public_ip" to output only the IP Terminal
## End of Terraform Script