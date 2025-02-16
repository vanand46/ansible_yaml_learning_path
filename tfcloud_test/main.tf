terraform {
  cloud {
    organization = "demo_org_avg"

    workspaces {
      name = "demo_cloud_ws"
    }
  }
}

variable "my_string" {
  description = "My string input variable"
  type        = string
}


variable "listofstrings" {
  type    = list(string)
  default = ["my-string-1", "my-string-2", "my-string-3"]
}

variable "iplist" {
  type = map(string)
  default = {
    prod = "100.100.100.100",
    dev  = "200.200.200.200"
  }
}

variable "env" {
  type = map(any)
  default = {
    prod = {
      ip  = "100.100.100.100",
      loc = "us"
    },
    dev = {
      ip  = "200.200.200.200",
      loc = "in"
    }
  }
}

output "print_string_var" {
  value = var.my_string
}

output "print_full_list" {
  value = var.listofstrings
}

output "print_first_list_item" {
  value = var.listofstrings[0]
}

output "print_prod_ip" {
  value = var.iplist["prod"]
}

output "print_prod_env" {
  value = [var.env.prod.ip, var.env.prod.loc]
}

output "print_dev_env" {
  value = [var.env.dev.ip, var.env.dev.loc]
}
