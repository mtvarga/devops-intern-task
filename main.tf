resource "azurerm_resource_group" "rg" {
    name = "devops-terraform-intern-task"
    location = "westeurope"
}

resource "azurerm_virtual_network" "tfvnet" {
    name = "virtual_network"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "tfsubnet" {
    name = "subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.tfvnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "tfpublicip" {
    name = "public_ip"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "tfnic" {
    name = "nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "default_ip_config"
        subnet_id = azurerm_subnet.tfsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.tfpublicip.id
    }
}

resource "azurerm_linux_virtual_machine" "tfvm" {
    name = "terraform_vm"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.tfnic.id]
    size = "Standard_B1s"
    admin_username = "adminuser"
    admin_password = "VerySecureAdminPassword1234"
    disable_password_authentication = false
    computer_name = "tfvm"

    os_disk {
        name = "os_disk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}