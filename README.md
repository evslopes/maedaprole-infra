# Mae da Prole - Infraestrutura

Este repositório contém a configuração de infraestrutura para o projeto Mae da Prole. Ele centraliza a configuração do Docker Compose para os serviços backend, frontend e CMS.

## Estrutura do Repositório


```plaintext
projetos-mae-da-prole/
├── maedaprole-backend/     # Repositório do Spring Boot
│   ├── src/
│   ├── pom.xml
│   └── .github/
│       └── workflows/
│           └── ci.yml
├── maedaprole-frontend/    # Repositório do Vue.js
│   ├── src/
│   ├── package.json
│   └── .github/
│       └── workflows/
│           └── ci.yml
├── maedaprole-cms/         # Projeto Strapi v5
│   ├── config/
│   ├── public/
│   │   └── uploads/
│   ├── data/        
│   ├── package.json
│   └── .github/
│       └── workflows/
│           └── ci.yml
└── maedaprole-infra/       # Novo repositório para a  infraestrutura
    ├── docker-compose.yml  # docker-compose.yml *centralizado* aqui
    └── .github/
        └── workflows/
            └── ci.yml      

# Workflow do GitHub Actions para CI/CD

## Serviços

### Backend

- **Repositório**: [maedaprole-backend](https://github.com/evslopes/maedaprole-backend)
- **Tecnologia**: Spring Boot
- **Porta**: 8080

### Frontend

- **Repositório**: [maedaprole-frontend](https://github.com/evslopes/maedaprole-frontend)
- **Tecnologia**: Vue.js com Vite
- **Porta**: 3000

### CMS

- **Repositório**: [maedaprole-cms](https://github.com/evslopes/maedaprole-cms)
- **Tecnologia**: Strapi
- **Porta**: 1337

### Banco de Dados

- **Imagem**: postgres:14-alpine
- **Porta**: 5432

## Configuração do Docker Compose

O arquivo `docker-compose.yml` define a configuração dos serviços e suas dependências.

```yaml
services:
  backend:
    image: evslopes7/maedaprole-backend
    build:
      context: ../maedaprole-backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/mae_da_prole_dev
      - SPRING_DATASOURCE_USERNAME=jhhdev
      - SPRING_DATASOURCE_PASSWORD=dev_2025
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_MAIL_HOST=smtp.gmail.com
      - SPRING_MAIL_PORT=587
      - SPRING_MAIL_USERNAME=seu.email.teste@gmail.com
      - SPRING_MAIL_PASSWORD=sua-senha-de-app
      - spring.mail.properties.mail.smtp.auth=true
      - spring.mail.properties.mail.smtp.starttls.enable=true
    depends_on:
      - postgres
    networks:
      - maedaprole_network

  postgres:
    image: postgres:14-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: mae_da_prole_dev
      POSTGRES_USER: jhhdev
      POSTGRES_PASSWORD: dev_2025
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - maedaprole_network

  strapi:
    image: evslopes7/maedaprole-cms
    build:
      context: ../maedaprole-cms
      dockerfile: Dockerfile
    ports:
      - "1337:1337"
    environment:
      DATABASE_CLIENT: postgres
      DATABASE_HOST: postgres
      DATABASE_PORT: 5432
      DATABASE_NAME: mae_da_prole_dev
      DATABASE_USERNAME: jhhdev
      DATABASE_PASSWORD: dev_2025
      NODE_ENV: development
      HOST: 0.0.0.0
      APP_KEYS: "chaveSegura1,chaveSegura2,chaveSegura3,chaveSegura4"
      API_TOKEN_SALT: valorSeguroAleatorio
      ADMIN_JWT_SECRET: valorSeguroAleatorioJWT
      JWT_SECRET: valorSeguroAleatorioJWT
    volumes:
      - ./strapi:/srv/app
    depends_on:
      - postgres
    networks:
      - maedaprole_network

  frontend:
    image: evslopes7/maedaprole-frontend
    build:
      context: ../maedaprole-frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - ../maedaprole-frontend:/app
    depends_on:
      - backend
    networks:
      - maedaprole_network

volumes:
  postgres_data:
    name: "maedaprole_dbdata"

networks:
  maedaprole_network:
    name: "maedaprole_network"
````

### Conclusão

Com este `README.md`, qualquer desenvolvedor que clone o repositório `maedaprole-infra` terá uma visão clara de como configurar e executar a infraestrutura do projeto. Se precisar de mais alguma coisa ou tiver alguma dúvida específica, estou à disposição para ajudar!



