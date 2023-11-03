variable "resource_group" {
    type = string
    description = "Resource group for Brief12"
}

variable "location" {
    type = string
    description = "Location for Brief12"
}

variable "virtual_network" {
    type = string
    description = "Virtual network for Brief12"
}

variable "virtual_network_address_space" {
    description = "Address space for the Azure Virtual Network"
    type        = list(string)
}

variable "subnet_name" {
    description = "Name of the Azure Subnet for Brief12"
    type = string
}

variable "subnet_app_address_prefix" {
    description = "Address prefix for the Application Subnet"
    type        = list(string)
}

variable "nic_app_name" {
  description = "Name of the Azure Network Interface for Brief12"
  type        = string
}

variable "nsg_app_name" {
  description = "Name of the Azure Network Security Group for Brief12"
  type        = string
}

variable "public_ip_nat_name" {
  description = "Name of the Azure Public IP for NAT Gateway"
  type        = string
}

variable "nic_app_config" {
    description = "network_interface_config"
    type = string
}

variable "vm_name" {
  description = "name of the VM"
  type = string
}

variable "vm_size" {
  description = "size of the VM"
  type = string
}

variable "vm_username" {
  description = "username of the VM"
  type = string
}

variable "ssh_key" {
  description = "SSH key for the VM"
  type = string
}

variable "os_disk_caching" {
  description = "Caching like Read, Write, etc"
  type = string
}

variable "storage_account_type" {
  description = "Type of the storage account"
  type = string
}

variable "publisher_vm" {
  description = "publisher of the VM source image"
  type = string
}

variable "offer_vm" {
  description = "Offer for the VM source image"
  type = string
}

variable "sku_vm" {
  description = "SKU for the VM source image"
  type = string
}

variable "private_key" {
  description = "Private key for the VM"
  type = string
}