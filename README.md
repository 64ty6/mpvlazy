# mpv-lazy 配置备份

## 快速还原

```powershell
# 1. 下载 mpv-lazy 到 D:\Tools\mpv-lazy
# 2. 执行还原
.\restore.ps1
```

## 目录说明

```
portable_config/   → D:\Tools\mpv-lazy\portable_config\
```

| 文件/目录 | 说明 |
|-----------|------|
| `mpv.conf` | 主配置（解码/渲染/快捷键） |
| `profiles.conf` | 情景配置文件 |
| `input_uosc.conf` | uosc 快捷键 |
| `script-opts.conf` | 脚本选项 |
| `scripts/` | 用户脚本 |
| `shaders/` | GLSL 着色器 |
| `fonts/` | 字幕字体 |
