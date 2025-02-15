resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "my-aws-DEV-key.pem"
}

resource "random_string" "random" {
  length      = 15
  special     = true
  min_numeric = 6
  min_special = 2
  min_upper   = 3
}

# Output block to print the random value
output "random_output" {
  value = random_string.random.result
}
