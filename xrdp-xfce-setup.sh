#!/bin/bash

# Setup script for Ubuntu 22.04: xfce4 + xrdp + Xvnc
# This script disables Wayland, installs required packages, and configures startup files.

echo "[1/6] Installing required packages..."
sudo apt update
sudo apt install -y xfce4 xrdp tigervnc-standalone-server dbus-x11 xfce4-terminal fcitx-mozc fcitx-keyboard fonts-noto-cjk

echo "[2/6] Disabling Wayland (required for xrdp)..."
sudo sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
if ! grep -q "^WaylandEnable=false" /etc/gdm3/custom.conf; then
  sudo bash -c 'echo -e "\n[daemon]\nWaylandEnable=false" >> /etc/gdm3/custom.conf'
fi

echo "[3/6] Creating .xsession and .xstartup..."

# .xsession to start xfce4 when xrdp session begins
cat > ~/.xsession <<'EOF'
#!/bin/sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx-autostart &
exec startxfce4
EOF
chmod +x ~/.xsession
sudo chown "$USER:$USER" ~/.xsession

# .vnc/xstartup for VNC session startup
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x ~/.vnc/xstartup

echo "[4/6] Configuring /etc/xrdp/startwm.sh..."
sudo bash -c 'cat > /etc/xrdp/startwm.sh' <<'EOF'
#!/bin/sh
exec startxfce4
EOF
sudo chmod +x /etc/xrdp/startwm.sh

echo "[5/6] Adding Xvnc session section to /etc/xrdp/xrdp.ini if not present..."
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

echo "[6/6] Restarting xrdp service..."
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo
echo "Setup completed."
echo "Please reboot the system to apply Wayland configuration changes:"
echo "    sudo reboot"
echo "After reboot, use 'Xvnc' session when connecting via Remote Desktop."
