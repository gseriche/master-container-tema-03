#! /usr/bin/env bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

echo $(printf "${GREEN}Eliminar Red${ENDCOLOR}")
docker network rm master-net
echo $(printf "${GREEN}Eliminar backend${ENDCOLOR}")
docker rm backend
echo $(printf "${GREEN}Eliminar frontend${ENDCOLOR}")
docker rm frontend
echo $(printf "${GREEN}Eliminar MongoDB${ENDCOLOR}")
docker rm mongodb-test-v2
echo $(printf "${GREEN}Eliminar Directorio${ENDCOLOR}")
rm -rf ./database-data
