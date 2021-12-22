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

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos10ltqnr7ll8tjg4c2f4tdtqj784v29t39lq9w08\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1t9rqh0739058p3gtgye77uqf3q57sxsjxf04fh\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1g9c9vtls5vx92gwvqvxfavpzrk08muqmmdhwn6\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/Joan's proper denom/joansproperdenom/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.nft.collections = [.app_state.nft.collections[] | .denom.symbol = \"sym\" + .denom.name]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\"";
    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\"";

    sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" \"\$CUDOS_HOME/config/genesis.json\"";
fi

if [ $SHOULD_USE_PREDEFINED_GENESIS = "true" ]; then
    docker cp "$WORKING_DIR/CudosNetworkUpgrade/config/$GENESIS_JSON_NAME" $(docker ps -aqf "name=$START_CONTAINER_NAME"):/usr/cudos/CudosBuilders
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
