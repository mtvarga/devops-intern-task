resource "azurerm_resource_group" "rg" {
    name = "devops-terraform-intern-task"
    location = "westeurope"
}

resource "azurerm_virtual_network" "tfvm_vnet" {
    name = "tfvm_vnet"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "tfvm_subnet" {
    name = "tfvm_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.tfvm_vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "tfvm_public_ip" {
    name = "tfvm_public_ip"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "tfvm_nic" {
    name = "tfvm_nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "tfvm_default_ip_config"
        subnet_id = azurerm_subnet.tfvm_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.tfvm_public_ip.id
    }
}

resource "azurerm_linux_virtual_machine" "tfvm" {
    name = "tfvm"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.tfvm_nic.id]
    size = "Standard_B1s"
    admin_username = "azure_admin"
    admin_password = "VerySecureAdminPassword1234"
    disable_password_authentication = false
    computer_name = "tfvm"

    os_disk {
        name = "tfvm_os_disk"
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