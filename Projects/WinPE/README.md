# WinPE 示例项目

本项目为 WinPEBuilder 的示例项目，用于展示如何使用 WinPEBuilder 构建自定义的 Windows PE 环境。

## 项目概述

WinPE（Windows Preinstallation Environment）是一个轻量级的 Windows 操作系统，用于系统部署、故障排除和恢复。本项目提供了一个完整的 WinPE 构建示例，包含了系统精简、配置、Shell 定制、组件添加等功能。

## 项目结构

```
WinPE/
├── 00_Simplify/          # 系统精简
├── 01_Configures/        # 系统配置
│   ├── Build/           # 构建配置
│   ├── Loader/          # 启动加载器
│   └── System/          # 系统配置
├── 02_Shell/           # Shell 定制
├── 03_Components/      # 系统组件
├── 04_Drivers/        # 驱动程序
├── 05_Network/        # 网络组件
├── main.cmd           # 主入口文件
├── last.cmd           # 最后执行文件
└── README.md          # 项目说明
```
