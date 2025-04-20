#!/bin/bash

# 1. Install dependencies
sudo apt update
sudo apt install -y xdg-user-dirs openvpn xfce4-terminal

# 2. Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt install -y /tmp/chrome.deb

# 3. Install Visual Studio Code (Snap version)
sudo snap install code --classic

# 4. Get desktop directory
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
mkdir -p "$DESKTOP_DIR"

# 5. Google Chrome desktop shortcut
cat > "$DESKTOP_DIR/google-chrome.desktop" <<EOF
[Desktop Entry]
Name=Google Chrome
Exec=/usr/bin/google-chrome-stable
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

# 6. Visual Studio Code desktop shortcut
cat > "$DESKTOP_DIR/vscode.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Exec=/snap/bin/code
Icon=code
Type=Application
Categories=Development;IDE;
Terminal=false
EOF

# 7. Make all shortcuts executable
chmod +x "$DESKTOP_DIR"/*.desktop

echo "Setup complete. Shortcuts have been created in $DESKTOP_DIR."

# 8. Install Japanese IME (fcitx-mozc)
sudo apt install -y fcitx-mozc fonts-noto-cjk

# 9. Set environment variables for fcitx
if ! grep -q "fcitx" ~/.xprofile 2>/dev/null; then
cat >> ~/.xprofile <<EOF
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF
fi

echo "Japanese input environment installed. You may need to log out and log back in for input method to take effect."
