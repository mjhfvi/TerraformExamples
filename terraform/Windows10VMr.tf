############################################################################################################
## Terraform Script to setup windows 10 with public IP on Azure and run powhershell command, Source: https://github.com/jmassardo/Azure-WinRM-Terraform
# Terraform  initialize the Environment, "terraform init"
# Terraform Check Script Before Run, "terraform plan" or Use "terraform plan -out terraform_plan_Backup.tfplan"
# Terraform Run Script, "terraform apply" Or Use "terraform apply terraform_plan_Backup.tfplan" Without Approval Promote for Automation
# Terraform Destroy Environment, "terraform destroy" Or Use "terraform destroy -auto-approve" Without Approval Promote for Automation
############################################################################################################

# Build a Random String for 'domain_name_label' #
resource "random_string" "suffix" {
  length  = 4
  lower   = true
  upper   = false
  number  = false
  special = false
}

# Create a Public IP address for the Virtual Machine #
resource "azurerm_public_ip" "win_pubip" {
  name                              = "win_pubip"
  location                          = var.azure_region
  resource_group_name               = azurerm_resource_group.rg.name
  allocation_method                 = "Dynamic"
  domain_name_label                 = "example-${random_string.suffix.result}"      # URL for PowerShell Remote Access 
}

# Create the Network Interface and put it on the Proper Vlan/Subnet #
resource "azurerm_network_interface" "win_ip" {
  name                              = "win_ip"
  location                          = var.azure_region
  resource_group_name               = azurerm_resource_group.rg.name

  ip_configuration {
    name                            = "win_ipconf"
    subnet_id                       = azurerm_subnet.subnet.id
    private_ip_address_allocation   = "static"
    private_ip_address              = "10.1.1.10"
    public_ip_address_id            = azurerm_public_ip.win_pubip.id
  }
}

# Create the Actual VM #
resource "azurerm_virtual_machine" "win" {
  name                              = var.server_name
  location                          = var.azure_region
  resource_group_name               = azurerm_resource_group.rg.name
  network_interface_ids             = [azurerm_network_interface.win_ip.id]
  vm_size                           = var.vm_size

  storage_image_reference {
    publisher                       = "MicrosoftWindowsDesktop"
    offer                           = "Windows-10"
    sku                             = "20h1-pro-g2"
    version                         = "latest"
  }

  storage_os_disk {
    name                            = "osdisk"
    caching                         = "ReadWrite"
    create_option                   = "FromImage"
    managed_disk_type               = "Standard_LRS"
  }

  os_profile {
    computer_name                   = var.server_name
    admin_username                  = var.username
    admin_password                  = var.password
    custom_data                     = file("./files/winrmremotesetup.ps1")          # WinRM Setup in VM Script
  }

  os_profile_windows_config {
    provision_vm_agent              = true
    winrm {
      protocol                      = "http"
    }
    # Auto-Login's required to configure WinRM #
    additional_unattend_config {
      pass                          = "oobeSystem"
      component                     = "Microsoft-Windows-Shell-Setup"
      setting_name                  = "AutoLogon"
      content                       = "<AutoLogon><Password><Value>${var.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage. #
    additional_unattend_config {
      pass                          = "oobeSystem"
      component                     = "Microsoft-Windows-Shell-Setup"
      setting_name                  = "FirstLogonCommands"
      content                       = file("./files/FirstLogonCommands.xml")
    }
  }

  connection {
    host                            = azurerm_public_ip.win_pubip.fqdn
    type                            = "winrm"
    port                            = 5985
    https                           = false
    timeout                         = "4m"                                          # Run WinRM Commands TimeOut
    user                            = var.username
    password                        = var.password
  }

# Copies the files folder to c:/terraform/ #
  provisioner "file" {
    source                          = "files/"
    destination                     = "c:/terraform/"
  }

# Copies the files folder to c:/BuildSetup/ #
  provisioner "file" {
    source                          = "BuildSetup/"
    destination                     = "c:/BuildSetup/"
  }
  
# Script to Run Remote Commands in VM #  
  provisioner "remote-exec" {
    inline = [
      "PowerShell.exe -ExecutionPolicy Bypass c:\\terraform\\config.ps1"
      ]
  }

# Script to Run Local Commands in Your PC #    
  provisioner "local-exec" {
    command                         = "echo ${azurerm_public_ip.win_pubip.fqdn} >> private_ips.txt"
  }
}

## Output Information to Terminal ##
output "Virtual_Machine_ID" {								
  value                             = azurerm_virtual_machine.win.id
  description                       = "Output Machine ID Information to Terminal"
}

#output "Public_IP_Address" {
#  value                            = azurerm_public_ip.win_pubip.ip_address
#  description                      = "Output Public IP Information to Terminal, use -public_ip_addresses- to get more then one"
#}

output "Public_fqdn_Address" {
  value                             = azurerm_public_ip.win_pubip.fqdn
  description                       = "Output -Fully Qualified Domain Name- Information to Terminal"
}

############################################################################################################
# use "terraform show" to see the Configuration after apply
# use "terraform output -raw public_ip" to output the IP to Terminal
## End of Terraform Script
############################################################################################################