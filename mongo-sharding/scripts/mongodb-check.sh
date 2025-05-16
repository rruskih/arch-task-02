#!/bin/bash

docker compose exec -T mongo-router mongosh --quiet --port 27020 --eval 'sh.getBalancerState()'

docker compose exec -T mongo-shard01 mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


docker compose exec -T mongo-shard02 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF