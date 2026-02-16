# nanobar-objc

72 行 Objective-C 实现的极简 macOS 菜单栏管理器。一键隐藏/显示菜单栏图标。

这是 [nanobar](https://github.com/yansircc/nanobar)（Rust 版）的原生 ObjC 移植。二进制仅 ~53KB（Rust 版 ~470KB）。

## 工作原理

菜单栏出现一个可点击的箭头（`›`）。左键点击通过一个不可见的占位 status item 把其他图标推出屏幕来切换显隐。右键弹出退出菜单。

- 后台守护进程运行（fork + setsid）
- PID 文件实现单实例保护（`/tmp/nanobar.pid`）
- 无第三方依赖，仅需 Cocoa 框架

## 编译 & 安装

```bash
make            # 编译 ./nanobar
make install    # 安装到 /usr/local/bin
```

## 使用

```bash
nanobar         # 启动（自动后台运行）
nanobar --help  # 显示版本
```

## 许可证

MIT
