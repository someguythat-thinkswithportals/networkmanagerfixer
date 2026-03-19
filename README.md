# NetworkManagerFixer

A script for quick reboot and fixing NetworkManager. Thats all i can say.

## some features
- **root check**: automatic checking superuser rights
- **a spinner**: a loading indicator when its restarting the services
- **debug mode**: flag for viewing the process of rebooting the systems i guess

## Installing

first copy the repository
```bash
git clone https://github.com
cd networkmanagerfixer
```
then type
```sudo ./install.sh```

after that the command ```netmgrfix``` is available for the entire operating system (linux only)

## Usage
launching in the regular mode
```bash
sudo netmgrfix
```

## Other flags

- **-h, --help**: shows help about the commands
- **-v, --version**: shows the current version (v1.0)
- **-d, --debug**: launching without hiding the hidden actions (debug)
- **-w, --write**: writing a log in the /var/log/nm_fix.log file.

## Logging
Using the -w flag, the script saves the data in /var/log/nm_fix.log. The file automatically cleans itself, keeps the last 100 records, to not fill space of the disk.

## Other things
The ```install.sh``` command is working only on Arch Linux, to put on other linux distros, you might need some knowledge to do this.
