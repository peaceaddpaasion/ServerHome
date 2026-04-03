#!/bin/bash
set -e

echo "卸载 PersonalServer..."

systemctl stop wol.service sunlogin-daemon xrdp pserver-check || true
systemctl disable wol.service sunlogin-daemon xrdp pserver-check || true

rm -rf /usr/local/PersonalServer
rm -f /usr/local/bin/pserver
rm -f /etc/systemd/system/wol.service
rm -f /etc/systemd/system/pserver-check.service

apt remove -y sunloginclient xrdp xfce4* || true
apt autoremove -y

sed -i 's/HandleLidSwitch=ignore/#HandleLidSwitch=ignore/' /etc/systemd/logind.conf || true
sed -i 's/HandleLidSwitchExternalPower=ignore/#HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf || true
systemctl restart systemd-logind || true

echo "✅ 卸载完成"
