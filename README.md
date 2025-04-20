# Ubuntu 20.04 Remote Desktop Setup (with Japanese Input)

This repository provides scripts to quickly set up a fully functional remote desktop environment on **Ubuntu 20.04 LTS (Focal Fossa)** with:

- XRDP (Xvnc extended session)
- XFCE desktop
- Google Chrome
- Visual Studio Code
- Japanese input via fcitx + Mozc

> ⚠️ These scripts are intended **only for Ubuntu 20.04**.  
> They will not work as-is on Ubuntu 22.04 or later.

---

## 🛠️ How to Use

### 1. Prepare a fresh Ubuntu 20.04 virtual machine (e.g., on Hyper-V)

Make sure to install `git` first:

```bash
sudo apt update
sudo apt install git
```

### 2. Clone this repository

```bash
git clone https://github.com/Widthdom/ubuntu-setup.git
cd ubuntu-setup
```

### 3. Run XRDP + XFCE setup

```bash
chmod +x xrdp-xfce-setup.sh
bash xrdp-xfce-setup.sh
```

This will configure:
- XFCE as the desktop environment
- XRDP for remote desktop with extended session (Xvnc)
- Japanese input environment via fcitx

### 4. Install essential apps and configure shortcuts

```bash
chmod +x install-apps-and-shortcuts.sh
bash install-apps-and-shortcuts.sh
```

This installs:
- Google Chrome
- Visual Studio Code
- OpenVPN
- Japanese fonts
- Desktop shortcuts
- Proper fcitx environment variables and autostart (via `/etc/xrdp/startwm.sh`)

---

## 🈁 Enabling Japanese Input

After logging in via Remote Desktop (Xvnc session):

1. Launch `fcitx-configtool` from the application menu  
2. Click `+` and add `Mozc` to the input methods  
3. Move `Mozc` to the top  
4. Use `Ctrl + Space` to toggle input

---

## ✅ Result

After reboot, your Ubuntu 20.04 environment will support:

- Stable XRDP remote login
- GUI desktop with Chrome and VSCode
- Japanese text input via Mozc

---

## License

MIT (or modify as needed)
