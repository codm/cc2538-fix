#/bin/bash

source fix.conf

# Definition of Functions

checkout_and_start_zigbee2mqtt()
{
    git clone $FIX_GITHUB .
    npm install
    if [ $? != 0 ];
    then
        echo "Error in NPM install, bye"
        exit 2
    fi
    # Run zigbee-herdsman to create a coordinator-backup.json
}

# Script Entry point
STARTING_DIR=`pwd`
echo "1: Create Tempdir"
if [ -d $FIX_TEMPDIR ];
then
    echo "Target dir $FIX_TEMPDIR exists, please delete it first or choose another directory"
    exit 0
fi
mkdir -p $FIX_TEMPDIR
if [ ! -d $FIX_TEMPDIR ];
then
    echo "Something went wrong creating the tempdir"
    exit 1
fi
cd $FIX_TEMPDIR

echo "2: check if existing zigbee2mqtt"

if [ $FIX_EXISTING_ZIGBEE2MQTT != "False" ];
then
    if [ -d $FIX_EXISTING_ZIGBEE2MQTT_DIR ];
    then
        echo "doing some stuff..."
    fi
else
    checkout_and_start_zigbee2mqtt
fi


echo "X: go back to starting dir, cleanup and finish"
cd $STARTING_DIR