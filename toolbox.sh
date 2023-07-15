#!/bin/bash

# Color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#  Display script description banner
echo -e "${GREEN}Kali ToolBox${NC}"
echo "Developed by beardenx v0.1"
echo
echo "This script automates the installation of commonly used tools in Kali Linux."
echo "It checks if the tools are already installed and installs them if necessary."
echo "Note: Use with caution and ensure compatibility with your Kali Linux version."
echo ""

# Update package lists
sudo apt-get update > /dev/null

# Function to check if a package is installed
is_installed() {
    if dpkg -s "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to install a package if it's not already installed
install_package() {
    if ! is_installed "$1"; then
        sudo apt-get install -y "$1" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully installed $1.${NC}"
        else
            echo -e "${RED}Error installing $1.${NC}"
            return 1
        fi
    else
        echo "- $1 is already installed."
    fi
}

# Install packages
failed_packages=()
install_package "nmap" || failed_packages+=("nmap")
install_package "dirsearch" || failed_packages+=("dirsearch")
install_package "dirb" || failed_packages+=("dirb")
install_package "nikto" || failed_packages+=("nikto")
install_package "nuclei" || failed_packages+=("nuclei")
install_package "metasploit-framework" || failed_packages+=("metasploit-framework")
install_package "net-tools" || failed_packages+=("net-tools")
install_package "testssl.sh" || failed_packages+=("testssl.sh")
install_package "sslscan" || failed_packages+=("sslscan")
install_package "masscan" || failed_packages+=("masscan")
install_package "amass" || failed_packages+=("amass")


# Check if all installations are done
if [ ${#failed_packages[@]} -eq 0 ]; then
    echo -e "${GREEN}All installations completed successfully.${NC}"
else
    echo -e "${RED}Some installations failed: ${failed_packages[*]}.${NC}"
fi
