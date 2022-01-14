#!/bin/bash -i
source ./vars.sh

# echo $WORKING_DIR
# echo $NODE_NAME
# echo $START_CONTAINER_NAME
# echo $DATA_FOLDER
# echo $CHAIN_ID

# alias START_NODE
# alias COPY_ENV

./validate.sh $@
if [ "$?" != 0 ]; then
    exit $?;
fi;
./src/export.sh $@
if [ "$?" != 0 ]; then
    exit $?;
fi;
./src/migrate.sh $@
if [ "$?" != 0 ]; then
    exit $?;
fi;

echo -e "Upgrading...${GREEN_COLOR}Successful${NO_COLOR}";