#setup script for putting the networkmanager file in arch linux

cd bin || { echo "Directory 'bin' not found"; exit 1; }
sudo mkdir -p /usr/local/bin/netmgrfix
sudo cp networkmanagerfixer.sh /usr/local/bin/netmgrfix/
sudo chmod +x /usr/local/bin/netmgrfix/networkmanagerfixer.sh
sudo chown root:root /usr/local/bin/netmgrfix/networkmanagerfixer.sh
