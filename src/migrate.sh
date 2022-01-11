#!/bin/bash -i
source ./vars.sh

cd "$WORKING_DIR"

sudo mv ./CudosNode ./CudosNode-backup
sudo mv ./CudosGravityBridge ./CudosGravityBridge-backup
sudo mv ./CudosBuilders ./CudosBuilders-backup

git clone --depth 1 --branch cudos-dev https://github.com/CudoVentures/cudos-node.git CudosNode
git clone --depth 1 --branch cudos-dev  https://github.com/CudoVentures/cudos-builders.git CudosBuilders
git clone --depth 1 --branch cudos-dev https://github.com/CudoVentures/cosmos-gravity-bridge.git CudosGravityBridge

cd "$WORKING_DIR/CudosBuilders"
cd ./docker/binary-builder
sudo docker-compose --env-file ./binary-builder.arg -f ./binary-builder.yml -p cudos-binary-builder build

cd "$WORKING_DIR"
COPY_ENV

cd "$WORKING_DIR/CudosBuilders"
cd "./docker/$NODE_NAME"
sed -i "s/cudos-noded start/sleep infinity/g" "./start-$NODE_NAME.dockerfile"
sed -i "s/ --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2//g" "./start-$NODE_NAME.dockerfile"
START_NODE

sudo docker container exec $START_CONTAINER_NAME apt-get update

sudo docker container exec $START_CONTAINER_NAME apt-get install jq -y

if [ $SHOULD_USE_PREDEFINED_GENESIS = "false" ]; then
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.exported.json\" \"\$CUDOS_HOME/backup/genesis.migrated.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated.json\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gov.deposit_params.max_deposit_period = \"86400s\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gov.voting_params.voting_period = \"86400s\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_latest_valset_nonce = \"46\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_batched_block = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_logic_call_block = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_slashed_valset_nonce = \"46\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.last_un_bonding_block_height = \"0\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1dslwarknhfsw3pfjzxxf5mn28q3ewfectw0gta\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos198qaeg4wkf9tn7y345dhk2wyjmm0krdm85uqwc\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos15jpukx39rtkt8w3u3gzwwvyptdeyejcjade6he\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"hello hello hello\\\"/\\\"hellohellohello\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account\\\"/\\\"createdwithsomeotheraccount\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Cat Food\\\"/\\\"catfood\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"FromRussia\\\"/\\\"fromrussia\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Baal\\\"/\\\"baal\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"My secure denom\\\"/\\\"mysecuredenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"another denom\\\"/\\\"anotherdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"Joan's first denom\\\"/\\\"joansfirstdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"My first denom\\\"/\\\"myfirstdenom\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"The ADM NFT COllection\\\"/\\\"theadmnftcollection\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account new\\\"/\\\"createdwithsomeotheraccountnew\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/\\\"created with some other account new2\\\"/\\\"createdwithsomeotheraccountnew2\\\"/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.nft.collections = [.app_state.nft.collections[] | .denom.symbol = \"sym\" + .denom.name]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" \"\$CUDOS_HOME/config/genesis.json\"";
fi

if [ $SHOULD_USE_PREDEFINED_GENESIS = "true" ]; then
    CUDOS_HOME=$(sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "echo \"\$CUDOS_HOME\"");
    sudo docker cp "$WORKING_DIR/CudosNetworkUpgrade/config/$GENESIS_JSON_NAME" $(sudo docker ps -aqf "name=$START_CONTAINER_NAME"):"$CUDOS_HOME/config/genesis.json"
fi

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cudos-noded unsafe-reset-all";

sudo docker stop "$START_CONTAINER_NAME"

cd "$WORKING_DIR/CudosBuilders"
cd "./docker/$NODE_NAME"
sed -i "s/sleep infinity/cudos-noded start/g" "./start-$NODE_NAME.dockerfile"

if [ $NODE_NAME != 'seed-node' ] || [ $NODE_NAME != 'sentry-node' ]; then
    sed -i "s/sleep infinity/cudos-noded start --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2/g" "./start-$NODE_NAME.dockerfile";
fi

START_NODE
