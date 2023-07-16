#!/bin/bash

# Color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#  Display script description banner
echo
echo -e "${GREEN}Kali ToolBox${NC} - Script by beardenx v0.1"
echo -e "--------------------------------------"
echo
echo "This script automates the installation of commonly used tools in Kali Linux."
echo "It checks if the tools are already installed and installs them if necessary."
echo "Note: Use with caution and ensure compatibility with your Kali Linux version."
echo ""

# Update package lists
sudo apt update > /dev/null 2>&1

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

# Function to check if MassNmap is installed
is_script_installed() {
    if [ -f "/usr/bin/MassNmap.sh" ]; then
        return 0
    else
        return 1
    fi
}

is_spiderfoot_installed() {
    if command -v spiderfoot &>/dev/null; then
        return 0
    else
        return 1
    fi
}



# Function to install MassNmap
install_script() {
    sudo cp MassNmap.sh /usr/bin/
    sudo chmod +x /usr/bin/MassNmap.sh
    echo -e "${GREEN}Successfully installed MassNmap ${NC}"
}

install_spiderfoot() {
    # Download SpiderFoot
    sudo wget -q "https://github.com/smicallef/spiderfoot/archive/v4.0.tar.gz" -O spiderfoot.tar.gz

    # Extract the downloaded archive
    sudo tar zxf spiderfoot.tar.gz

    # Move the SpiderFoot directory to /opt
    sudo mv spiderfoot-4.0 /opt/spiderfoot

    # Install the required dependencies
    sudo apt install python3-pip > /dev/null 2>&1
    pip3 install -r /opt/spiderfoot/requirements.txt > /dev/null

    # Create a symbolic link to sf.py in /usr/bin
    sudo ln -s /opt/spiderfoot/sf.py /usr/bin/spiderfoot

    # Clean up the downloaded archive
    sudo rm spiderfoot.tar.gz

    echo -e "${GREEN}Successfully installed SpiderFoot.${NC}"
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
install_package "gobuster" || failed_packages+=("gobuster")
install_package "dirbuster" || failed_packages+=("dirbuster")
install_package "wpscan" || failed_packages+=("wpscan")
install_package "joomscan" || failed_packages+=("joomscan")
install_package "wafw00f" || failed_packages+=("wafw00f")
install_package "sqlmap" || failed_packages+=("sqlmap")
install_package "aircrack-ng" || failed_packages+=("aircrack-ng")
install_package "wfuzz" || failed_packages+=("wfuzz")


# Check if MassNmap is already installed
if is_script_installed; then
    echo "- MassNmap is already installed."
else
    install_script
fi

# Check if SpiderFoot is already installed
if is_spiderfoot_installed; then
    echo "- SpiderFoot is already installed."
else
    install_spiderfoot
fi

# Check if all installations are done
if [ ${#failed_packages[@]} -eq 0 ]; then
    echo -e "${GREEN}All installations completed successfully.${NC}"
else
    echo -e "${RED}Some installations failed: ${failed_packages[*]}.${NC}"
fi
