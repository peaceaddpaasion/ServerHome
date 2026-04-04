# 子教程 2：Ubuntu 24.04 XRDP 远程桌面黑屏与隔离双桌面方案

## 痛点：为什么连上总是黑屏或闪退？
在 Ubuntu 24.04 中，系统的默认桌面环境采用了较新的 Wayland 架构及更严格的 D-Bus 会话隔离。这就导致了：
1. **冲突**：只要你的物理机关联登录了 GNOME 桌面，此时试图通过 XRDP 再次登录，D-Bus 和显示权限就会冲突，导致永远黑屏或一连就闪退。
2. **Wayland 不兼容**：GNOME 远程协议需要关闭 Wayland（`WaylandEnable=false`），但如果你不想让主机一直处于注销注销状态，这个体验极其糟糕。
3. **网传教程失效**：很多旧教程让你手动设置 `DBUS_SESSION_BUS_ADDRESS` 到特定的用户ID，或者修改 `.xsession`，经实测在 24.04 中统统失效甚至直接闪退崩溃。

## 最优解法：dbus-run-session 隔离 + XFCE4 轻量桌面
为了实现物理机用自带 GNOME（不注销），远程用户随时能连进去使用，最完美的方法是**安装 XFCE4 作为第二桌面**，并通过 `dbus-run-session` 在 XRDP 登录时创造一个**完全隔离的全新环境**。

### 原理分析

在我们的配置中，核心代码是这两句写进了 `/etc/xrdp/startwm.sh`：
```bash
export GDK_BACKEND=x11
dbus-run-session -- xfce4-session
```

1. **`export GDK_BACKEND=x11`**：强制告诉 GTK 应用，我们现在在 X11 下运作，别去碰 Wayland（因为 RDP走的是相对传统的 X 协议流程）。
2. **`dbus-run-session`**：这是精髓！它会让 XRDP 连接时，**直接创建一个全新的 D-Bus 守护进程**。这个新会话拥有独立的 socket 文件（通常分配在 `/run/user/$(id -u)/bus` 内），权限全新分配！这就像给 Xfce 造了一个完全没有外界干扰的“小黑屋”。你哪怕物理机还在 GNOME 里挂着游戏，远程连进来的 XFCE4 会话都不受影响。

### 强隔离带来的局限性（必须知道的坑）
因为这种“小黑屋”隔离隔离得很彻底，你必须注意以下几点：

1. **Snap 应用绝杀**：
   Ubuntu 现在强制推行 Snap 应用（例如预装的 Firefox、Chromium）。Snap 的沙盒机制依赖极其严格的 CGroup 和上层 Systemd 会话管理。在我们这套 `dbus-run-session` 的子环境中，**Snap 应用 100% 无法启动！**
   **对策**：如果需要浏览器或软件，请卸载 snap 版，统一使用 `apt install` 安装 deb 格式的应用程序。

2. **输入法/剪贴板问题**：
   这套干净的 D-Bus 会话可能找不到 fcitx 或 ibus 等中文输入法框架，因为它们往往绑定在物理机的登录流里。
   **对策**：如果远程桌面非要敲长时间中文，可以考虑后续继续通过修改 `startwm.sh`，在 `dbus-run-session` 前注入 `export GTK_IM_MODULE="fcitx"` 并手动唤起输入法进程。但在普通“服务器运维”场景中，纯英文键盘即可满足99%的操作。

通过这种方案，旧笔记本真正实现了**合盖放角落、随时随便连、完全不冲突**！这也是该一键脚本最大的技术亮点。