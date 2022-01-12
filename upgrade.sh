#!/bin/bash -i
source ./vars.sh

if [ -d "$WORKING_DIR/CudosData/$DATA_FOLDER-backup" ]; then
    echo 'ERROR: Cannot upgrade because $WORKING_DIR/CudosData/$DATA_FOLDER-backup exists'
    exit
fi

if [ -d "$WORKING_DIR/CudosNode-backup" ]; then
    echo 'ERROR: Cannot upgrade because $WORKING_DIR/CudosData/CudosNode-backup exists'
    exit
fi

if [ -d "$WORKING_DIR/CudosGravityBridge-backup" ]; then
    echo 'ERROR: Cannot upgrade because $WORKING_DIR/CudosData/CudosGravityBridge-backup exists'
    exit
fi

if [ -d "$WORKING_DIR/CudosBuilders-backup" ]; then
    echo 'ERROR: Cannot upgrade because $WORKING_DIR/CudosData/CudosBuilders-backup exists'
    exit
fi

echo $WORKING_DIR
echo $NODE_NAME
echo $START_CONTAINER_NAME
echo $DATA_FOLDER
echo $CHAIN_ID

alias START_NODE
alias COPY_ENV

./src/export.sh $1 $2 $3
sudo docker system prune -a -f
sudo docker image prune -a -f
./src/migrate.sh $1 $2 $3