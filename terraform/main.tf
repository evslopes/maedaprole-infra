terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0" # Use uma versão compatível, >= 5.0.0
    }
  }
}

provider "heroku" {
  # A autenticação é feita via variável de ambiente HEROKU_API_KEY
}

# --- Back-end (Spring Boot) ---

resource "heroku_app" "backend" {
  name   = var.backend_app_name  # Usando variável!
  region = "us"                # Ou "eu"
}

resource "heroku_addon" "backend_postgres" {
  app_id = heroku_app.backend.id
  plan   = "heroku-postgresql:hobby-dev"
}

# --- Strapi ---

resource "heroku_app" "strapi" {
  name   = var.strapi_app_name  # Usando variável!
  region = "us"
}

resource "heroku_addon" "strapi_postgres" {
  app_id = heroku_app.strapi.id
  plan   = "heroku-postgresql:hobby-dev"
}


# --- Variáveis de ambiente (Back-end) ---
# Usando heroku_app_config_association para definir as variáveis no Heroku.
resource "heroku_app_config_association" "backend_env" {
  app_id = heroku_app.backend.id # Referencia o ID do app
  vars = {
    SPRING_PROFILES_ACTIVE = "prod"
    SPRING_MAIL_HOST     = var.email_host
    SPRING_MAIL_PORT     = var.email_port
    SPRING_MAIL_USERNAME = var.email_username
    SPRING_MAIL_PASSWORD = var.email_password
    # Outras variáveis do Spring Boot...
  }
}

# --- Variáveis de Ambiente (Strapi) ---
resource "heroku_app_config_association" "strapi_env" {
  app_id = heroku_app.strapi.id
  vars   = {
    NODE_ENV       = "production" # Agora em produção
    DATABASE_URL   = "postgres://${heroku_addon.strapi_postgres.config_vars.user}:${heroku_addon.strapi_postgres.config_vars.password}@${heroku_addon.strapi_postgres.config_vars.host}:${heroku_addon.strapi_postgres.config_vars.port}/${heroku_addon.strapi_postgres.config_vars.name}"
    APP_KEYS       = var.app_keys
    API_TOKEN_SALT = var.api_token_salt
    ADMIN_JWT_SECRET = var.admin_jwt_secret
    JWT_SECRET     = var.jwt_secret
    HOST           = "0.0.0.0"  # Necessário para o Strapi rodar no Heroku

  }
}

# --- Saídas (URLs dos aplicativos) ---

output "backend_app_url" {
  value = "https://${heroku_app.backend.name}.herokuapp.com"
}

output "strapi_app_url" {
  value = "https://${heroku_app.strapi.name}.herokuapp.com"
}