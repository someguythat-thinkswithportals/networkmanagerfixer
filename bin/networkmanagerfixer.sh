#!/bin/bash

#app name and version
VERSION="1.0"
APP_NAME="NetworkManagerFixer"

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' #NC= no color

#log file
LOG_FILE="/var/log/nm_fix.log"

# help function
show_help() {
  echo "NetworkManagerFixer is a tool that fixes the NetworkManager in Linux if something goes wrong to the NetworkManager"
  echo -e "${YELLOW}Usage:${NC} sudo $0 [PARAMETERS]"
  echo ""
  echo -e "${BLUE}Informative options:${NC}"
  echo "  -h, --help    Shows the help"
  echo "  -v, --version Shows the version"
  echo ""
  echo -e "${GREEN}Other options:${NC}"
  echo "  -d, --debug   Shows the hidden proccess"
  echo "  -w, --write   Write the result in the $LOG_FILE and yeah..."
  exit 0
}

# [LOG PREPARATION & ROTATION]
if [ "$WRITE_LOG" = true ]; then
    # creating the file if ain't even existin'
    touch "$LOG_FILE" 2>/dev/null
    # other stuff
    if [ -f "$LOG_FILE" ]; then
        echo "$(tail -n 100 "$LOG_FILE")" > "$LOG_FILE"
    fi
fi

# arguments
DEBUG=false
WRITE_LOG=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)  show_help ;;
        -d|--debug) DEBUG=true ;;
        -w|--write) WRITE_LOG=true ;;
	-v|--version) echo -e "$APP_NAME v$VERSION"; exit 0 ;;
        *) echo -e "${RED}Unknown parameter: $1${NC}"; exit 1 ;;
    esac
    shift
done

# root check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: please launch the script with sudo!${NC}"
  exit 1
fi



# progress indicator
show_spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while ps -p $pid > /dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# even more log stuff
exec_cmd() {
  if [ "$WRITE_LOG" = true ]; then
    echo "--- $(date '+%Y-%m-%d %H:%M:%S') --- Executing: $*" >> "$LOG_FILE"
    "$@" >> "$LOG_FILE" 2>&1
  else
    "$@" > /dev/null 2>&1
  fi
}

echo -ne "${YELLOW}Rebooting the network...${NC}"

if [ "$DEBUG" = true ]; then
    echo -e "\n${RED}[DEBUG MODE]${NC}"
    systemctl disable NetworkManager --now
    systemctl enable NetworkManager --now
    systemctl restart NetworkManager
    sleep 3
else
    (
      exec_cmd systemctl disable NetworkManager --now
      exec_cmd systemctl enable NetworkManager --now
      exec_cmd systemctl restart NetworkManager
      sleep 3
    ) &
    show_spinner $!
fi

echo -e "\n${GREEN}NetworkManager is now restarted! :)${NC}"

# checking the status
STATUS=$(nmcli -t -f STATE g)
if echo "$STATUS" | grep -q "connected"; then
    MSG="Status: ONLINE"
    echo -e "${GREEN}$MSG${NC}"
    [ "$WRITE_LOG" = true ] && echo "Result: $MSG" >> "$LOG_FILE"
else
    MSG="Status: CONNECTING/OFFLINE"
    echo -e "${RED}$MSG${NC}"
    [ "$WRITE_LOG" = true ] && echo "Result: $MSG (Current: $STATUS)" >> "$LOG_FILE"
fi

# end of the script