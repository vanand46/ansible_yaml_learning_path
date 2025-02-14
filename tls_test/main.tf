terraform {
    required_version = ">= 1.0.0"
    required_providers {
        http = {
            source = "hashicorp/http"
            version = "2.1.0"
        }
        random = {
            source = "hashicorp/random"
            version = "3.6.3"
        }
        local = {
            source = "hashicorp/local"
            version = "2.5.2"
        }
        tls = {
            source = "hashicorp/tls"
            version = "4.0.6"
        }
    }
}

resource "tls_private_key" "generated" {
    algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
    content = tls_private_key.generated.private_key_pem
    filename = "MyAWSKey.pem"
}