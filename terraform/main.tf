terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}

provider "heroku" {}

# --- Back-end (Spring Boot) ---

resource "heroku_app" "backend" {
  name = "maedaprole-backend-app"  # SUBSTITUA por um nome ÚNICO no Heroku!
  region = "us"
}

resource "heroku_addon" "backend_postgres" {
  app_id = heroku_app.backend.id
  plan   = "heroku-postgresql:hobby-dev"
}

# --- Strapi ---

resource "heroku_app" "strapi" {
  name = "maedaprole-cms-app"  # SUBSTITUA por um nome ÚNICO no Heroku!
  region = "us"
}

resource "heroku_addon" "strapi_postgres" {
  app_id = heroku_app.strapi.id
  plan   = "heroku-postgresql:hobby-dev"
}


# --- Variáveis de ambiente (Back-end) ---
resource "heroku_app_config_association" "backend_env" {
  app_id = heroku_app.backend.id
  vars = {
    SPRING_PROFILES_ACTIVE = "prod"
    # O Spring Boot vai pegar a DATABASE_URL automaticamente.
    SPRING_MAIL_HOST     = var.email_host
    SPRING_MAIL_PORT     = var.email_port
    SPRING_MAIL_USERNAME = var.email_username
    SPRING_MAIL_PASSWORD = var.email_password
  }
}

# --- Variáveis de ambiente (Strapi) ---
resource "heroku_app_config_association" "strapi_env" {
  app_id = heroku_app.strapi.id
  # depends_on = [heroku_addon.strapi_postgres] # Não precisa, a dependência já está implícita
  vars = {
    NODE_ENV         = "production"
    DATABASE_URL     = heroku_addon.strapi_postgres.config_var_values["DATABASE_URL"]
    HOST             = "0.0.0.0"
    APP_KEYS = var.app_keys  # Usando variáveis
    API_TOKEN_SALT   = var.api_token_salt
    ADMIN_JWT_SECRET = var.admin_jwt_secret
    JWT_SECRET       = var.jwt_secret
  }
}


# --- Variáveis (Opcional, mas recomendado) ---
# Defina as variáveis em um arquivo variables.tf

# --- Saídas (Opcional) ---
output "backend_app_url" {
  value = "https://${heroku_app.backend.name}.herokuapp.com"
}

output "strapi_app_url" {
  value = "https://${heroku_app.strapi.name}.herokuapp.com"
}