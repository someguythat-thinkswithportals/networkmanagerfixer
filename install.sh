#setup script for putting the networkmanager file in arch linux

cd bin
sudo mkdir /usr/local/bin/netmgrfix
sudo networkmanager.sh /usr/local/bin/netmgrfix
sudo chmod +x /usr/local/bin/netmgrfix
sudo chown root:root /usr/local/bin netmgrfix
