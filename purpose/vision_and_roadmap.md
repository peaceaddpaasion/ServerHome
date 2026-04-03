# 🌟 项目愿景与路线图 (Vision & Roadmap)

## 🎯 About (项目宗旨)

> *How to create your server, with hardware like n100 or old laptop, even your virtual machine, and own a never shutdown Desktop Environment. It can work like a clouddisk with thrilling speed, turn your andorid device into expensive laptop(LOL). Be with you.*

教你如何利用 N100 迷你主机、闲置老旧笔记本，甚至一台虚拟机，打造一台属于你自己的微型服务器。

它能让你拥有一个 **7×24 小时永不休眠的私人桌面环境**，充当传输速度惊人的**极速云盘**，甚至能通过串流让你吃灰的廉价安卓设备**秒变昂贵的高配轻薄本**（笑）。

**PersonalServer，与你同在。**

---

## 🗺️ 发展计划 (Roadmap)

我们的终极目标是打造一个 All-in-One 的轻量级、无脑化的个人服务器基础设施。未来的版图将围绕三大核心支柱展开：

1. **🖥️ 稳定无感的远程桌面 (Remote Desktop) —— [当前重点]**
   - 解决极其复杂的网络层异地直连问题。
   - 解决多桌面环境并存、性能与兼容性的平衡，实现“主机有人用，远程单独开一桌”。
2. **🌐 互联互通的网关系统 (Gateway) —— [下一阶段]**
   - 简单稳妥的路由控制与端口转发规则。
   - 无缝的内网穿透进阶方案与安全访问访问控制。
3. **💾 数据主权的极速云盘 (Cloud Disk) —— [未来规划]**
   - 不再受制于商业网盘的龟速限速。
   - 通过千兆/2.5G 局域网和穿透，打造极致速度体验的私人数据多端同步中心。

---

## ⏳ 当前进度 (Progress)

记录我们在“捡垃圾折腾”道路上，从零到一的硬核填坑历程：

- [x] **需求调研**：梳理旧设备利用的三大痛点（合盖休眠、内网穿透、远程黑屏）。
- [x] **软件选择**：横向对比数十种方案，敲定“向日葵原版” + “XRDP(XFCE4)” + “原生 GNOME”的双轨技术栈。
- [x] **底层填坑**：死磕 Ubuntu 24.04 特性。写出完美的休眠拦截、修复 `libgconf-2-4` 历史依赖、破解 Wayland/D-Bus 会话隔离漏洞。
- [x] **v1.0 落地**：推出纯净安全、无门槛的 **完全体一键部署脚本 (`install.sh`)**。
- [x] **文档沉淀**：编写“官方一条龙通关指导”及底层周边硬核子教程体系。
- [ ] **v2.0 探索**：引入轻量级开源网关（Gateway）与私人云盘（Cloud Disk）的无脑自建方案...

> 欢迎任何人提供 Issue 和 PR，让废旧设备的余热榨取得更猛烈些！