#!/bin/bash

# 1. Install required packages
sudo apt update
sudo apt install -y xdg-user-dirs openvpn xfce4-terminal fcitx-mozc fonts-noto-cjk

# 2. Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt install -y /tmp/chrome.deb

# 3. Install Visual Studio Code (Snap version)
sudo snap install code --classic

# 4. Create desktop shortcuts
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_DIR/google-chrome.desktop" <<EOF
[Desktop Entry]
Name=Google Chrome
Exec=/usr/bin/google-chrome-stable
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

cat > "$DESKTOP_DIR/vscode.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Exec=/snap/bin/code
Icon=code
Type=Application
Categories=Development;IDE;
Terminal=false
EOF

chmod +x "$DESKTOP_DIR"/*.desktop

# 5. Set fcitx as the default input method
im-config -n fcitx

# 6. Configure input environment for XRDP sessions
sudo tee /etc/xrdp/startwm.sh > /dev/null <<'EOF'
#!/bin/sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
fcitx-autostart > /dev/null 2>&1 &
echo "fcitx" > "$HOME/.config/im-config/env"
startxfce4
EOF

sudo chmod +x /etc/xrdp/startwm.sh

echo "Setup complete. Please log out and log in again via XRDP. Then launch fcitx-configtool and add Mozc."
