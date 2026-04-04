# 🗺️ PersonalServer — Official Step-by-Step Deployment & Troubleshooting Guide

Welcome to the complete world of **PersonalServer**!
This guide walks you step-by-step through transforming a dusty old laptop into a rock-solid Ubuntu 24.04 personal server running 24/7. Every step has been battle-tested. Follow the phases in order.

> 🇨🇳 [中文版指南 (Chinese)](./00_master_guide.zh-CN.md)

---

## 📍 Phase 1: Environment Preparation (Starting from Scratch)

Before anything else, you need:

1. **An old laptop** (broken screen, swollen battery removed — doesn't matter).
2. **A fresh install of Ubuntu 24.04 LTS (noble)** Desktop (the script is strictly tied to this version).
   * 💡 **Pro tip**: Use a high-speed **UFSD flash drive** to make the bootable USB — costs a few dollars, but gives SSD-level read/write speeds during installation. See [Boot Drive & UFSD](./04_ufsd_bootable_usb_guide.md).
   If you already know how to flash a system, skip this.
3. Connect the laptop to your home router (wired is best; Wi-Fi also works).
4. Log in to your admin account on the physical machine and open a Terminal.

---

## 📍 Phase 2: One-Line Rapid Deployment (Core)

No need to hunt for scattered tutorials — we've bundled all core components (mirror config, dependency fixes, sleep blocking, Sunlogin, XRDP) into one script.

Run this in your terminal:
```bash
wget https://raw.githubusercontent.com/peaceaddpaasion/first_personal_ubuntu_server/main/install.sh -O install.sh
chmod +x install.sh
sudo ./install.sh
```
> ☕ **Grab a coffee**: The script will automatically switch to the official `cz` mirror, fix the cross-version Sunlogin dependency, and build the full remote and power management environment. The machine will reboot automatically when done.

---

## 📍 Phase 3: Choose Your Remote Desktop Setup (Key Decision)

After reboot, how will you connect remotely? This is the biggest pitfall area of Ubuntu 24.04. We provide two paths — choose based on your use case:

### 👉 Path A: Native GNOME Remote (Recommended for Beginners, Best Compatibility)
If this laptop will sit in a corner and you'll **never touch its physical keyboard or screen again**:
1. After reboot, log in physically and enable the built-in "Remote Desktop" in system Settings.
2. **Key step**: On the physical machine, click the top-right menu and select **"Log Out"**.
3. From your Windows PC, open `mstsc` and connect by IP.
4. **📖 Further reading**: [Why log out? Understanding GNOME native remote and single-session limits](./03_native_gnome_rdp_vs_xfce4.md).

### 👉 Path B: XRDP + XFCE4 Dual-Desktop Concurrent (Advanced, Maximum Performance)
If someone at home occasionally uses the physical screen while you still need to remote in, or if GNOME's memory usage is too high:
1. Don't log out on the physical machine — leave it running in the background.
2. From Windows, connect via `mstsc` — you'll land directly in the **XFCE4 lightweight second desktop** the script set up. The two sessions won't interfere at all!
3. **🔥 Known limitation**: Due to strong permission isolation, **Snap apps cannot run** (e.g., the default Firefox).
4. **📖 Further reading**: [Deep Dive: XRDP black screen root cause & XFCE4 isolated environment explained](./02_xrdp_xfce4_blackscreen_fix.md).

---

## 📍 Phase 4: External Network Access (Auto Remote Tunneling)

When you're at work, how do you connect back to your home PersonalServer?
No need to mess with FRP or Cloudflare Warp — the script has already configured the widely-used **Sunlogin official Linux client**.

* Just type in terminal: `pserver remote config` to view your Sunlogin device code. Bind it from your phone or work computer and you're done.
* **📖 Further reading**: [How the dependency was fixed: rescuing `libgconf-2-4` across Ubuntu versions](./01_sunlogin_libgconf2_fix.md).

---

## 📍 Phase 5: Power Policy Management (Lid-Close Without Sleep)

A standard laptop sleeps and disconnects when you close the lid — but we want a 24/7 server.

* At the end of installation, the script automatically runs `pserver power server`, permanently blocking all sleep processes.
* Go ahead — close the lid and tuck it under the couch or in a cable closet!
* If you ever want to use it as a normal laptop again, run `pserver power host` to re-enable sleep.

---

## 📍 Phase 6: Day-to-Day Operations

We provide a handy global command tool `pserver`. When you're unsure about system status:
```bash
pserver check
```
It outputs:
1. Current power and sleep service interception status.
2. Wake-on-LAN (WOL) activation status for your network interface.
3. Sunlogin daemon running status.
4. XRDP service running status.

As long as all four show green, your mini personal server is online and ready to serve!
