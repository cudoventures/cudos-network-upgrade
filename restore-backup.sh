#!/bin/bash -i
source ./vars.sh

if [ ! -d "$WORKING_DIR/CudosData/$DATA_FOLDER-backup" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosData/$DATA_FOLDER-backup does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosNode-backup" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosNode-backup does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosGravityBridge-backup" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosGravityBridge-backup does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosBuilders-backup" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Folder $WORKING_DIR/CudosBuilders-backup does not exists";
    exit 1;
fi

sudo rm -rf "$WORKING_DIR/CudosData/$DATA_FOLDER"
sudo rm -rf "$WORKING_DIR/CudosNode"
sudo rm -rf "$WORKING_DIR/CudosGravityBridge"
sudo rm -rf "$WORKING_DIR/CudosBuilders"

sudo cp -r "$WORKING_DIR/CudosData/$DATA_FOLDER-backup" "$WORKING_DIR/CudosData/$DATA_FOLDER"
sudo cp -r "$WORKING_DIR/CudosNode-backup" "$WORKING_DIR/CudosNode"
sudo cp -r "$WORKING_DIR/CudosGravityBridge-backup" "$WORKING_DIR/CudosGravityBridge"
sudo cp -r "$WORKING_DIR/CudosBuilders-backup" "$WORKING_DIR/CudosBuilders"

echo -e "${GREEN_COLOR}OK:${NO_COLOR} The backup is restored. The backup itself is not deleted, to do so, please run the clean-backup.sh";