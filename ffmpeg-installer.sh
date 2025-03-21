#!/bin/bash

# This script installs ffmpeg on Ubuntu
# Run this script with root permissions
# chmod +x ffmpeg-installer.sh
# sudo ./ffmpeg-installer.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${Yellow}This script requires root permissions, please run as root"
    exit 1
fi
echo -e "${NC}Installing ffmpeg"
sudo apt update
sudo apt install -y ffmpeg
echo -e "${GREEN}ffmpeg has been installed successfully"
echo -e "${NC}ffmpeg version:"
# verify installation
ffmpeg -version