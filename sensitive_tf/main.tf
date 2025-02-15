variable "name" {
  type = string
  sensitive = true
  default = "John"
}

variable "phone" {
  type = string
  sensitive = true
  default = "123-456"
}

locals {
  contact_info = {
    name = var.name
    phone = var.phone
  }
  my_number = nonsensitive(var.phone)
}

output "name" {
  value = local.contact_info.name
  sensitive = true
}

output "phone_number" {
  value = local.contact_info.phone
  sensitive = true
}

output "my_number" {
  value = local.my_number
}