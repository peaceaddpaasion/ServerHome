# Sub-tutorial 4: Installing Ubuntu 24.04 from Scratch — Bootable USB Creation Guide

> 🇨🇳 [中文版 (Chinese)](./04_ufsd_bootable_usb_guide.zh-CN.md)

Before running the one-click deployment script, you need to install a clean **Ubuntu 24.04 LTS (noble)** on your old computer. Here are some hardware and tooling tips from real-world experience that will dramatically improve the setup process:

## ⚡ Hardware Highlight: Strongly Recommend a UFSD Flash Drive

Don't use an old USB 2.0/3.0 flash drive to install the OS — the agonizingly slow random read/write speeds will make both writing the image and the installation itself a painful experience.

Spend a few dollars on a **UFSD flash drive (e.g., UFSD ii)**. It essentially puts an SSD inside a USB stick. Whether you're flashing the image or installing the OS on the old computer, you'll enjoy blazing-fast, near-instant performance.

## 🛠️ Rapid Flashing Tutorial (Rufus)

For Windows users, the lightest and most reliable tool for creating a bootable USB is undoubtedly **[Rufus](https://rufus.ie/en/)** (portable, no installation needed, clean and simple).

**Core steps in brief**:
1. Download the [Ubuntu 24.04 ISO image](https://ubuntu.com/download/desktop).
2. Run Rufus, plug in the UFSD drive, select the ISO, leave everything else at default, and click Start.
3. Plug the USB into the old computer, power it on and rapidly press `F12/F2/F8` (varies by motherboard) to open the boot menu, select USB boot, and do a clean install.

> 📖 **Detailed step-by-step guide**: If this is your first time installing an OS, refer to the official tutorial:  
> 👉 [Ubuntu Official: How to Create a Bootable USB Stick on Windows (Recommended)](https://ubuntu.com/tutorials/create-a-bootable-usb-stick-on-windows)

Once the OS is ready and you're online, head back to the [👉 Official Master Guide](./00_master_guide.md) and use our one-click script to give your old computer a new life as a server!
