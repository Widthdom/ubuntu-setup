#!/bin/bash

# Update package lists
sudo apt update

# Install xfce4-terminal if it's not already installed
sudo apt install -y xfce4-terminal

# Set xfce4-terminal as the default terminal emulator
sudo update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal

echo "Terminal setup complete. 'Open Terminal Here' should now work as expected."
