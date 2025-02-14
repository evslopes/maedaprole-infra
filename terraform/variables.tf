variable "email_username" {
  type = string
  sensitive = true # SEMPRE marque variáveis sensíveis como 'sensitive'
}

variable "email_password" {
  type = string
  sensitive = true
}
variable "email_host"{
  type = string
  default = "smtp.gmail.com"
}
variable "email_port"{
  type = string
  default = "587"
}
variable "app_keys" {
  type = string
  sensitive = true
}

variable "api_token_salt" {
  type = string
  sensitive = true
}

variable "jwt_secret" {
  type = string
  sensitive = true
}

variable "admin_jwt_secret"{
  type = string
  sensitive = true
}