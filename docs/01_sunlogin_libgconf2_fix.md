# Sub-tutorial 1: Ultimate Fix for Missing `libgconf-2-4` Causing Sunlogin Install Failure on Ubuntu 24.04

> 🇨🇳 [中文版 (Chinese)](./01_sunlogin_libgconf2_fix.zh-CN.md)

## The Problem

When you try to install the official Sunlogin Linux client on Ubuntu 24.04, you'll typically encounter a dependency error reporting that `libgconf-2-4` is missing.

If you search [Ubuntu Packages](https://packages.ubuntu.com/search?keywords=libgconf-2-4), you'll find that this package **only goes up to `jammy` (22.04 LTS)** — it has been completely removed from Ubuntu 24.04 (`noble`)'s official repositories!

## The Wrong Approach (Warning)

Many people's first instinct is: **"Edit `/etc/apt/sources.list.d/ubuntu.sources` and force-add the jammy 22.04 source!"**

**Don't do this!**

Ubuntu 24.04 switched to the new `deb822` format for source configuration. Forcing a lower-version system source into it will not only trigger syntax errors like `universeSS`, but will also cause severe dependency conflicts during `apt update` and `apt upgrade`, potentially breaking core system components.

## The Working Solution: Cross-Version `.deb` Extraction & Manual Install

Since the 24.04 repository doesn't include this package, we download the `.deb` files directly from the 22.04 archive and install them via `dpkg`. This satisfies Sunlogin's requirements while keeping the APT source perfectly clean.

### Steps

Run these commands in your terminal in order:

```bash
# 1. Go to the temporary directory
cd /tmp

# 2. Download the 22.04 versions of gconf2-common and libgconf-2-4 from the official mirror
wget -q https://mirrors.aliyun.com/ubuntu/pool/universe/g/gconf/gconf2-common_3.2.6-7ubuntu2_all.deb
wget -q https://mirrors.aliyun.com/ubuntu/pool/universe/g/gconf/libgconf-2-4_3.2.6-7ubuntu2_amd64.deb

# 3. Force-install these legacy packages via dpkg
sudo dpkg -i gconf2-common_3.2.6-7ubuntu2_all.deb
sudo dpkg -i libgconf-2-4_3.2.6-7ubuntu2_amd64.deb

# 4. Fix any missing lower-level dependencies
sudo apt -f install -y

# 5. Clean up temp files
rm -f gconf2-common*.deb libgconf-2-4*.deb
```

After this, you can install the Sunlogin client from the official source without issues:
```bash
wget -q -O /tmp/sunlogin.deb https://dl.oray.com/sunlogin/latest/SunloginClient_Linux_x64.deb
sudo dpkg -i /tmp/sunlogin.deb || sudo apt -f install -y
```

> **Summary**: Installing a downgraded dependency directly is far safer than "polluting the APT source". This is also the standard approach used in the `install.sh` script of this project!
