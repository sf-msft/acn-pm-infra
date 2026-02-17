variable "aks_name" {
    type = string
    description = "The name of the AKS cluster"
    default = "overlay-tf-test"
}
variable "resource_group_name_aks" {
    type = string
    description = "The name of the resource group in which the resources will be created"
    default = "acn-pm"
}

variable "plugin" {
    type = string
    description = "The plugin to be used for the AKS cluster"
    default = "azure"
}

variable "servicecidr" {
    type = string
    description = "The service CIDR"
    default = "10.0.0.0/16"
}

variable "nodepoolname"{
    type = string
    description = "The name of the node pool"
    default = "nodepool1"
}

variable "nodepoolsize"{
    type = string
    description = "The VM size of the node pool"
    default = "Standard_D2s_v3"
}

variable "osdisksize"{
    type = number
    description = "The OS Disk size"
    default = 128
}

variable "dnsserviceip" {
    type = string
    description = "The DNS service IP"
    default = "10.0.0.10"
}

variable "loadbalancersku" {
    type = string
    description = "The SKU of the Load Balancer"
    default = "standard"
}

variable "networkpolicy" {
    type = string
    description = "The network policy"
    default = "azure"
}

variable "pluginmode" {
    type = string
    description = "The network plugin mode"
    default = "overlay"
}

variable "podcidr" {
    type = string
    description = "The pod CIDR"
    default = "100.125.0.0/16"
}

variable "disktype" {
    type = string
    description = "The disk type"
    default = "Managed"
}

variable "vmsstype" {
    type = string
    description = "The AKS VMSS type"
    default = "VirtualMachineScaleSets" 
}

variable "zone" {
    type = list(number)
    description = "The availability zones" 
    default = [2, 3]
}

variable "aks_subnet_name" {
    type = string
    description = "The name of the subnet"
    default = "subnet1"
  
}
variable "aks_vnet_name" {
    type = string
    description = "The name of the virtual network"
    default = "vnet1"
  
}