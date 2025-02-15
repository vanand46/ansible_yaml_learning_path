# Validation for cloud provider choice
variable "cloud" {
  type        = string
  description = "Enter the cloud provider name (aws, azure, gcp, vmware)"

  validation {
    condition     = contains(["aws", "azure", "gcp", "vmware"], lower(var.cloud))
    error_message = "Only aws, azure, gcp, and vmware are accepted as cloud providers."
  }

  validation {
    condition     = lower(var.cloud) == var.cloud
    error_message = "The cloud provider name must be in lowercase."
  }
}

# Variable for no capital letters
variable "no_caps" {
  type        = string
  description = "Enter a lowercase string."

  validation {
    condition     = lower(var.no_caps) == var.no_caps
    error_message = "The string must be in lowercase."
  }
}

# Variable with character limit
variable "character_limit" {
  type        = string
  description = "Enter a string of exactly 3 characters."

  validation {
    condition     = length(var.character_limit) == 3
    error_message = "This variable must contain exactly 3 characters."
  }
}

# IP address validation
variable "ip_address" {
  type        = string
  description = "Enter a valid IP address."

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address))
    error_message = "The input must be a valid IP address in the form X.X.X.X."
  }
}

# Sensitive data variable
variable "phone_number" {
  type        = string
  description = "Enter a sensitive phone number."
  sensitive   = true
}

# List data variable
variable "my_az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
}

# Map data variable
variable "my_ips" {
  type = map(string)
  default = {
    prod = "10.0.150.0/24",
    dev  = "10.0.250.0/24"
  }
}

# List of servers
variable "servers" {
  description = "A list of server names"
  type        = list(string)
  default     = ["server1", "server2", "server3"]
}
