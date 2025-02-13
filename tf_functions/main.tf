variable "greeting" {
  default = "Hello"
}

variable "list_example" {
  default = ["one", "two", "three"]
}

variable "name" {
  default = "World"
}

variable "map_example" {
  default = {
    key1 = "Value1"
    key2 = "Value2"
  }
}

output "greet_message" {
  value = "${var.greeting}, ${upper(var.name)}"
}

output "first_list_item" {
  value = element(var.list_example, 0)
}

output "map_value" {
  value = lookup(var.map_example, "key1")
}

output "base64_encode" {
  value = base64encode(var.name)
}
