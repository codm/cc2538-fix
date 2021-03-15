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
    echo "Setting config"
    cat <<EOF > data/configuration.yaml
homeassistant: false

permit_join: false

mqtt:
    base_topic: zigbee2mqtt
    server: 'mqtt://localhost'
serial:
    port: $FIX_UART_DEVICE
EOF
    echo "starting zigbee2mqtt for 60 seconds, logging to zigbee2mqtt_output.log"
    npm start > $STARTING_DIR/zigbee2mqtt_output.log 2>&1 &
    ZIG2MQTTPID=$!
    echo "wait for 60 seconds for zigbee2mqtt, then kill $ZIG2MQTTPID"
    sleep 60
    kill -15 $ZIG2MQTTPID
    # Run zigbee-herdsman to create a coordinator-backup.json
}

repair_coordinator() 
{
    # parseFalse data from data/coordinator_backup.json
    tableLen=$(python -c "import json,sys;print(json.load(sys.stdin)['data']['ZCD_NV_NIB']['len']);" < data/coordinator_backup.json)
    echo "Table length is $tableLen"
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
echo "2. Switch directory"
cd $FIX_TEMPDIR
if [ $FIX_GITHUB_CLONE == "True" ]
then
    echo "3. checking out zigbee2mqtt"
    checkout_and_start_zigbee2mqtt
fi

repair_coordinator

echo "X: go back to starting dir, cleanup and finish"
cd $STARTING_DIR
if [ $FIX_GITHUB_CLONE == "True" ]
then
    echo "X+1. deleting temp dir"
    rm -rf $FIX_TEMPDIR
fi