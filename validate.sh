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

if [ "$(sudo docker container inspect -f '{{.State.Status}}' $START_CONTAINER_NAME)" != "running" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} The container $START_CONTAINER_NAME is not running";
    exit;
fi

if ! grep -q "\"chain_id\": \"$CHAIN_ID\"" "$WORKING_DIR/CudosData/$DATA_FOLDER/config/genesis.json"; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Chain id mismatch. Expected $CHAIN_ID.";
    exit;
fi

expectedBranch="cudos-testnet-public"

cd "$WORKING_DIR/CudosBuilders"
cudosBuildersBranch=$(git branch --show-current)
if [ $cudosBuildersBranch != $expectedBranch ]; then 
    echo -e "${RED_COLOR}Error:${NO_COLOR} Branch mismatch for CudosBuilders. Expected '$expectedBranch', got '$cudosBuildersBranch'";
    exit;
fi

cd "$WORKING_DIR/CudosNode"
cudosBuildersBranch=$(git branch --show-current)
if [ $cudosBuildersBranch != $expectedBranch ]; then 
    echo -e "${RED_COLOR}Error:${NO_COLOR} Branch mismatch for CudosBuilders. Expected '$expectedBranch', got '$cudosBuildersBranch'";
    exit;
fi

cd "$WORKING_DIR/CudosGravityBridge"
cudosBuildersBranch=$(git branch --show-current)
if [ $cudosBuildersBranch != $expectedBranch ]; then 
    echo -e "${RED_COLOR}Error:${NO_COLOR} Branch mismatch for CudosBuilders. Expected '$expectedBranch', got '$cudosBuildersBranch'";
    exit;
fi

if [ $3 = "client" ]; then 
    if [ ! -f "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.private01.env" ]; then 
        echo -e "${RED_COLOR}Error:${NO_COLOR} The .env file '$WORKING_DIR/CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.private01.env' is missing.";
        exit;
    fi;
fi

echo -e "${GREEN_COLOR}OK:${NO_COLOR} Verification was successful";