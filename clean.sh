#!/bin/bash -i
source ./vars.sh

cd "$WORKING_DIR"

sudo rm -rf "./CudosData/$DATA_FOLDER-backup"

sudo rm -rf ./CudosNode-backup

sudo rm -rf ./CudosGravityBridge-backup

sudo rm -rf ./CudosBuilders-backup

