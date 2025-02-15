variable "backend_app_name" {
  type        = string
  description = "Nome do aplicativo Heroku para o back-end (Spring Boot)"
  default = "maedaprole-backend" #  <-- Coloque um nome padrão, se quiser
}

variable "strapi_app_name" {
  type        = string
  description = "Nome do aplicativo Heroku para o Strapi"
  default = "maedaprole-cms" # <-- Coloque um nome padrão
}

variable "email_username" {
  type        = string
  description = "Nome de usuário para o serviço de e-mail (ex: Gmail)"
  sensitive   = true  # SEMPRE marque informações sensíveis como sensitive!
}

variable "email_password" {
  type        = string
  description = "Senha/token para o serviço de e-mail"
  sensitive   = true
}
variable "email_host" {
  type = string
  default = "smtp.gmail.com"

}
variable "email_port" {
  type = string
  default = "587"
}

variable "app_keys" {
  type = string
  sensitive = true
}

variable "api_token_salt"{
  type = string
  sensitive = true
}

variable "admin_jwt_secret"{
  type = string
  sensitive = true
}

variable "jwt_secret"{
  type = string
  sensitive = true
}