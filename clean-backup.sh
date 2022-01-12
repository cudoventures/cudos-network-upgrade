#!/bin/bash -i
source ./vars.sh

sudo rm -rf "$WORKING_DIR/CudosData/$DATA_FOLDER-backup"

sudo rm -rf "$WORKING_DIR/CudosNode-backup"

sudo rm -rf "$WORKING_DIR/CudosGravityBridge-backup"

sudo rm -rf "$WORKING_DIR/CudosBuilders-backup"

echo -e "${GREEN_COLOR}OK:${NO_COLOR} Cleanup completed";
