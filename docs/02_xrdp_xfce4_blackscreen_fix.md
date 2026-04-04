# Sub-tutorial 2: XRDP Black Screen on Ubuntu 24.04 & the Dual-Desktop Isolation Solution

> 🇨🇳 [中文版 (Chinese)](./02_xrdp_xfce4_blackscreen_fix.zh-CN.md)

## The Problem: Why Does It Always Black Screen or Crash?

In Ubuntu 24.04, the default desktop environment uses the newer Wayland architecture with stricter D-Bus session isolation. This causes:

1. **Conflict**: If your physical machine is already logged into a GNOME desktop session, any attempt to connect via XRDP will conflict with the D-Bus and display permissions — resulting in a permanent black screen or immediate disconnect.
2. **Wayland incompatibility**: GNOME remote protocol requires disabling Wayland (`WaylandEnable=false`), but leaving the host in a permanently logged-out state is a terrible experience.
3. **Outdated tutorials don't work**: Many old guides tell you to manually set `DBUS_SESSION_BUS_ADDRESS` to a specific user ID, or modify `.xsession`. Tested on 24.04 — these all fail or crash immediately.

## The Best Solution: `dbus-run-session` Isolation + XFCE4 Lightweight Desktop

To achieve concurrent access (physical machine on GNOME + remote user connecting anytime), the cleanest approach is to **install XFCE4 as a second desktop** and use `dbus-run-session` to create a **fully isolated environment** at XRDP login time.

### How It Works

The core of our configuration is these two lines written into `/etc/xrdp/startwm.sh`:
```bash
export GDK_BACKEND=x11
dbus-run-session -- xfce4-session
```

1. **`export GDK_BACKEND=x11`**: Forces GTK apps to operate in X11 mode, ignoring Wayland (since RDP uses a traditional X protocol stream).
2. **`dbus-run-session`**: This is the key! It makes the XRDP connection **create a brand-new D-Bus daemon** for each session. This new session gets its own independent socket file (typically under `/run/user/$(id -u)/bus`) with freshly allocated permissions — like putting Xfce4 in a completely isolated "clean room". Even if the physical machine is running a GNOME gaming session, the remote XFCE4 session is completely unaffected.

### Limitations of Strong Isolation (Must Know)

Because this "clean room" isolation is very thorough, you must be aware of:

1. **Snap apps will not run**:
   Ubuntu now aggressively pushes Snap apps (e.g., the pre-installed Firefox, Chromium). Snap's sandbox mechanism depends heavily on CGroup and upper-level Systemd session management. Inside our `dbus-run-session` sub-environment, **Snap apps will 100% fail to launch!**
   **Workaround**: If you need a browser or other software, remove the Snap version and install traditional `.deb` format packages via `apt install`.

2. **Input method / clipboard issues**:
   This clean D-Bus session may not find `fcitx` or `ibus` input method frameworks, since they are typically bound to the physical machine's login flow.
   **Workaround**: If you really need to type extended CJK text in the remote desktop, you can inject `export GTK_IM_MODULE="fcitx"` before `dbus-run-session` in `startwm.sh` and manually launch the input method process. For typical "server admin" tasks, a standard English keyboard covers 99% of needs.

With this solution, your old laptop truly achieves **lid closed in the corner, connect anytime from anywhere, zero conflicts**! This is also the biggest technical highlight of the one-click script.
