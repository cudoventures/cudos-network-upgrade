#!/bin/bash -i
source ./vars.sh

echo -ne "Stopping the container...";
sudo docker stop "$START_CONTAINER_NAME" &> /dev/null
echo -e "${GREEN_COLOR}OK${NO_COLOR}";

if [ $SHOULD_USE_PREDEFINED_GENESIS = "false" ]; then
    echo -ne "Preparing the binary builder...";
    cd "$WORKING_DIR/CudosBuilders/docker/binary-builder";
    dockerResult=$(sudo docker-compose --env-file ./binary-builder.arg -f ./binary-builder.yml -p cudos-binary-builder build 2> /dev/null)
    if [ "$?" != 0 ]; then
        echo -e "${RED_COLOR}Error${NO_COLOR}";
        echo -e "${RED_COLOR}Error:${NO_COLOR} There was an error building the container $?: ${dockerResult}";
        exit 1;
    fi
    echo -e "${GREEN_COLOR}OK${NO_COLOR}";

    echo -ne "Starting the container for data export...";
    cd "$WORKING_DIR/CudosBuilders/docker/$NODE_NAME";
    sudo sed -i "s/cudos-noded start/sleep infinity/g" "./start-$NODE_NAME.dockerfile";
    sudo sed -i "s/ --state-sync.snapshot-interval 2000 --state-sync.snapshot-keep-recent 2//g" "./start-$NODE_NAME.dockerfile";
    dockerResult=$(START_NODE 2> /dev/null)
    if [ "$?" != 0 ]; then
        echo -e "${RED_COLOR}Error${NO_COLOR}";
        echo -e "${RED_COLOR}Error:${NO_COLOR} There was an error building the container $?: ${dockerResult}";
        exit 1;
    fi
    echo -e "${GREEN_COLOR}OK${NO_COLOR}";

    echo -ne "Exporting the data...";
    sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "rm -rf \"\$CUDOS_HOME/backup\"" &> /dev/null;
    sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "mkdir -p \"\$CUDOS_HOME/backup\""  &> /dev/null;
    sudo docker container exec "$START_CONTAINER_NAME" /bin/bash -c "cudos-noded export |& tee \"\$CUDOS_HOME/backup/genesis.exported.json\""  &> /dev/null;
    echo -e "${GREEN_COLOR}OK${NO_COLOR}";

    echo -ne "Stopping the container...";
    sudo docker stop "$START_CONTAINER_NAME" &> /dev/null;
    echo -e "${GREEN_COLOR}OK${NO_COLOR}";
fi