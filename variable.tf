variable "prefix" {
  default = "DEMO"
}

resource "azurerm_virtual_network" "test" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.PROJET_MALO.location
  resource_group_name = azurerm_resource_group.PROJET_MALO.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.PROJET_MALO.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.PROJET_MALO.location
  resource_group_name = azurerm_resource_group.PROJET_MALO.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id = azurerm_public_ip.IP_public.id
  }
  
  depends_on = [
      azurerm_virtual_network.test,
	  azurerm_public_ip.IP_public
	 ]
}

resource "azurerm_virtual_machine" "DEMO" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.PROJET_MALO.location
  resource_group_name   = azurerm_resource_group.PROJET_MALO.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  os_profile {
    computer_name  = "test"
    admin_username = "Admin123"
    admin_password = "Malo@2022"
  }
  
  os_profile_windows_config {
    provision_vm_agent = true
  }
  
  tags = {
    owner = "Djoumessi Steve"
	
  }
}
   
resource "azurerm_public_ip" "IP_public" {
  name                = "IP_public"
  resource_group_name = azurerm_resource_group.PROJET_MALO.name
  location            = azurerm_resource_group.PROJET_MALO.location
  allocation_method   = "Static"

  tags = {
    environement = "public-ip"
  }
}