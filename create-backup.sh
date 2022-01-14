#!/bin/bash -i
source ./vars.sh

if [ ! -d "$WORKING_DIR/CudosData/$DATA_FOLDER" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosData/$DATA_FOLDER does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosNode" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosNode does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosGravityBridge" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosGravityBridge does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosBuilders" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosBuilders does not exists";
    exit 1;
fi

sudo rm -rf "$WORKING_DIR/CudosData/$DATA_FOLDER-backup"
sudo rm -rf "$WORKING_DIR/CudosNode-backup"
sudo rm -rf "$WORKING_DIR/CudosGravityBridge-backup"
sudo rm -rf "$WORKING_DIR/CudosBuilders-backup"

sudo cp -r "$WORKING_DIR/CudosData/$DATA_FOLDER" "$WORKING_DIR/CudosData/$DATA_FOLDER-backup"
sudo cp -r "$WORKING_DIR/CudosNode" "$WORKING_DIR/CudosNode-backup"
sudo cp -r "$WORKING_DIR/CudosGravityBridge" "$WORKING_DIR/CudosGravityBridge-backup"
sudo cp -r "$WORKING_DIR/CudosBuilders" "$WORKING_DIR/CudosBuilders-backup"

echo -e "${GREEN_COLOR}OK:${NO_COLOR} The backup is ready";
