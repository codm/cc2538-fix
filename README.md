# Fix the NIB-Table of CC2438 using zigbee2mqtt

# English

This tutorial uses zigbee2mqtt functionalities to test for the NVRAM NIB-table length and cleans the NVRAM using `scripts/zStackEraseAllNvMem.js`. We seperated some commands into scripts, it's easier for you to repair your controller. The scripts are for Linux. If you are a windows user, please feel free to reach out to us to help you with it.

## phase 1: Preparation

### 1. Clone this repository to your linux machine where you have the controller plugged in.
`git clone`

### 2. Create a copy the fix.template.conf file called fix.conf
`cp fix.template.conf fix.conf`

Change the values accordingly:
```
# the filepointer of the device you want to repair
FIX_UART_DEVICE=/dev/ttyAMA0

# folder where zigbee2mqtt github project is checked out
FIX_TEMPDIR=~/tmp/cc2538fix # location where code is checked out
```

### 3. make sure the following  software is installed
`nodejs, npm, python`

for ubuntu/debian:

`sudo apt install nodejs npm python`

### 4. run the script to checkout and load zigbee2mqtt repository
`./clonez2m.sh`

This script can take some time since it's also installing dependencies from NPM repository. After the script has completed, check with `echo $?` if the script was run successfully. If the return value is 0, everything is okay.

### 5. shutdown software which is using your device. you can check that by doing the following:
```
source fix.conf
ls -l /proc/[0-9]*/fd/* | grep $FIX_UART_DEVICE

example output:
lrwx------ 1 root dialout 64 Sep 12 10:30 /proc/14683/fd/3 -> /dev/ttyAMA0
```

Then you send a kill signal  to the process, in this case it's `kill -15 14683`.

Check again, if the shutdown was successful and no process uses your serial device.

## phase 2: checking for length of NIB_TABLE
### 1. Switch to z igbee2mqtt folder, then run zigbee2mqtt once
```
source fix.conf
cd $FIX_TEMPDIR
npm start
```
Once you see a message which shows
```
Zigbee2MQTT:info  2021-03-19 11:38:35: Coordinator firmware version: '{"meta":{"maintrel":2,"majorrel":2,"minorrel":7,"product":2,"revision":20201010,"transportrev":2},"type":"zStack30x"}'
```
You can press Ctrl-C to close zigbee2mqtt

### 2. go back to the root folder of this repo and run the checkLen script.
```
./checkLen

output:
Table length is 110 
```

If the table length is 116, everything is okay and you can go to phase 3. 

If the table length is 110, you need to continue.

### 3. again, go to zigbee2mqtt folder, delete the coordinator_backup and run the clear-nvram-script.

```
source fix.conf
cd $FIX_TEMPDIR
rm data/coordinator_backup.json
node scripts/zStackEraseAllNvMem.js $FIX_UART_DEVICE
```

### 4. reboot
`sudo reboot`

### 5. goto phase 2.1 and continue from there. 
Start zigbee2mqtt, check lenght with script. If length is 116, all is good and you continue with phase 3.
If length is still 100, repeat whole phase 2 until it works.

## phase 3: cleanup

### 1. In your usual software which uses zigbee, please make sure that the zigbee controller backup is deleted.

#### zigbee2mqtt
Usually, for zigbee2mqtt you find the controller backup in /opt/zigbee2mqtt/data/coordinator_backup.json. If it's not that exact path, try to remember where you edited the configuration.yaml. The coordinator_backup.json you're supposed to delete is in the same folder.

#### homegear
TODO

#### homeassistant
TODO

#### You can cleanup this repository by:
```
rm -rf cc2538-fixscript
```

#German

# Repariere die NIB-Tabelle des CC2438 mit zigbee2mqtt

Dieses Tutorial nutzt die Funktionalitäten von zigbee2mqtt, um die Länge der NIB-Tabelle im NVRAM zu testen und das NVRAM mit `scripts/zStackEraseAllNvMem.js` zu bereinigen. Wir haben einige Befehle in Skripte aufgeteilt, es ist einfacher für Sie, Ihren Controller zu reparieren. Die Skripte sind für Linux. Wenn Sie ein Windows-Benutzer sind, können Sie sich gerne an uns wenden, damit wir Ihnen dabei helfen.

## Phase 1: Vorbereitung

### 1. Klonen Sie dieses Repository auf Ihren Linux-Rechner, an dem Sie den Controller angeschlossen haben.
`git clone`

### 2. Erstellen Sie eine Kopie der Datei fix.template.conf mit dem Namen fix.conf
`cp fix.template.conf fix.conf`

