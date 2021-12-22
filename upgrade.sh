source ./config/.env

if [ $WORKING_DIR = '' ]; then
    echo 'Error: You MUST specify WORKING_DIR env using ./config/.env'
    exit
fi

export WORKING_DIR="$WORKING_DIR"

if ([ $# != 3 ]) || ([ $1 != "testnet-private" ] && [ $1 != 'testnet-public' ]) || ([ $2 != "full-node" ] && [ $2 != 'root-node' ] && [ $2 != 'seed-node' ] && [ $2 != 'sentry-node' ]) || ([ $3 != "client" ] && [ $3 != 'root-zone-01' ] && [ $3 != 'root-zone-02' ] && [ $3 != 'root-zone-03' ]); then
    echo 'Usage: upgrade.sh [network] [node-name] [mode]';
    echo '[network] = testnet-private|testnet-public';
    echo '[node-name] = full-node|root-node|seed-node|sentry-node';
    echo '[mode] = client|root-zone-01|root-zone-02|root-zone-03';
    exit
fi

export NODE_NAME="$2"

if [ $1 = "testnet-private" ]; then 
    export CHAIN_ID=cudos-testnet-private;

    if [ $3 = "client" ]; then 

        alias START_NODE='sudo docker-compose --env-file "./$NODE_NAME.client.testnet.private01.arg"  -f "./start-$NODE_NAME.yml" -p "cudos-start-$NODE_NAME-client-testnet-private-01" up --build -d'
        alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/$NODE_NAME.client.testnet.private01.env" "./CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.private01.env"'

        if [ $NODE_NAME = "full-node" ]; then
            export START_CONTAINER_NAME="cudos-start-full-node-client-testnet-private-01";
            export DATA_FOLDER="cudos-data-full-node-client-testnet-private-01";
        fi

        if [ $NODE_NAME = "root-node" ]; then
            echo 'ERROR: Client cannot update the root node';
            exit
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-client-testnet-private-01";
            export DATA_FOLDER="cudos-data-seed-node-client-testnet-private-01";
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-client-testnet-private-01";
            export DATA_FOLDER="cudos-data-sentry-node-client-testnet-private-01";
        fi
    fi

    if [ $3 = "root-zone-01" ]; then 

        if [ $NODE_NAME = "full-node" ]; then
            echo 'ERROR: root-zone-01 does not have a full-node';
            exit;
        fi

        if [ $NODE_NAME = "root-node" ]; then
            export START_CONTAINER_NAME="cudos-start-root-node";
            export DATA_FOLDER="cudos-data-root-node";

            alias START_NODE='sudo docker-compose --env-file "./root-node.testnet.private.arg"  -f "./start-root-node.yml" -p "cudos-start-root-node" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/root-node.testnet.private.env" "./CudosBuilders/docker/$NODE_NAME/root-node.testnet.private.env"'
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-testnet-private";
            export DATA_FOLDER="cudos-data-seed-node-testnet-private";

            alias START_NODE='sudo docker-compose --env-file "./seed-node.testnet.private.arg"  -f "./start-seed-node.yml" -p "cudos-start-seed-node-01" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/seed-node.testnet.private.env" "./CudosBuilders/docker/$NODE_NAME/seed-node.testnet.private.env"'
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-testnet-private";
            export DATA_FOLDER="cudos-data-sentry-node-testnet-private";

            alias START_NODE='sudo docker-compose --env-file "./sentry-node.testnet.private.arg"  -f "./start-sentry-node.yml" -p "cudos-start-sentry-node-01" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/sentry-node.testnet.private.env" "./CudosBuilders/docker/$NODE_NAME/sentry-node.testnet.private.env"'
        fi

    fi

    if [ $3 = "root-zone-02" ] || [ $3 = "root-zone-03" ]; then 
        echo 'ERROR: testnet-private does not have root-zone-02 neither root-zone-03'
        exit
    fi

fi

if [ $1 = "testnet-public" ]; then 
    export CHAIN_ID=cudos-testnet-public;

    if [ $3 = "client" ]; then 

        export ARG="$NODE_NAME.client.testnet.public01.arg"

        alias START_NODE='sudo docker-compose --env-file "./$NODE_NAME.client.testnet.public01.arg"  -f "./start-$NODE_NAME.yml" -p "cudos-start-$NODE_NAME-client-testnet-public-01" up --build -d'
        alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/$NODE_NAME.client.testnet.public01.env" "./CudosBuilders/docker/$NODE_NAME/$NODE_NAME.client.testnet.public01.env"'

        if [ $NODE_NAME = "full-node" ]; then
            export START_CONTAINER_NAME="cudos-start-full-node-client-testnet-public-01";
            export DATA_FOLDER="cudos-data-full-node-client-testnet-public-01";
        fi

        if [ $NODE_NAME = "root-node" ]; then
            echo 'ERROR: Client cannot update the root node';
            exit
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-client-testnet-public-01";
            export DATA_FOLDER="cudos-data-seed-node-client-testnet-public-01";
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-client-testnet-public-01";
            export DATA_FOLDER="cudos-data-sentry-node-client-testnet-public-01";
        fi
    fi

    if [ $3 = "root-zone-01" ]; then

        if [ $NODE_NAME = "full-node" ]; then
            echo 'ERROR: root-zone-01 does not have a full-node';
            exit
        fi

        if [ $NODE_NAME = "root-node" ]; then
            export START_CONTAINER_NAME="cudos-start-root-node";
            export DATA_FOLDER="cudos-data-root-node"

            alias START_NODE='sudo docker-compose --env-file "./root-node.testnet.public.zone01.arg"  -f "./start-root-node.yml" -p "cudos-start-root-node" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/root-node.testnet.public.zone01.env" "./CudosBuilders/docker/$NODE_NAME/root-node.testnet.public.zone01.env"'
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-testnet-public-zone01";
            export DATA_FOLDER="cudos-data-seed-node-testnet-public-zone01";

            alias START_NODE='sudo docker-compose --env-file "./seed-node.testnet.public.zone01.arg"  -f "./start-seed-node.yml" -p "cudos-start-seed-node-01" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/seed-node.testnet.public.zone01.env" "./CudosBuilders/docker/$NODE_NAME/seed-node.testnet.public.zone01.env"'
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-testnet-public-zone01";
            export DATA_FOLDER="cudos-data-sentry-node-testnet-public-zone01";

            alias START_NODE='sudo docker-compose --env-file "./sentry-node.testnet.public.zone01.arg"  -f "./start-sentry-node.yml" -f "./start-sentry-node-tls-overwrite.yml" -p "cudos-start-sentry-node-01" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/sentry-node.testnet.public.zone01.env" "./CudosBuilders/docker/$NODE_NAME/sentry-node.testnet.public.zone01.env"'
        fi

    fi

    if [ $3 = "root-zone-02" ]; then

        export ARG="$NODE_NAME.testnet.public.zone02.arg"

        if [ $NODE_NAME = "full-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-testnet-public-zone01";
            export DATA_FOLDER="cudos-data-sentry-node-testnet-public-zone01";

            alias START_NODE='sudo docker-compose --env-file "./full-node.testnet.public.zone02.arg"  -f "./start-full-node.yml" -p "cudos-start-validator-node-02" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/full-node.testnet.public.zone02.env" "./CudosBuilders/docker/$NODE_NAME/full-node.testnet.public.zone02.env"'
        fi

        if [ $NODE_NAME = "root-node" ]; then
            echo 'ERROR: root-zone-02 does not have a root-node';
            exit
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-testnet-public-zone02";
            export DATA_FOLDER="cudos-data-seed-node-testnet-public-zone02";

            alias START_NODE='sudo docker-compose --env-file "./seed-node.testnet.public.zone02.arg"  -f "./start-seed-node.yml" -p "cudos-start-seed-node-02" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/seed-node.testnet.public.zone02.env" "./CudosBuilders/docker/$NODE_NAME/seed-node.testnet.public.zone02.env"'
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-testnet-public-zone02";
            export DATA_FOLDER="cudos-data-sentry-node-testnet-public-zone02";

            alias START_NODE='sudo docker-compose --env-file "./sentry-node.testnet.public.zone02.arg"  -f "./start-sentry-node.yml" -f "./start-sentry-node-tls-overwrite.yml" -p "cudos-start-sentry-node-02" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/sentry-node.testnet.public.zone02.env" "./CudosBuilders/docker/$NODE_NAME/sentry-node.testnet.public.zone02.env"'
        fi

    fi

    if [ $3 = "root-zone-03" ]; then 

        export ARG="$NODE_NAME.testnet.public.zone03.arg"

        if [ $NODE_NAME = "full-node" ]; then
            export START_CONTAINER_NAME="cudos-start-full-node-testnet-public-zone03";
            export DATA_FOLDER="cudos-data-full-node-testnet-public-zone03";

            alias START_NODE='sudo docker-compose --env-file "./full-node.testnet.public.zone03.arg"  -f "./start-full-node.yml" -p "cudos-start-validator-node-03" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/full-node.testnet.public.zone03.env" "./CudosBuilders/docker/$NODE_NAME/full-node.testnet.public.zone03.env"'
        fi

        if [ $NODE_NAME = "root-node" ]; then
            echo 'ERROR: root-zone-02 does not have a root-node';
            exit
        fi

        if [ $NODE_NAME = "seed-node" ]; then
            export START_CONTAINER_NAME="cudos-start-seed-node-testnet-public-zone03";
            export DATA_FOLDER="cudos-data-seed-node-testnet-public-zone03";

            alias START_NODE='sudo docker-compose --env-file "./seed-node.testnet.public.zone03.arg"  -f "./start-seed-node.yml" -p "cudos-start-seed-node-03" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/seed-node.testnet.public.zone03.env" "./CudosBuilders/docker/$NODE_NAME/seed-node.testnet.public.zone03.env"'
        fi

        if [ $NODE_NAME = "sentry-node" ]; then
            export START_CONTAINER_NAME="cudos-start-sentry-node-testnet-public-zone03";
            export DATA_FOLDER="cudos-data-sentry-node-testnet-public-zone03";

            alias START_NODE='sudo docker-compose --env-file "./sentry-node.testnet.public.zone03.arg"  -f "./start-sentry-node.yml" -f "./start-sentry-node-tls-overwrite.yml" -p "cudos-start-sentry-node-03" up --build -d'
            alias COPY_ENV='cp "./CudosBuilders-backup/docker/$NODE_NAME/sentry-node.testnet.public.zone03.env" "./CudosBuilders/docker/$NODE_NAME/sentry-node.testnet.public.zone03.env"'
        fi

    fi

fi

echo $WORKING_DIR
echo $NODE_NAME
echo $START_CONTAINER_NAME
echo $DATA_FOLDER
echo $CHAIN_ID

alias START_NODE
alias COPY_ENV

# EXPORT
sudo docker stop "$START_CONTAINER_NAME"

cd "$WORKING_DIR/CudosBuilders/docker/binary-builder"
sudo docker-compose --env-file ./binary-builder.arg -f ./binary-builder.yml -p cudos-binary-builder build
cd "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME"
sudo sed -i "s/cudos-noded start/sleep infinity/g" "./start-$NODE_NAME.dockerfile"
sudo sed -i "s/ --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2//g" "./start-$NODE_NAME.dockerfile"
START_NODE

sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "rm -rf \"\$CUDOS_HOME/backup\""
sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "mkdir -p \"\$CUDOS_HOME/backup\""
sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "cudos-noded export |& tee \"\$CUDOS_HOME/backup/genesis.exported.json\""
sudo docker stop "$START_CONTAINER_NAME"

sudo rm -rf "$WORKING_DIR/CudosData/$DATA_FOLDER-backup"
sudo cp -r "$WORKING_DIR/CudosData/$DATA_FOLDER" "$WORKING_DIR/CudosData/$DATA_FOLDER-backup"

# MIGRATE
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

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.exported.json\" \"\$CUDOS_HOME/backup/genesis.migrated.json\""

sudo docker container exec $START_CONTAINER_NAME apt-get update

sudo docker container exec $START_CONTAINER_NAME apt-get install jq -y

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated.json\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gov.deposit_params.max_deposit_period = \"86400s\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gov.voting_params.voting_period = \"86400s\"' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos10ltqnr7ll8tjg4c2f4tdtqj784v29t39lq9w08\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1t9rqh0739058p3gtgye77uqf3q57sxsjxf04fh\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.gravity.static_val_cosmos_addrs += [\"cudos1g9c9vtls5vx92gwvqvxfavpzrk08muqmmdhwn6\"]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "sed -i \"s/Joan's proper denom/joansproperdenom/g\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cat \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" | jq '.app_state.nft.collections = [.app_state.nft.collections[] | .denom.symbol = \"sym\" + .denom.name]' > \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\""
sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "mv \"\$CUDOS_HOME/backup/genesis.migrated-modified.json.tmp\" \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\""


sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cudos-noded unsafe-reset-all"

sudo docker container exec $START_CONTAINER_NAME /bin/bash -c "cp \"\$CUDOS_HOME/backup/genesis.migrated-modified.json\" \"\$CUDOS_HOME/config/genesis.json\""

cd "$WORKING_DIR/CudosBuilders"
cd "./docker/$NODE_NAME"
sed -i "s/sleep infinity/cudos-noded start/g" "./start-$NODE_NAME.dockerfile"

if [ $NODE_NAME != 'seed-node' ] || [ $NODE_NAME != 'sentry-node' ]; then
    sed -i "s/sleep infinity/cudos-noded start --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2/g" "./start-$NODE_NAME.dockerfile";
fi

START_NODE
