module "network" {
  source = "./module"

  resource_group                = var.resource_group
  location                      = var.location
  virtual_network               = var.virtual_network
  virtual_network_address_space = var.virtual_network_address_space
  subnet_name                   = var.subnet_name
  subnet_app_address_prefix     = var.subnet_app_address_prefix
  nic_app_name                  = var.nic_app_name
  nsg_app_name                  = var.nsg_app_name
  public_ip_nat_name            = var.public_ip_nat_name
  nic_app_config                = var.nic_app_config
  vm_name                       = var.vm_name
  vm_size                       = var.vm_size
  vm_username                   = var.vm_username
  ssh_key                       = var.ssh_key
  os_disk_caching               = var.os_disk_caching
  storage_account_type          = var.storage_account_type
  publisher_vm                  = var.publisher_vm
  offer_vm                      = var.offer_vm
  sku_vm                        = var.sku_vm
  private_key                   = var.private_key
}
