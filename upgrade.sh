#!/bin/bash -i
source ./vars.sh

echo $WORKING_DIR
echo $NODE_NAME
echo $START_CONTAINER_NAME
echo $DATA_FOLDER
echo $CHAIN_ID

alias START_NODE
alias COPY_ENV

./src/export.sh $1 $2 $3
./src/migrate.sh $1 $2 $3