#!/bin/bash

# Create script
# nano xrdp-xfce-setup.sh
# Change ownership
# sudo chown $USER:$USER xrdp-xfce-setup.sh
# Make executable
# chmod +x xrdp-xfce-setup.sh
# Execute
# ./xrdp-xfce-setup.sh
# Reboot
# sudo reboot

# Update packages and install required components
sudo apt update
sudo apt install -y xfce4 xrdp lightdm tigervnc-standalone-server dbus-x11

# Set lightdm as the default display manager (for GUI login)
sudo debconf-set-selections <<< "lightdm shared/default-x-display-manager select lightdm"
sudo dpkg-reconfigure -f noninteractive lightdm

# Write session start command to ~/.xsession
echo "exec startxfce4" > ~/.xsession
chmod +x ~/.xsession
sudo chown $USER:$USER ~/.xsession

# Create ~/.vnc/xstartup to ensure xfce4 is launched via Xvnc
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x ~/.vnc/xstartup

# Set up /etc/xrdp/startwm.sh with a minimal configuration (fallback if needed)
sudo bash -c 'cat > /etc/xrdp/startwm.sh' <<'EOF'
#!/bin/sh
exec startxfce4
EOF
sudo chmod +x /etc/xrdp/startwm.sh

# Add Xvnc session definition to /etc/xrdp/xrdp.ini (if not already present)
if ! grep -q "\[xvnc\]" /etc/xrdp/xrdp.ini; then
sudo bash -c 'cat >> /etc/xrdp/xrdp.ini' <<'EOF'

[xvnc]
name=Xvnc
lib=libvnc.so
username=ask
password=ask
ip=127.0.0.1
port=-1
EOF
fi

# Enable and restart xrdp service
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo "Xvnc session setup complete! Please select 'Xvnc' when connecting via enhanced session."
