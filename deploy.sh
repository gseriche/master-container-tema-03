#! /usr/bin/env bash

DB_HOST=mongodb-test-v2
DB_USER=root
DB_PASSWORD=123456
DB_NAME=gseriche_db
DB_PORT=27017

NODE_DOCKER_PORT=8080
NODE_ENV=production


RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"


echo $(printf "${GREEN}Login a Harbor${ENDCOLOR}")
docker login https://harbor.tallerdevops.com/ -u tallerdevops2022 -p TallerDevops$0

echo $(printf "${GREEN}Crear carpeta de datos MongoDB${ENDCOLOR}")
mkdir ./database-data

echo $(printf "${GREEN}Pull Imagenes bases${ENDCOLOR}")
docker pull mhart/alpine-node:16
docker pull node:16-alpine3.16

echo $(printf "${GREEN}Pull MongoDB y Push a Harbor${ENDCOLOR}")
docker pull mongo:6.0.2
docker tag mongo:6.0.2 harbor.tallerdevops.com/gonzalo-seriche-vega/mongo:6.0.2
docker push harbor.tallerdevops.com/gonzalo-seriche-vega/mongo:6.0.2

echo $(printf "${GREEN}Crear Red${ENDCOLOR}")
docker network create master-net

echo $(printf "${GREEN}Construir backend y push a Harbor ${ENDCOLOR}")
docker build -t backend:20221019 -f backend.Dockerfile backend/.
docker tag backend:20221019 harbor.tallerdevops.com/gonzalo-seriche-vega/backend:20221019
docker push harbor.tallerdevops.com/gonzalo-seriche-vega/backend:20221019

echo $(printf "${GREEN}Crear frontendy push a Harbor ${ENDCOLOR}")
docker build -t frontend:20221019 -f frontend.Dockerfile frontend/react-crud/.
docker tag frontend:20221019 harbor.tallerdevops.com/gonzalo-seriche-vega/frontend:20221019
docker push harbor.tallerdevops.com/gonzalo-seriche-vega/frontend:20221019

echo $(printf "${GREEN}Ejecutar MongoDB${ENDCOLOR}")
docker run -d --net master-net \
    -e MONGO_INITDB_ROOT_USERNAME=$DB_USER \
    -e MONGO_INITDB_ROOT_PASSWORD=$DB_PASSWORD \
    -v ./database-data:/data/db \
    --name $DB_HOST \
    -p 27017:27017 \
    -m "300M" --memory-swap "1G" \
    harbor.tallerdevops.com/gonzalo-seriche-vega/mongo:6.0.2

echo $(printf "${GREEN}Ejecutar Backend${ENDCOLOR}")
docker run -d --net master-net \
    -p 8080:8080 \
    -m "300M" --memory-swap "1G" \
    -e NODE_ENV=$NODE_ENV \
    -e DB_HOST=$DB_HOST \
    -e DB_USER=$DB_USER \
    -e DB_PASSWORD=$DB_PASSWORD \
    -e DB_NAME=$DB_NAME \
    -e DB_PORT=$DB_PORT \
    -e NODE_DOCKER_PORT=$NODE_DOCKER_PORT \
    --name backend \
    harbor.tallerdevops.com/gonzalo-seriche-vega/backend:20221019

echo $(printf "${GREEN}Ejecutar Frontend${ENDCOLOR}")
docker run -d --net master-net \
    -p 8081:8081 \
    -m "300M" --memory-swap "1G" \
    -e NODE_ENV=$NODE_ENV \
    --name frontend \
    harbor.tallerdevops.com/gonzalo-seriche-vega/frontend:20221019