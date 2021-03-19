source fix.conf
# parseFalse data from data/coordinator_backup.json
tableLen=$(python -c "import json,sys;print(json.load(sys.stdin)['data']['ZCD_NV_NIB']['len']);" < $FIX_TEMPDIR/data/coordinator_backup.json)
echo "Table length is $tableLen"