Ändern Sie die Werte entsprechend:
```
# den Dateizeiger des Geräts, das Sie reparieren wollen
FIX_UART_DEVICE=/dev/ttyAMA0

# den Ordner, in dem das zigbee2mqtt-Github-Projekt ausgecheckt ist
FIX_TEMPDIR=~/tmp/cc2538fix # Ort, an dem der Code ausgecheckt wird
```

### 3. Stellen Sie sicher, dass die folgende Software installiert ist
`nodejs, npm, python`

für ubuntu/debian:

`sudo apt install nodejs npm python`

### 4. Führen Sie das Skript aus, um das zigbee2mqtt-Repository auszuchecken und zu laden
`./clonez2m.sh`

Dieses Skript kann einige Zeit in Anspruch nehmen, da es auch die Abhängigkeiten aus dem NPM-Repository installiert. Nachdem das Skript abgeschlossen ist, überprüfen Sie mit `echo $?`, ob das Skript erfolgreich ausgeführt wurde. Wenn der Rückgabewert 0 ist, ist alles in Ordnung.

### 5. Beenden Sie die Software, die Ihr Gerät benutzt. Sie können das wie folgt überprüfen:
```
Quelle fix.conf
ls -l /proc/[0-9]*/fd/* | grep $FIX_UART_DEVICE

Beispiel-Ausgabe:
lrwx------ 1 root dialout 64 Sep 12 10:30 /proc/14683/fd/3 -> /dev/ttyAMA0
```

Dann senden Sie ein Kill-Signal an den Prozess, in diesem Fall ist es `kill -15 14683`.

Prüfen Sie noch einmal, ob das Herunterfahren erfolgreich war und kein Prozess Ihr serielles Gerät benutzt.

## Phase 2: Überprüfung der Länge der NIB_TABLE
### 1. Wechseln Sie in den Ordner zigbee2mqtt, dann führen Sie zigbee2mqtt einmal aus
```
Quelle fix.conf
cd $FIX_TEMPDIR
npm starten
```
Sobald Sie eine Meldung sehen, die zeigt
```
Zigbee2MQTT:info 2021-03-19 11:38:35: Coordinator firmware version: '{"meta":{"maintrel":2,"majorrel":2,"minorrel":7,"product":2,"revision":20201010,"transportrev":2},"type":"zStack30x"}'
```
Sie können Strg-C drücken, um zigbee2mqtt zu schließen

### 2. Gehen Sie zurück in den Stammordner dieses Repos und führen Sie das checkLen-Skript aus.
```
./checkLen

Ausgabe:
Tabellenlänge ist 110 
```

Wenn die Tabellenlänge 116 ist, ist alles in Ordnung und Sie können zu Phase 3 übergehen. 

Wenn die Tabellenlänge 110 ist, müssen Sie fortfahren.

### 3. Gehen Sie wieder in den Ordner zigbee2mqtt, löschen Sie das coordinator_backup und führen Sie das clear-nvram-script aus.

```
Quelle fix.conf
cd $FIX_TEMPDIR
rm data/koordinator_backup.json
node scripts/zStackEraseAllNvMem.js $FIX_UART_DEVICE
```

### 4. reboot
`sudo reboot`

### 5. Gehen Sie zu Phase 2.1 und fahren Sie von dort aus fort. 
Starten Sie zigbee2mqtt, prüfen Sie die Länge mit dem Skript. Wenn die Länge 116 ist, ist alles gut und Sie fahren mit Phase 3 fort.
Wenn Länge immer noch 100 ist, wiederholen Sie die gesamte Phase 2, bis es funktioniert.

## Phase 3: Aufräumen

### 1. In Ihrer üblichen Software, die Zigbee verwendet, stellen Sie bitte sicher, dass das Backup des Zigbee-Controllers gelöscht ist.

#### zigbee2mqtt
Normalerweise finden Sie bei zigbee2mqtt das Controller-Backup in /opt/zigbee2mqtt/data/coordinator_backup.json. Wenn es nicht genau dieser Pfad ist, versuchen Sie sich zu erinnern, wo Sie die configuration.yaml bearbeitet haben. Die coordinator_backup.json, die Sie löschen sollen, befindet sich im selben Ordner.

#### homegear
TODO

#### homeassistant
TODO

#### Sie können dieses Repository bereinigen, indem Sie:
```
rm -rf cc2538-fixscript
```

Übersetzt mit www.DeepL.com/Translator (kostenlose Version)