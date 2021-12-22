#!/bin/bash -i
source ./vars.sh

cd "$WORKING_DIR"

if [ -f "./CudosData/$DATA_FOLDER-backup" ]; then
    sudo rm -rf "./CudosData/$DATA_FOLDER";
    sudo mv "./CudosData/$DATA_FOLDER-backup" "./CudosData/$DATA_FOLDER";
fi

if [ -f "./CudosNode-backup" ]; then
    sudo rm -rf "./CudosNode";
    sudo mv ./CudosNode-backup ./CudosNode;
fi

if [ -f "./CudosGravityBridge-backup" ]; then
    sudo rm -rf "./CudosGravityBridge";
    sudo mv ./CudosGravityBridge-backup ./CudosGravityBridge;
fi

if [ -f "./CudosBuilders-backup" ]; then
    sudo rm -rf "./CudosBuilders";
    sudo mv ./CudosBuilders-backup ./CudosBuilders;
fi

