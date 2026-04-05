# 🚀 Revive Your Old Laptop! Ubuntu 24.04 → Personal Server 24/7 (One-Line Deploy)

> 💡 **About PersonalServer:**  
> *How to create your server, with hardware like n100 or old laptop, even your virtual machine, and own a never-shutdown Desktop Environment. It can work like a cloud disk with thrilling speed, turn your Android device into an expensive laptop (LOL). Be with you.*  
> 👉 [View: Project Vision, Long-term Goals & Roadmap](./purpose/vision_and_roadmap.md)

> 🇨🇳 [中文文档 (Chinese README)](./README.zh-CN.md)

## 📌 Overview

Got an old laptop with a cracked screen or dead battery? Don't want Windows but struggled to set up Ubuntu as a server due to **lid-close sleep**, **remote desktop black screen**, or **network tunneling** nightmares?

**PersonalServer** is built specifically for **Ubuntu 24.04 (Noble)**. It provides a one-line automated deployment script — no complex network configuration, no GNOME/XRDP conflicts. With a single command, turn that old laptop into a **24/7 always-on, dual-desktop personal server**!

---

## ✨ Problems Solved (Why PersonalServer?)

1. 🔋 **Problem 1: Laptop sleeps or disconnects when you close the lid?**
   - **Our solution**: One-click switch to `server` mode — automatically blocks all sleep processes, patches `logind` config, enables true 24/7 stable operation with lid closed. Wake-on-LAN (WOL) supported.

2. 🖥️ **Problem 2: Ubuntu 24.04 remote desktop is a mess — XRDP always gives a black screen?**
   - **Our solution**: Battle-tested best approach! Uses **XRDP + XFCE4 dual-desktop concurrent scheme**. No need to log out of the host GNOME desktop — connect via RDP with zero conflicts!
   - *Note: XRDP supports only `.deb` apps, not Snap. Native GNOME remote is also documented.*

3. 🌐 **Problem 3: Network tunneling / Cloudflare Warp is too complicated?**
   - **Our solution**: Automatically fixes dependencies and installs the **official Sunlogin Linux client**. One terminal command outputs the device code — remote access from anywhere, effortlessly.

---

## 📖 Official Step-by-Step Deployment Guide

New users should start with our [**👉 Official Master Guide**](./docs/00_master_guide.md), which walks through the entire deployment and decision flow!

For deeper technical reading:
- 📙 [Hardware Tip: UFSD Flash Drive for Blazing-Fast OS Installation](./docs/04_ufsd_bootable_usb_guide.md)
- 📕 [Dependency Fix: Solving the Missing `libgconf-2-4` Error for Sunlogin](./docs/01_sunlogin_libgconf2_fix.md)
- 📗 [Remote Deep-Dive: XRDP Black Screen Root Cause & XFCE4 Dual-Desktop Isolation](./docs/02_xrdp_xfce4_blackscreen_fix.md)
- 📘 [Design Choice: Why Add XFCE4 When Native GNOME Remote Already Works?](./docs/03_native_gnome_rdp_vs_xfce4.md)

---

## 🛠️ Requirements

- **OS**: Strictly **Ubuntu 24.04 noble** (locked to this version to guarantee 100% success rate).
- **Network**: Clean direct connection. The script is pre-configured to use the official `cz.archive.ubuntu.com` mirror.
- **Environment**: A fresh or near-clean Ubuntu 24.04 Desktop installation.

---

## 🚀 One-Line Install

Run the following in your Ubuntu 24.04 terminal:

```bash
# Download the deployment script
wget https://raw.githubusercontent.com/peaceaddpaasion/first_personal_ubuntu_server/main/install.sh -O install.sh

# Grant execute permission and run as root
chmod +x install.sh
sudo ./install.sh
```
*(After deployment completes, the system automatically configures 24/7 mode, Sunlogin, and XRDP, then reboots.)*

---

## 🎮 Usage (pserver Global Command)

After installation, the global command `pserver` is injected automatically — manage your server state from the command line:

| Command | Description |
| :--- | :--- |
| `pserver power server` | Enable **24/7 Server Mode** (disable all sleep, lid-close safe, enable WOL) |
| `pserver power host` | Restore **Normal Host Mode** (allow sleep, keep WOL) |
| `pserver check` | Run system health check (power, remote desktop, service status) |
| `pserver remote config` | Get Sunlogin device code and configuration |
| `pserver help` | Show full help |

---

## ⚠️ XRDP Remote Desktop Notes (Must Read)

Due to Ubuntu 24.04's Wayland/GNOME architecture changes, standard setups will fail. This script sets up a dedicated **XFCE4 second desktop** for you:

1. **How to connect?** Windows users can use the built-in `Remote Desktop Connection (mstsc)` — just enter the server IP.
2. **App compatibility**: Under XRDP (XFCE4), **Snap-packaged apps are not supported** (e.g., the pre-installed Firefox snap). Use `apt install` to install traditional `.deb` format software instead.
3. **Native GNOME remote**: If you must use Ubuntu's built-in GNOME remote, be sure to **log out** the current physical user first before connecting remotely.

---

## 🧹 Uninstall

Want to remove everything? One command — clean uninstall, restores original sleep settings and environment:

```bash
wget https://raw.githubusercontent.com/peaceaddpaasion/first_personal_ubuntu_server/main/uninstall.sh -O uninstall.sh
chmod +x uninstall.sh
sudo ./uninstall.sh
```
