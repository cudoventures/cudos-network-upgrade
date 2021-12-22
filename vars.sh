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

alias sudo=""