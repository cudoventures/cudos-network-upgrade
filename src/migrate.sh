#!/bin/bash -i
source ./vars.sh

cd "$WORKING_DIR"

echo -ne "Cleaning the docker...";
sudo docker system prune -a -f &> /dev/null
sudo docker image prune -a -f &> /dev/null
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Removing the old repos...";
sudo rm -rf ./CudosNode
sudo rm -rf ./CudosGravityBridge
sudo rm -rf ./CudosBuilders
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Cloning the new repos...";
git clone -q --depth 1 --branch cudos-master https://github.com/CudoVentures/cudos-node.git CudosNode
git clone -q --depth 1 --branch cudos-master  https://github.com/CudoVentures/cudos-builders.git CudosBuilders
git clone -q --depth 1 --branch cudos-master https://github.com/CudoVentures/cosmos-gravity-bridge.git CudosGravityBridge
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Preparing the binary builder...";
cd "$WORKING_DIR/CudosBuilders/docker/binary-builder"
dockerResult=$(sudo docker-compose --env-file ./binary-builder.arg -f ./binary-builder.yml -p cudos-binary-builder build 2> /dev/null)
if [ "$?" != 0 ]; then
    echo -e "${RED_COLOR}Error${NO_COLOR}";
    echo -e "${RED_COLOR}Error:${NO_COLOR} There was an error building the container $?: ${dockerResult}";
    exit 1;
fi
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Copy the .env...";
cd "$WORKING_DIR"
COPY_ENV
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Starting the container for data migration...";
cd "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME"
sed -i "s/cudos-noded start/sleep infinity/g" "./start-$NODE_NAME.dockerfile"
sed -i "s/ --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2//g" "./start-$NODE_NAME.dockerfile"
dockerResult=$(START_NODE 2> /dev/null)
if [ "$?" != 0 ]; then
    echo -e "${RED_COLOR}Error${NO_COLOR}";
    echo -e "${RED_COLOR}Error:${NO_COLOR} There was an error building the container $?: ${dockerResult}";
    exit 1;
fi
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Migrating the data...";

sudo docker container exec $START_CONTAINER_NAME apt-get update &> /dev/null

sudo docker container exec $START_CONTAINER_NAME apt-get install jq -y &> /dev/null

if [ $SHOULD_USE_PREDEFINED_GENESIS = "false" ]; then
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.exported.json\" \"\$CUDOS_HOME/backup/genesis.migrated.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated.json\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_latest_valset_nonce = \"48\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_batched_block = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_logic_call_block = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_valset_nonce = \"47\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_un_bonding_block_height = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1dslwarknhfsw3pfjzxxf5mn28q3ewfectw0gta\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos198qaeg4wkf9tn7y345dhk2wyjmm0krdm85uqwc\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos15jpukx39rtkt8w3u3gzwwvyptdeyejcjade6he\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"hello hello hello\\\"/\\\"hellohellohello\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account\\\"/\\\"createdwithsomeotheraccount\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Cat Food\\\"/\\\"catfood\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"FromRussia\\\"/\\\"fromrussia\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Baal\\\"/\\\"baal\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"My secure denom\\\"/\\\"mysecuredenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"another denom\\\"/\\\"anotherdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Joan's first denom\\\"/\\\"joansfirstdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"My first denom\\\"/\\\"myfirstdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"The ADM NFT COllection\\\"/\\\"theadmnftcollection\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account new\\\"/\\\"createdwithsomeotheraccountnew\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    # sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account new2\\\"/\\\"createdwithsomeotheraccountnew2\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.nft.collections = [.app_state.nft.collections[] | .denom.symbol = \"sym\" + .denom.id]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.chain_id = \"cudos-testnet-public-2\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" \"\$CUDOS_HOME/config/genesis.json\"";
fi

if [ "$(sudo docker container inspect -f '{{.State.Status}}' $START_CONTAINER_NAME 2> /dev/null)" != "running" ]; then
    echo -e "${RED_COLOR}Error:${NO_COLOR} The container $START_CONTAINER_NAME is not running";
fi

if [ $SHOULD_USE_PREDEFINED_GENESIS = "true" ]; then
    CUDOS_HOME=$(sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "echo \"\$CUDOS_HOME\"");
    sudo docker cp "$WORKING_DIR/CudosNetworkUpgrade/config/$GENESIS_JSON_NAME" $(sudo docker ps -aqf "name=$START_CONTAINER_NAME"):"$CUDOS_HOME/config/genesis.json"
fi

echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Reset the state...";
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cudos-noded unsafe-reset-all" &> /dev/null
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

echo -ne "Stopping the container...";
sudo docker stop "$START_CONTAINER_NAME" &> /dev/null
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

cd "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME"
sed -i "s/sleep infinity/cudos-noded start/g" "./start-$NODE_NAME.dockerfile"

if [ $NODE_NAME != 'seed-node' ] || [ $NODE_NAME != 'sentry-node' ]; then
    sed -i "s/sleep infinity/cudos-noded start --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2/g" "./start-$NODE_NAME.dockerfile";
fi

echo -ne "Starting the upgraded container...";
dockerResult=$(START_NODE 2> /dev/null)
if [ "$?" != 0 ]; then
    echo -e "${RED_COLOR}Error${NO_COLOR}";
    echo -e "${RED_COLOR}Error:${NO_COLOR} There was an error building the container $?: ${dockerResult}";
    exit 1;
fi
echo -e "${GREEN_COLOR}OK${NO_COLOR}";