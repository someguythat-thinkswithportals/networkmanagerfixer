#setup script for putting the networkmanagerfixer file in arch linux

mv networkmanagerfixer.sh netmgrfix.sh
sudo chmod +x netmgrfix.sh
sudo chown root:root netmgrfix.sh
mv netmgrfix.sh netmgrfix
sudo cp netmgrfix /usr/local/bin
