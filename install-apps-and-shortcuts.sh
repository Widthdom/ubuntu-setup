#!/bin/bash

# 1. Install required packages
sudo apt update
sudo apt install -y xdg-user-dirs openvpn

# 2. Set xfce4-terminal as the default terminal emulator for file manager actions like "Open Terminal Here"
mkdir -p ~/.config/xfce4
cat <<EOF > ~/.config/xfce4/helpers.rc
TerminalEmulator=xfce4-terminal
EOF

# 3. Set gedit as the default text editor for plain text files
xdg-mime default gedit.desktop text/plain

# 4. Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt install -y /tmp/chrome.deb

# 5. Install Visual Studio Code (Snap version)
sudo snap install code --classic

# 6. Create desktop shortcuts
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_DIR/xfce-terminal.desktop" <<EOF
[Desktop Entry]
Name=Xfce Terminal
Exec=xfce4-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
Terminal=false
EOF

cat > "$DESKTOP_DIR/gedit.desktop" <<EOF
[Desktop Entry]
Name=Text Editor
Exec=/usr/bin/gedit   
Icon=org.gnome.gedit
Type=Application
Categories=Utility;TextEditor;
Terminal=false
EOF

cat > "$DESKTOP_DIR/remmina.desktop" <<EOF
[Desktop Entry]
Name=Remote Desktop
Exec=/usr/bin/remmina
Icon=org.remmina.Remmina
Type=Application
Categories=Network;
Terminal=false
EOF

cat > "$DESKTOP_DIR/firefox.desktop" <<EOF
[Desktop Entry]
Name=Firefox
Exec=/usr/bin/firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

cat > "$DESKTOP_DIR/google-chrome.desktop" <<EOF
[Desktop Entry]
Name=Google Chrome
Exec=/usr/bin/google-chrome-stable
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOF

cat > "$DESKTOP_DIR/visual-studio-code.desktop" <<EOF
[Desktop Entry]
Name=Visual Studio Code
Exec=/snap/bin/code
Icon=/snap/code/191/usr/share/code/resources/app/resources/linux/code.png
Type=Application
Categories=Development;IDE;
Terminal=false
EOF

chmod +x "$DESKTOP_DIR"/*.desktop

# 7. Set fcitx as the default input method
im-config -n fcitx

# 8. Configure input environment for XRDP sessions
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

echo "Setup complete."