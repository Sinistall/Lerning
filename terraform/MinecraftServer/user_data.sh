#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install default-jdk -y
sudo apt-get install screen -y
mkdir minecraft
cd minecraft
sudo apt-get install wget -y

###wget http://surl.li/dtah
###sudo mv dtah server.jar
wget https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar

echo "eula=true" > eula.txt

cat <<EOF > server.properties
#Minecraft server properties
#Fri Apr 01 14:11:33 UTC 2022
broadcast-rcon-to-ops=true
view-distance=10
max-build-height=256
server-ip=
level-seed=
rcon.port=25575
gamemode=survival
server-port=25565
allow-nether=true
enable-command-block=false
enable-rcon=false
enable-query=false
op-permission-level=4
prevent-proxy-connections=false
generator-settings=
resource-pack=
level-name=world
rcon.password=
player-idle-timeout=0
motd=A Minecraft Server
query.port=25565
force-gamemode=false
hardcore=false
white-list=false
broadcast-console-to-ops=true
pvp=true
spawn-npcs=true
generate-structures=true
spawn-animals=true
snooper-enabled=true
difficulty=hard
function-permission-level=2
network-compression-threshold=256
level-type=default
spawn-monsters=true
max-tick-time=60000
enforce-whitelist=false
use-native-transport=true
max-players=6
resource-pack-sha1=
spawn-protection=16
online-mode=false
allow-flight=false
max-world-size=29999984
EOF
sleep 20

sudo java -Xms512M -Xmx1024M -jar server.jar
