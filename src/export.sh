#!/bin/bash -i
source ./vars.sh

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