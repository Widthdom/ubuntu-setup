#!/bin/bash

# Ensure target directory exists
mkdir -p ~/.local/share/applications

# Copy the desktop entry for xfce4-terminal to the user directory
cp /usr/share/applications/xfce4-terminal.desktop ~/.local/share/applications/

# Modify the Exec line to force DISPLAY=:10 (for Xvnc session)
sed -i 's|^Exec=xfce4-terminal|Exec=env DISPLAY=:10 xfce4-terminal|' ~/.local/share/applications/xfce4-terminal.desktop

echo "xfce4-terminal desktop entry updated to run on DISPLAY=:10"
