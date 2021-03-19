source fix.conf

mkdir -p $FIX_TEMPDIR
cd $FIX_TEMPDIR

git clone https://github.com/Koenkk/zigbee2mqtt.git .
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

exit 0