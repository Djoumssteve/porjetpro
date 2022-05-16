variable "group_ressource_nom" {
    type = string
    description = "RG name in Azure"
}

variable "group_ressource_location" {
    type = string
    description = "RG location name in Azure"
}

variable "reseaux_virtual_nom" {
    type = string
    description = "Virtual network name in azure"
}

variable "sousreseaux_nom" {
    type = string
    description = "subnet name in Azure"
}

variable "interface_reseaux_nom" {
    type = string
    description = "network interface name in Azure"
}

variable "machine_virtuelle_name" {
    type = string
    description = "Virtual machine name in Azure"
}

variable "disque_management_name" {
    type = string
    description = "disk name in Azure"
}