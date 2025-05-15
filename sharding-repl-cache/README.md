# pymongo-api

## Как запустить

Запускаем кластер mongodb и приложение

```shell
docker-compose up -d
```

Инициализируем кластер mongodb

```shell
./scripts/sharding-repl-cache-init.sh
```

Заполняем mongodb данными

```shell
./scripts/mongodb-init.sh
```

## Как проверить

### Если хотите проверить статус балансировщика и распределение данных

Запустите скрипт

```shell
./scripts/sharding-repl-cache-check.sh
```

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs