#!/bin/bash

# 1. Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt install -y /tmp/chrome.deb

# 2. Install Visual Studio Code (via .deb)
wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install -y /tmp/vscode.deb

# 3. Install OpenVPN
sudo apt install -y openvpn

# 4. Install LXTerminal
sudo apt install -y lxterminal

# 5. Get desktop directory
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
mkdir -p "$DESKTOP_DIR"

# 6. Google Chrome desktop shortcut
cat > "$DESKTOP_DIR/google-chrome.desktop" <<EOF
[Desktop Entry]
Name=Google Chrome
Exec=/usr/bin/google-chrome-stable
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

# 7. Visual Studio Code desktop shortcut
cat > "$DESKTOP_DIR/vscode.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Exec=code
Icon=vscode
Type=Application
Categories=Development;IDE;
Terminal=false
EOF

# 8. OpenVPN terminal launcher shortcut
cat > "$DESKTOP_DIR/openvpn.desktop" <<EOF
[Desktop Entry]
Name=OpenVPN Terminal
Exec=lxterminal --command "sudo openvpn --config /etc/openvpn/client.conf; exec bash"
Icon=utilities-terminal
Type=Application
Categories=Network;
Terminal=false
EOF

# 9. LXTerminal desktop shortcut
cat > "$DESKTOP_DIR/lxterminal.desktop" <<EOF
[Desktop Entry]
Name=LXTerminal
Exec=lxterminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
Terminal=false
EOF

# 10. Make all shortcuts executable
chmod +x "$DESKTOP_DIR"/*.desktop

echo "Done: Shortcuts created in $DESKTOP_DIR."
