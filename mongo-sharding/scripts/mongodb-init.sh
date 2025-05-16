#!/bin/bash

# Инициализация config replica set:
docker compose exec -T mongo-config-server mongosh --port 27019 <<EOF
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [{ _id: 0, host: "mongo-config-server:27019" }]
})
EOF

sleep 5

# Инициализация shard01 replica set:
docker compose exec -T mongo-shard01 mongosh --port 27017 <<EOF
rs.initiate({
  _id: "shardReplSet01",
  members: [{ _id: 0, host: "mongo-shard01:27017" }]
})
EOF

sleep 5

# Инициализация shard02 replica set:
docker compose exec -T mongo-shard02 mongosh --port 27018 <<EOF
rs.initiate({
  _id: "shardReplSet02",
  members: [{ _id: 0, host: "mongo-shard02:27018" }]
})
EOF

sleep 5

# Подключение шардов к mongos:
docker compose exec -T mongo-router mongosh --port 27020 <<EOF
sh.addShard("shardReplSet01/mongo-shard01:27017")
sh.addShard("shardReplSet02/mongo-shard02:27018")
EOF

sleep 5

# Создание хешированного индекса по полю _id
docker compose exec -T mongo-router mongosh --port 27020 <<EOF
use somedb
db.getSiblingDB("somedb").helloDoc.createIndex({ "_id": "hashed" });
EOF

sleep 5

# Включение шардирования коллекции helloDoc с использованием хешированного ключа
docker compose exec -T mongo-router mongosh --port 27020 <<EOF
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", {"_id": "hashed"})
EOF

docker-compose restart mongo-router

# Вставка тестовых данных (через mongos router):
docker compose exec -T mongo-router mongosh --port 27020 <<EOF
use somedb
for(var i = 0; i < 50000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
