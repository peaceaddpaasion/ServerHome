#!/bin/bash
set -e

# PersonalServer — 一站式旧笔记本个人服务器部署
# 面向 Ubuntu 24.04 noble 专用
# 电源WOL + 向日葵远程 + XRDP双桌面远程 + 开机自检 + 自动重启

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

[ "$(id -u)" -ne 0 ] && echo -e "${RED}请使用 sudo 运行${NC}" && exit 1

clear
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}           PersonalServer 一键部署           ${NC}"
echo -e "${BLUE}          Ubuntu 24.04 noble 专用版          ${NC}"
echo -e "${BLUE}    电源WOL + 向日葵 + XRDP远程 + 自检重启    ${NC}"
echo -e "${BLUE}=============================================${NC}"

# 仅支持 24.04
. /etc/os-release
if [ "$VERSION_ID" != "24.04" ]; then
    echo -e "${YELLOW}⚠️  仅支持 Ubuntu 24.04，退出${NC}"
    exit 1
fi

CODENAME=noble
INSTALL_DIR="/usr/local/PersonalServer"
BIN_DIR="$INSTALL_DIR/bin"
CONF_DIR="$INSTALL_DIR/config"
mkdir -p $BIN_DIR $CONF_DIR

#===============================================================================
# 1. 配置你最终使用的官方 cz 源（严格复制你的格式）
#===============================================================================
echo -e "${GREEN}[1/7] 配置官方 cz 源 noble${NC}"
cat > /etc/apt/sources.list.d/ubuntu.sources <<EOF
Types: deb
URIs: http://cz.archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

apt update -qq

#===============================================================================
# 2. 基础依赖
#===============================================================================
echo -e "${GREEN}[2/7] 安装基础依赖${NC}"
apt install -y curl wget ethtool net-tools gnupg2 gpgv
apt -f install -y

#===============================================================================
# 3. 安装 libgconf-2-4（向日葵必需）
#===============================================================================
echo -e "${GREEN}[3/7] 安装 libgconf-2-4${NC}"
cd /tmp
wget -q https://mirrors.aliyun.com/ubuntu/pool/universe/g/gconf/gconf2-common_3.2.6-7ubuntu2_all.deb
wget -q https://mirrors.aliyun.com/ubuntu/pool/universe/g/gconf/libgconf-2-4_3.2.6-7ubuntu2_amd64.deb
dpkg -i gconf2-common_3.2.6-7ubuntu2_all.deb
dpkg -i libgconf-2-4_3.2.6-7ubuntu2_amd64.deb
apt -f install -y
rm -f gconf2-common*.deb libgconf-2-4*.deb

#===============================================================================
# 4. 电源管理（WOL + 7×24不休眠）
#===============================================================================
echo -e "${GREEN}[4/7] 部署电源管理(WOL)${NC}"

cat > $BIN_DIR/power <<'EOF'
#!/bin/bash
set -e
NIC=$(ip -br l | grep -v lo | grep 'UP' | awk '{print $1}' | head -1)
CONF="/usr/local/PersonalServer/config/power.conf"

enable_wol() {
  [ -z "$NIC" ] && return
  ethtool -s $NIC wol g
  cat >/etc/systemd/system/wol.service <<CONF
[Unit]
Description=WOL Service
After=network.target
[Service]
ExecStart=/usr/sbin/ethtool -s $NIC wol g
[Install]
WantedBy=multi-user.target
CONF
  systemctl daemon-reload
  systemctl enable --now wol.service
}

server() {
  systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
  sed -i 's/#HandleLidSwitch=ignore/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
  sed -i 's/#HandleLidSwitchExternalPower=ignore/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
  systemctl restart systemd-logind
  enable_wol
  echo "server" > $CONF
}

host() {
  systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
  enable_wol
  echo "host" > $CONF
}

sleep() {
  systemctl suspend
}

status() {
  echo "=== 电源状态 ==="
  echo "当前模式: $(cat $CONF 2>/dev/null || 未设置)"
  [ -n "$NIC" ] && ethtool $NIC | grep -A2 Wake-on
  echo "休眠服务: $(systemctl is-masked suspend.target)"
}

case "$1" in
  server|host|sleep|status) $1 ;;
  *) echo "用法：pserver power [server/host/sleep/status]" ;;
esac
EOF
chmod +x $BIN_DIR/power

#===============================================================================
# 5. 向日葵远程（官方原版）
#===============================================================================
echo -e "${GREEN}[5/7] 部署向日葵远程桌面${NC}"

cat > $BIN_DIR/remote <<'EOF'
#!/bin/bash
set -e

