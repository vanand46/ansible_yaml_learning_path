# Managing sensitive information with locals 
locals {
  contact_info = {
    cloud        = var.cloud
    department   = var.no_caps
    cost_code    = var.character_limit
    phone_number = var.phone_number
  }
}

output "cloud" {
  value = local.contact_info.cloud
}

output "department" {
  value = local.contact_info.department
}

output "cost_code" {
  value = local.contact_info.cost_code
}

output "phone_number" {
  description = "A sensitive output of the phone number"
  value       = local.contact_info.phone_number
  sensitive   = true
}

output "my_az_list_item" {
  description = "Getting the first az item"
  value       = var.my_az_list[0]
}

output "get_my_ips" {
  description = "Getting the ip item based on key"
  value       = var.my_ips["prod"]
}

# Iteration using foreach
resource "null_resource" "foreach_example" {
  for_each = toset(var.servers)

  provisioner "local-exec" {
    command = "echo ${each.value} is being provisioned"
  }
}

output "server_names" {
  value = [for server in null_resource.foreach_example : server.id]
}


# Iteration using count
resource "null_resource" "count_example" {
  count = length(var.servers)

  provisioner "local-exec" {
    command = "echo ${var.servers[count.index]} is being provisioned"
  }
}

output "server_names_count" {
  value = [for i in range(length(var.servers)) : null_resource.count_example[i].id]
}
