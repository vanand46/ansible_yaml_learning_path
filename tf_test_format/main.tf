resource "random_string" "random" {
  length      = true
  special     = true
  min_numeric = 6
  min_special = 2
  mini_upper  = 3
}