install() {
  echo "→ 下载向日葵官方客户端"
  wget -q -O /tmp/sunlogin.deb https://dl.oray.com/sunlogin/latest/SunloginClient_Linux_x64.deb
  dpkg -i /tmp/sunlogin.deb || apt -f install -y
  rm -f /tmp/sunlogin.deb

  sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
  systemctl restart gdm3
  systemctl enable --now sunlogin-daemon
}

config() {
  echo "=== 向日葵配置 ==="
  echo "1. 查看设备码"
  echo "2. 重启服务"
  read -p "选择: " sel
  case $sel in
    1) grep -A5 -B2 UID /etc/sunlogin/config.ini 2>/dev/null || echo "请先登录" ;;
    2) systemctl restart sunlogin-daemon && echo "已重启" ;;
  esac
}

status() {
  echo "=== 向日葵状态 ==="
  systemctl is-active sunlogin-daemon
  systemctl is-enabled sunlogin-daemon
}

case "$1" in
  install|config|status) $1 ;;
  *) echo "用法：pserver remote [install/config/status]" ;;
esac
EOF
chmod +x $BIN_DIR/remote

#===============================================================================
# 6. XRDP 远程桌面（你实测成功版 + 双桌面）
#===============================================================================
echo -e "${GREEN}[6/7] 部署 XRDP 远程桌面（需要RDP客户端）${NC}"

cat > $BIN_DIR/xrdp <<'EOF'
#!/bin/bash
set -e

# XRDP 安装（你实测成功版）
install() {
  echo "→ 安装 XRDP + XFCE4 双桌面（无需注销GNOME）"
  apt install -y xrdp xfce4 xfce4-goodies

  # 你实测成功的配置（关键！）
  sudo tee /etc/xrdp/startwm.sh > /dev/null << 'CONF'
#!/bin/sh
export GDK_BACKEND=x11
dbus-run-session -- xfce4-session
CONF

  chmod +x /etc/xrdp/startwm.sh
  systemctl restart xrdp
  systemctl enable xrdp

  echo -e "\n${GREEN}✅ XRDP 安装完成（XFCE4 第二桌面）${NC}"
  echo -e "${YELLOW}⚠️  说明：XRDP 不支持 Snap 应用，仅支持 Deb 应用${NC}"
  echo -e "${YELLOW}⚠️  说明：如需 GNOME 原生远程，请注销当前用户后再连接${NC}"
}

status() {
  echo "=== XRDP 状态 ==="
  systemctl is-active xrdp
  systemctl is-enabled xrdp
}

case "$1" in
  install|status) $1 ;;
  *) echo "用法：pserver xrdp [install/status]" ;;
esac
EOF
chmod +x $BIN_DIR/xrdp

#===============================================================================
# 7. 全局命令 pserver
#===============================================================================
echo -e "${GREEN}[7/7] 配置全局命令 pserver${NC}"

cat > /usr/local/bin/pserver <<'EOF'
#!/bin/bash
set -e
BIN=/usr/local/PersonalServer/bin

case "$1" in
  power) shift; $BIN/power "$@" ;;
  remote) shift; $BIN/remote "$@" ;;
  xrdp) shift; $BIN/xrdp "$@" ;;

  check)
    echo "===== 开机自检 ====="
    $BIN/power status
    echo
    $BIN/remote status
    echo
    $BIN/xrdp status
    echo "===================="
    ;;

  help)
    echo "PersonalServer 命令"
    echo "pserver power server    7×24服务器模式"
    echo "pserver power host      休眠+WOL模式"
    echo "pserver power sleep     立即休眠"
    echo
    echo "pserver remote install  安装向日葵"
    echo "pserver remote config   向日葵配置"
    echo
    echo "pserver xrdp install    安装XRDP（需RDP客户端）"
    echo "pserver xrdp status     XRDP状态"
    echo
    echo "pserver check           系统自检"
    echo "pserver help            帮助"
    ;;

  *)
    echo "未知命令，使用 pserver help"
    ;;
esac
EOF
chmod +x /usr/local/bin/pserver

#===============================================================================
# 开机自检服务
#===============================================================================
cat > /etc/systemd/system/pserver-check.service <<EOF
[Unit]
Description=PersonalServer 开机自检
After=network-online.target

[Service]
ExecStart=/usr/local/bin/pserver check

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable pserver-check.service

#===============================================================================
# 自动初始化 + 重启
#===============================================================================
echo -e "${GREEN}应用 7×24 服务器模式...${NC}"
pserver power server
pserver remote install
pserver xrdp install

echo -e "\n${GREEN}=============================================${NC}"
echo -e "${GREEN}✅ 部署完成，即将重启完成初始化${NC}"
echo -e "${GREEN}开机后自动执行自检${NC}"
echo -e "${GREEN}=============================================${NC}"

sleep 3
reboot
