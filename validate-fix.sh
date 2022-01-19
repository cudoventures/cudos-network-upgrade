#!/bin/bash -i
source ./vars.sh

if [ ! -d "$WORKING_DIR/CudosData/$DATA_FOLDER" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Data folder is missing - $WORKING_DIR/CudosData/$DATA_FOLDER does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosNode" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosNode older is missing - $WORKING_DIR/CudosNode does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosGravityBridge" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosGravityBridge folder is missing - $WORKING_DIR/CudosGravityBridge does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosBuilders" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} CudosBuilders folder is missing - $WORKING_DIR/CudosBuilders does not exists";
    exit 1;
fi

if [ ! -d "$WORKING_DIR/CudosNetworkUpgrade" ]; then
    if [ ! -d "$WORKING_DIR/cudos-network-upgrade" ]; then
        echo -e "${RED_COLOR}Error:${NO_COLOR} CudosNetworkUpgrade|cudos-network-upgrade folder is missing - $WORKING_DIR/CudosNetworkUpgrade|cudos-network-upgrade does not exists";
        exit 1;
    fi;
fi

if [ "$(sudo docker container inspect -f '{{.State.Status}}' $START_CONTAINER_NAME 2> /dev/null)" != "running" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} The container $START_CONTAINER_NAME is not running";
    exit 1;
fi

if ! grep -q "\"chain_id\": \"$CHAIN_ID\"" "$WORKING_DIR/CudosData/$DATA_FOLDER/config/genesis.json"; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} Chain id mismatch. Expected $CHAIN_ID.";
    exit 1;
fi

expectedBranch="cudos-testnet-public"

# cd "$WORKING_DIR/CudosBuilders"
# cudosBuildersGitStatus=$(git show -s)
# if ! grep -q "945af42d7522d7b6989e1b782119a0cd2dc2ead2" <<< $cudosBuildersGitStatus ; then 
#     if ! grep -q "2c56748129067adfc460564921534415c819055d" <<< $cudosBuildersGitStatus ; then 
#         echo -e "${RED_COLOR}Error:${NO_COLOR} Commit mismatch for CudosBuilders. Expected '945af42d7522d7b6989e1b782119a0cd2dc2ead2' or '2c56748129067adfc460564921534415c819055d', got '$cudosBuildersGitStatus'";
#         exit 1;
#     fi;
# fi

# cd "$WORKING_DIR/CudosNode"
# cudosNodeGitStatus=$(git show -s)
# if ! grep -q "b639d80d420482d5c3f731b194ac202fd580322b" <<< $cudosNodeGitStatus ; then 
#     echo -e "${RED_COLOR}Error:${NO_COLOR} Commit mismatch for CudosNode. Expected 'b639d80d420482d5c3f731b194ac202fd580322b', got '$cudosNodeGitStatus'";
#     exit 1;
# fi;

# cd "$WORKING_DIR/CudosGravityBridge"
# cudosGravityBridgeGitStatus=$(git show -s)
# if ! grep -q "924242c7325a4d88337c3ed885e341fab637f29d" <<< $cudosGravityBridgeGitStatus ; then 
#     echo -e "${RED_COLOR}Error:${NO_COLOR} Commit mismatch for CudosGravityBridge. Expected '924242c7325a4d88337c3ed885e341fab637f29d', got '$cudosGravityBridgeGitStatus'";
#     exit 1;
# fi;

if [ "$3" = "client" ]; then 
    if [ ! -f "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.public01.env" ]; then 
        echo -e "${RED_COLOR}Error:${NO_COLOR} The .env file '$WORKING_DIR/CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.public01.env' is missing.";
        exit 1;
    fi;
fi

echo -e "Verification...${GREEN_COLOR}Successful${NO_COLOR}";