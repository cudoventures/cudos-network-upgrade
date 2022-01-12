#!/bin/bash -i
source ./vars.sh

if [ ! -d "$WORKING_DIR/CudosData/$DATA_FOLDER" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Data folder is missing - $WORKING_DIR/CudosData/$DATA_FOLDER does not exists";
    exit;
fi

if [ ! -d "$WORKING_DIR/CudosNode" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosNode older is missing - $WORKING_DIR/CudosNode does not exists";
    exit;
fi

if [ ! -d "$WORKING_DIR/CudosGravityBridge" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosGravityBridge folder is missing - $WORKING_DIR/CudosGravityBridge does not exists";
    exit;
fi

if [ ! -d "$WORKING_DIR/CudosBuilders" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosBuilders folder is missing - $WORKING_DIR/CudosBuilders does not exists";
    exit;
fi

# TO DO: Check for:
# - chain id
# - expected git hash for each project
# - check docker container name (it MUST be still running)
# - do not start the upgrade unless the chain is stopped
# - check for Errors while building the docker images
# - more or less, add validation to every step


echo -e "${GREEN_COLOR}OK:${NO_COLOR} Verification was successful";