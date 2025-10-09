# Data Infrastructure

Репозиторий для развертывания PostgreSQL, Kafka и MinIO через ArgoCD.

## Компоненты

- **PostgreSQL** - Реляционная БД
- **Kafka** - Message broker
- **MinIO** - S3-совместимое объектное хранилище

## Секреты

Все credentials хранятся в Vault и автоматически подставляются через ArgoCD Vault Plugin.

### Структура секретов в Vault:

```
secret/
├── databases/
│   └── postgres
│       ├── username
│       ├── password
│       └── database
├── kafka/
│   └── admin
│       ├── username
│       └── password
└── minio/
    └── root
        ├── username
        └── password
```

## Развертывание

```bash
kubectl apply -f argocd-app.yaml
```

ArgoCD автоматически развернет все компоненты с секретами из Vault.
