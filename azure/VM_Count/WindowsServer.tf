############################################################################################################
## Terraform Script to setup windows 10 20h1 with public IP on Azure and run command, Source: https://github.com/jmassardo/Azure-WinRM-Terraform
# Terraform Environment Setup, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan" to guarantee actions is change mid plan
# Terraform Run Script, "terraform apply terraform_plan_Backup.tfplan" Or Use "terraform apply terraform_plan_Backup.tfplan -auto-approve" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote
############################################################################################################

# Create a Public IP address for the Virtual Machine #
resource "azurerm_public_ip" "win_pubip" {
  count               = var.azure_vm_count
  name                = "win_pubip${count.index}"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

}

# Create the Network Interface and put it on the Proper Vlan/Subnet #
resource "azurerm_network_interface" "win_ip" {
  count               = var.azure_vm_count
  name                = "win_ip${count.index}"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "win_ipconf"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    #private_ip_address              = "var.azure_ip_addresses_Static${count.index}"  [element(azurerm_network_interface.win_ip.*.id, count.index)]
    public_ip_address_id = "azurerm_public_ip.win_pubip${count.index}" # demo azurerm_public_ip.main.id
  }
}

# Create the Actual VM #
resource "azurerm_virtual_machine" "win" {
  count                 = var.azure_vm_count
  name                  = "var.server_name${count.index}"
  location              = var.azure_region
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.win_ip.*.id, count.index)]
  vm_size               = var.vm_size


  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk_${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS" # Premium_LRS for High Performance
  }

  os_profile {
    computer_name  = var.server_name
    admin_username = var.username
    admin_password = var.password
    custom_data    = file("./files/winrm.ps1")
  }

  os_profile_windows_config {
    provision_vm_agent = true
    winrm {
      protocol = "http"
    }

    additional_unattend_config { # Auto-Login's Required to Configure WinRM
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.username}</Username></AutoLogon>"
    }

    additional_unattend_config { # Unattended Config is to Enable Basic Auth in WinRM, Required for the Provisioner stage.
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file("./files/FirstLogonCommands.xml")
    }
  }
}

# Write Output Information to Terminal #
output "virtual_machine_id" {
  value       = azurerm_virtual_machine.win.*.id
  description = "Output Machine ID Information to Terminal"
}

output "public_fqdn" {
  value       = azurerm_public_ip.win_pubip.*.fqdn
  description = "Output -Fully Qualified Domain Name- Information to Terminal"
}

output "public_ip" {
  value       = azurerm_public_ip.win_pubip.*.ip_address
  description = "Output Public IP Information to Terminal, use -public_ip_addresses- to get more then one"
}

############################################################################################################
# use "terraform output -raw public_ip" to output the IP to Terminal
## End of Terraform Script
############################################################################################################
