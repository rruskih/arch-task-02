#!/bin/bash

# Вставка тестовых данных (через mongos router):
docker compose exec -T mongo-router mongosh --port 27020 <<EOF
use somedb
for(var i = 0; i < 50000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
