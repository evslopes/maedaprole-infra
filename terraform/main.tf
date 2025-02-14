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
  name   = "maedaprole-backend-app"  # NOME ÚNICO NO HEROKU!
  region = "us"
}

resource "heroku_addon" "backend_postgres" {
  app_id = heroku_app.backend.id
  plan   = "heroku-postgresql:hobby-dev"
}


# --- Strapi ---

resource "heroku_app" "strapi" {
  name   = "maedaprole-cms-app"  # NOME ÚNICO NO HEROKU!
  region = "us"
}

resource "heroku_addon" "strapi_postgres" {
  app_id = heroku_app.strapi.id
  plan   = "heroku-postgresql:hobby-dev"
}

# --- Variáveis de ambiente (Back-end) ---
resource "heroku_app_config_association" "backend_env" {
  app_id = heroku_app.backend.id  # Usar o ID do app
  vars = {
    SPRING_PROFILES_ACTIVE = "prod"
    # NÃO defina SPRING_DATASOURCE_URL aqui.  O Heroku o fará automaticamente.
    SPRING_MAIL_HOST     = var.email_host      # Usando variável
    SPRING_MAIL_PORT     = var.email_port          # Usando variável
    SPRING_MAIL_USERNAME = var.email_username    # Usando variável
    SPRING_MAIL_PASSWORD = var.email_password    # Usando variável
    # Outras variáveis do Spring Boot (se houver)...
  }
}

# --- Variáveis de ambiente (Strapi) ---
# Usando heroku_app_config_association, e passando as variáveis sensíveis
resource "heroku_app_config_association" "strapi_env" {
  app_id = heroku_app.strapi.id
  # O Heroku já define DATABASE_URL, então, não precisamos dela aqui.
  vars = {
    NODE_ENV       = "production" # Use "production" no Heroku
    HOST           = "0.0.0.0"
    APP_KEYS       = var.app_keys
    API_TOKEN_SALT = var.api_token_salt
    ADMIN_JWT_SECRET = var.admin_jwt_secret
    JWT_SECRET     = var.jwt_secret
  }
}

# --- Saídas (URLs dos aplicativos) ---
output "backend_app_url" {
  value = "https://${heroku_app.backend.name}.herokuapp.com"
}

output "strapi_app_url" {
  value = "https://${heroku_app.strapi.name}.herokuapp.com"
}
