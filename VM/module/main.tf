resource "azurerm_resource_group" "rg" {
  name      = var.resource_group
  location  = var.location
}

resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.virtual_network_address_space
}

resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = var.subnet_app_address_prefix
}

resource "azurerm_network_interface" "nic_app" {
  name                = var.nic_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.nic_app_config
    subnet_id                     = azurerm_subnet.subnet_app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip_nat.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.nic_app.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = file(var.ssh_key)
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher_vm
    offer     = var.offer_vm
    sku       = var.sku_vm
    version   = "latest"
  }

#   provisioner "local-exec" {
#     command = "ansible-playbook playbook.yaml -i azure_rm.yaml"
#     working_dir = "/mnt/c/Users/utilisateur/Documents/Brief13/"
#   }
}

resource "azurerm_network_security_group" "nsg_app" {
  name                = var.nsg_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "assoc-nic-nsg-app" {
  network_interface_id      = azurerm_network_interface.nic_app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

resource "azurerm_public_ip" "public_ip_nat" {
  name                = var.public_ip_nat_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
