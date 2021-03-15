#/bin/bash

source fix.conf

# Definition of Functions

checkout_and_start_zigbee2mqtt()
{
    git pull $FIX_GITHUB .
    cd zigbee-herdsman
    npm install
    if [ $? != 0 ]
        echo "Error in NPM install, bye"
        exit 2
    fi
    # Run zigbee-herdsman to create a coordinator-backup.json
}

# Script Entry point
STARTING_DIR=`pwd`
echo "1: Create Tempdir"
mkdir -p $FIX_TEMPDIR
if [ !(-d $FIX_TEMPDIR)]
    echo "Something went wrong creating the tempdir"
    exit 1
fi
cd $FIX_TEMPDIR

echo "2: check if existing zigbee2mqtt"

if [ $FIX_EXISTING_ZIGBEE2MQTT != "False" ]
    if [ -d $FIX_EXISTING_ZIGBEE2MQTT_DIR ]
    fi
else
    checkout_and_start_zigbee2mqtt
fi


echo "X: go back to starting dir and fininsh"
cd $STARTING_DIR