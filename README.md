# 🚀 拯救吃灰旧电脑！Ubuntu 24.04 零门槛变身 7×24 个人服务器 (一键部署)

## 📌 摘要 / 导语
你是否有一台屏幕稀碎、电池老化的旧笔记本？不想装 Windows 忍受卡顿，想装 Ubuntu 做服务器，却被**合盖休眠**、**远程桌面黑屏**、**内网穿透**折腾到放弃？

本项目 **PersonalServer** 专为 **Ubuntu 24.04 (Noble)** 打造，提供一键自动化部署脚本。全程不碰复杂网络配置，完美避开 GNOME 与 XRDP 的冲突，让你只需一条命令，就能把旧笔记本改造成一台 **7×24 小时不休眠、双桌面随意连**的实用个人服务器！

---

## ✨ 核心解决的痛点 (Why PersonalServer?)

1. 🔋 **痛点一：笔记本合盖就休眠、断网？**
   - **本方案**：一键切换 `server` 模式，自动屏蔽所有休眠进程，修改 logind 配置，真正实现合盖 7×24 小时稳定运行。支持 WOL (局域网唤醒)。
2. 🖥️ **痛点二：Ubuntu 24.04 自带远程极其难用，XRDP 连上就黑屏？**
   - **本方案**：实测验证的最佳解法！采用 **XRDP + XFCE4 双桌面并发方案**。你不必注销主机的 GNOME 桌面，通过 RDP 客户端直接连接无冲突！
   - *注：XRDP 仅支持 Deb 应用，不支持 Snap；如有原生 GNOME 远程需求，也兼容提供说明。*
3. 🌐 **痛点三：内网穿透 / 折腾 Cloudflare Warp 太费神？**
   - **本方案**：自动完成依赖修复并安装**向日葵官方原版 Linux 客户端**，一条终端命令输出设备码，随时随地轻松远程。

---

## 🛠️ 安装环境与要求
- **系统限制**：严格限定 **Ubuntu 24.04 noble** (为了保证 100% 成功率，暂不兼容其他版本)。
- **网络限制**：纯净直连，脚本内已配置官方 `cz.archive.ubuntu.com` 优质源。
- **环境要求**：全新安装或尽量纯净的 Ubuntu 24.04 桌面版。

---

## 🚀 极速部署 (One-Line Install)

在你的 Ubuntu 24.04 终端中，执行以下命令获取并运行一键安装脚本：

```bash
# 下载部署脚本
wget https://raw.githubusercontent.com/peaceaddpaasion/first_personal_ubuntu_server/main/install.sh -O install.sh

# 赋予执行权限并以 root 运行
chmod +x install.sh
sudo ./install.sh
```
*(部署完成后，系统会自动配置好 7×24 模式、向日葵及 XRDP，并自动重启生效。)*

---

## 🎮 使用说明 (pserver 全局命令)

安装完成后，系统自动注入全局命令 `pserver`，极简命令行管理你的服务器状态：

| 命令 | 功能说明 |
| :--- | :--- |
| `pserver power server` | 开启 **7×24 服务器模式** (禁用所有休眠、合盖不休眠、开启WOL) |
| `pserver power host` | 恢复 **普通主机模式** (允许休眠，保留WOL) |
| `pserver check` | 运行系统自检 (检查电源、远程桌面等服务状态) |
| `pserver remote config` | 获取向日葵设备识别码及配置 |
| `pserver help` | 查看完整的使用帮助 |

---

## ⚠️ XRDP 远程桌面排坑指南 (必看)

由于 Ubuntu 24.04 的 Wayland/GNOME 架构变动，常规装法必报错。本脚本已为你搭好 **XFCE4 第二桌面**：
1. **如何连接？** Windows 用户直接可用系统自带的 `远程桌面连接 (mstsc)`，输入服务器 IP 即可。
2. **应用兼容性**：在 XRDP (XFCE4) 环境下，**不支持运行 Snap 打包的软件**（如 Ubuntu 预填装的 Firefox snap 版），请使用 `apt install` 安装传统的 deb 格式软件。
3. **原生需求**：如果你非要使用 Ubuntu 自带的 GNOME 远程，请务必先将当前物理机上的主用户**注销**，然后再连接。

---

## 🧹 卸载说明
不喜欢？一键无残留卸载，干干净净，恢复原本的系统休眠和配置环境：
```bash
wget https://raw.githubusercontent.com/peaceaddpaasion/first_personal_ubuntu_server/main/uninstall.sh -O uninstall.sh
chmod +x uninstall.sh
sudo ./uninstall.sh
```
