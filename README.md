# mpv-lazy 配置备份

本仓库是 Windows 上 mpv-lazy（mpv 播放器整合包）的 `portable_config` 用户配置快照（解码/渲染选项、画质预设、uosc 界面、脚本、着色器、字幕字体、VapourSynth 补帧脚本等）。换新电脑时，clone 本仓库，按下文**手动步骤**把配置还原到 `D:\Tools\mpv-lazy\portable_config\`，即可恢复与旧机一致的播放行为和快捷键。

> 本仓库只包含 `portable_config` 配置，**不包含 mpv 程序本体**（`mpv.exe`、运行库、VS 插件与模型）。

---

## 前置要求

1. **已安装 mpv-lazy 到 `D:\Tools\mpv-lazy`**（路径必须是这个，配置文件里的相对路径与整合包结构依赖它）。
   - 获取途径：mpv-lazy 由 hooke007 维护，项目主页为 <https://github.com/hooke007/mpv_PlayKit>，请从该项目的说明/发布渠道下载完整整合包，解压到 `D:\Tools\mpv-lazy`。具体下载链接以该项目页面为准；若已按旧机位置放置过整合包，直接确认路径即可。
   - 判断标准：`D:\Tools\mpv-lazy\mpv.exe` 存在。
2. **还原前关闭 mpv**（含后台的 mpv.exe 进程），避免目标文件被占用导致复制失败。
3. **字体（随本仓库提供，无需单独下载）**：`portable_config/fonts/` 下含 `LXGWWenKaiMonoLite-Regular.ttf`（字幕字体 `LXGW WenKai Mono Lite`）、`MaterialIconsRound-Regular.otf`、`uosc_textures.ttf`（uosc 图标/纹理）。mpv 会自动加载该目录中的字体。
4. **着色器（随本仓库提供）**：`portable_config/shaders/` 下含 Adaptive_sharpen、Ani、Anime4K、EDI、FSRCNNX、QCOM 等 GLSL，无需额外处理。
5. **补帧 / AI 超分（依赖整合包本体，不在本仓库）**：`portable_config/vs/*.vpy` 依赖 mpv-lazy 整合包自带的 **VapourSynth 环境与 `k7sfunc` 模块**；AI 模型（如 RIFE、ArtCNN、ONNX 模型）需放在 `D:\Tools\mpv-lazy\vs-plugins\models\`（见 `vs/` 脚本内注释）。因此必须使用完整的 mpv-lazy 整合包，仅还原本仓库无法启用补帧/超分。脚本多为 N 卡（NV）/DML 专用版本，需对应显卡与环境。

---

## 还原步骤（AI 操作指引）

> **写给 AI 助手**：严格按顺序执行，每步先确认「期望结果」再进入下一步；任何一步与预期不符就**停下来向用户报告**，不要自行猜测或跳过。除特别说明外，命令均在 PowerShell 中执行。

### 步骤 1 — 检查 mpv-lazy 是否已安装

- **目的**：确认目标程序存在，避免把配置复制到错误/不存在的位置。
- **命令**：
  ```powershell
  Test-Path "D:\Tools\mpv-lazy\mpv.exe"
  ```
- **期望结果**：输出 `True`。
- **不满足时**：输出 `False` 说明未安装或路径不对。**停止操作**，请用户先从 mpv-lazy 官方渠道下载完整整合包并解压到 `D:\Tools\mpv-lazy`，确认 `mpv.exe` 存在后再继续（本仓库不含程序本体，无法代替安装）。

### 步骤 2 — 确认 mpv 未运行

- **目的**：避免文件被占用导致复制失败或配置被运行时覆盖。
- **命令**：
  ```powershell
  Get-Process mpv -ErrorAction SilentlyContinue
  ```
- **期望结果**：无任何输出（进程不存在）。
- **不满足时**：列出了 mpv 进程。请用户手动关闭 mpv 窗口；若用户确认可以强制结束，再执行 `Stop-Process -Name mpv -Force`，然后重跑本步骤确认已无输出。

### 步骤 3 — 备份目标目录现有配置（推荐，防丢）

- **目的**：原 `portable_config` 若已有改动，先留一份副本以便回退。
- **命令**（`$ts` 为时间戳）：
  ```powershell
  $ts = Get-Date -Format "yyyyMMdd-HHmmss"
  if (Test-Path "D:\Tools\mpv-lazy\portable_config") {
      Copy-Item "D:\Tools\mpv-lazy\portable_config" "D:\Tools\mpv-lazy\portable_config.bak-$ts" -Recurse -Force
      "已备份到 D:\Tools\mpv-lazy\portable_config.bak-$ts"
  } else {
      "目标目录不存在，将直接创建"
  }
  ```
- **期望结果**：提示已备份（生成 `portable_config.bak-<时间戳>`），或提示目标不存在。
- **不满足时**：报错多半是权限或路径问题，停下来报告。

### 步骤 4 — 把仓库配置复制到目标位置

- **目的**：将 `portable_config/` 的全部内容覆盖到 `D:\Tools\mpv-lazy\portable_config\`。
- **命令**（在**本仓库根目录**下执行；`$src` 指向仓库内的 `portable_config`）：
  ```powershell
  $src = Join-Path (Get-Location) "portable_config"
  $dst = "D:\Tools\mpv-lazy\portable_config"
  if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
  Copy-Item "$src\*" $dst -Recurse -Force
  ```
- **期望结果**：命令无报错返回。
- **说明**：此处是**覆盖复制**，只新增/覆盖文件，不会删除目标目录里本仓库没有的文件，安全。
- **不满足时**：报「文件被占用」回到步骤 2；报路径不存在回到步骤 1；其余报错原样报告给用户。

### 步骤 5 — 验证关键配置文件存在

- **目的**：确认复制完整，核心文件与目录都在位。
- **命令**：
  ```powershell
  $dst = "D:\Tools\mpv-lazy\portable_config"
  foreach ($f in "mpv.conf","profiles.conf","input_uosc.conf","input_contextmenu_plus.conf","script-opts.conf","saved-props.json") {
      "{0,-34} {1}" -f $f, (Test-Path (Join-Path $dst $f))
  }
  foreach ($d in "scripts","shaders","fonts","vs") {
      "{0,-34} {1}" -f "$d\", (Test-Path (Join-Path $dst $d))
  }
  ```
- **期望结果**：以上每一项均为 `True`。
- **不满足时**：某项为 `False`，说明步骤 4 复制不完整，检查源仓库 `portable_config/` 是否完整（`git status` 是否干净），再重做步骤 4。

### 步骤 6 — 启动验证

- **目的**：确认 mpv 能正常启动并加载配置。
- **命令**：
  ```powershell
  Start-Process "D:\Tools\mpv-lazy\mpv.exe"
  ```
- **期望结果**：mpv 正常打开、底部出现 uosc 控制界面；按 `Ctrl+1`~`Ctrl+5` 可切换画质预设（见 `input_uosc.conf`）。
- **不满足时**：若启动报错，先看 `mpv.conf` 中断言相关改动；需要日志时取消 `mpv.conf` 中 `#log-file = "~~desktop/mpv-lazy.log"` 的注释后重启，读取桌面日志再排查。

> **备选方式**：仓库根目录的 `restore.ps1` 可一键完成步骤 4 的复制（`.\restore.ps1`），但**不含**安装检查、进程检查与验证，仅作参考，正式还原以本手动流程为准。

---

## 还原后要做的事

1. **如需让 `mpv.conf` 中的 `volume` / `glsl-shaders` 改动生效**：删除 `D:\Tools\mpv-lazy\portable_config\saved-props.json`，再重启 mpv。
   - 原因：`mpv.conf` 顶部注释指出，当前预设下 `--volume`、`--glsl-shaders` 的关联属性被全局追踪记录（由 `save_global_props.lua` 写入 `saved-props.json`），不删除该缓存则改动不生效。当前该文件内容为 `{"volume":100,"mute":false}`。
2. **首次启用补帧 / AI 超分**：按 `Ctrl+1`~`Ctrl+4` 触发含 `vapoursynth` 的预设时，mpv 需构建 RIFE/超分引擎，耗时较长属正常；确保 `D:\Tools\mpv-lazy\vs-plugins\` 与模型文件齐全。
3. **确认字体生效**：字幕应使用 `LXGW WenKai Mono Lite`（`mpv.conf` 中 `sub-font`），uosc 图标正常显示。
4. **确认快捷键**：常用项见 `input_uosc.conf`（如 `Ctrl+1~5` 画质预设、`n` 自动对齐字幕、`,`/`.` 逐帧、`-`/`=` 调音量）。
5. **检查个人偏好项**：`mpv.conf` 中音频设备（`ao = wasapi`）、渲染设备（`d3d11-adapter` / `vulkan-device`）等被注释的项如含旧机显卡名，需按新机硬件调整（相关行当前均为注释状态）。

---

## 目录对照表

| 仓库内路径 | 目标路径 | 说明 |
|---|---|---|
| `portable_config/` | `D:\Tools\mpv-lazy\portable_config\` | 整个配置根目录，整体复制 |
| `portable_config/mpv.conf` | 同上 | 主配置：解码/渲染/OSD/字幕/截图 + 自定义画质预设（`Preset-*`） |
| `portable_config/profiles.conf` | 同上 | 情景配置组（速度上下限、自动置顶、自动同步、去色带、HDR 通用等） |
| `portable_config/input_uosc.conf` | 同上 | uosc 界面快捷键绑定 |
| `portable_config/input_contextmenu_plus.conf` | 同上 | 右键上下文菜单项定义 |
| `portable_config/script-opts.conf` | 同上 | 各脚本选项（控制台、统计、contextmenu_plus、save_global_props、thumbfast、uosc 等） |
| `portable_config/saved-props.json` | 同上 | 全局属性持久化（`volume`、`mute`），由 `save_global_props.lua` 维护 |
| `portable_config/scripts/` | 同上 | 用户脚本：`autoload.lua`、`autosubsync.lua`、`contextmenu_plus.lua`、`input_plus.lua`、`save_global_props.lua`、`thumbfast.lua`、`uosc/`（含 `uosc/bin/ziggy-windows.exe`） |
| `portable_config/shaders/` | 同上 | GLSL 着色器：`Adaptive_sharpen/`、`Ani/`、`Anime4K/`、`EDI/`、`FSRCNNX/`、`QCOM/` |
| `portable_config/fonts/` | 同上 | 字幕与界面字体：`LXGWWenKaiMonoLite-Regular.ttf`、`MaterialIconsRound-Regular.otf`、`uosc_textures.ttf` |
| `portable_config/vs/` | 同上 | VapourSynth 脚本（补帧 MEMC、降噪 NR、超分 SR 等），依赖整合包自带 VS 环境与模型 |
| `portable_config/_cache/` | 同上 | 运行时缓存，**不在仓库中**（见「备份范围」） |

---

## 备份范围

**包含**：
- `portable_config/` 下的全部配置与资源——配置文件（`mpv.conf`、`profiles.conf`、两个 `input_*.conf`、`script-opts.conf`、`saved-props.json`）、`scripts/`、`shaders/`、`fonts/`、`vs/`。

**排除 / 可不还原**：
- **mpv 程序本体与依赖**：`mpv.exe`、运行库、`vs-plugins/`、AI 模型等均不在仓库内，由 mpv-lazy 整合包提供。
- **`portable_config/_cache/`（运行时缓存）**：内含 `shader/`（GPU 着色器编译缓存）、`watch_later/`（播放位置记录）、命令历史等，mpv 会在首次运行时**自动重建**，与播放行为正确性无关，还原时可不复制。仓库**不跟踪**该目录（已写入 `.gitignore`，`backup.ps1` 导出时也会剔除）。

---

## 更新备份

当 mpv-lazy 配置发生变化（改画质预设、加脚本/着色器、改快捷键等）时，重新抓取并提交：

- **一键脚本**（仓库根目录 `backup.ps1`，会把 `portable_config` 复制到 `Backup\<时间戳>\`）：
  ```powershell
  .\backup.ps1
  ```
  注意：脚本输出到 `Backup/`，而 `Backup/` 已被 `.gitignore` 忽略，仅作本地存档；要更新仓库需再把内容放到 `portable_config/`。
- **手动同步（推荐用于更新仓库）**：
  ```powershell
  Copy-Item "D:\Tools\mpv-lazy\portable_config\*" ".\portable_config\" -Recurse -Force
  ```
  然后在仓库内 `git add -A && git commit -m "更新 portable_config 配置" && git push`。

---

## 注意事项

1. **mpv 版本兼容性**：配置中的选项（如 `vo = gpu-next`、`gpu-shader-cache-dir` 等）依赖 mpv-lazy 所用 mpv 版本。建议使用与备份时相同/相近的 mpv-lazy 版本，避免选项被新版弃用或改名。
2. **路径不可变**：整合包必须放在 `D:\Tools\mpv-lazy`，且音乐/视频以外的一切相对路径（`~~/shaders/...`、`~~/vs/...`、`~~/_cache/...`）都相对 `portable_config`，位置随意即可；但 `vs/` 脚本注释中提到的模型目录为整合包根下的 `vs-plugins/models/`，需保持整合包结构完整。
3. **着色器与缓存重建**：首次播放或首次使用新着色器时，mpv 需要重新编译 GLSL（`_cache/shader/`），会有一小段卡顿；VapourSynth 补帧/超分首次构建引擎更慢。这些缓存缺失不影响功能，mpv 会自动生成。
4. **字体**：请勿删除 `portable_config/fonts/` 内的字体，否则字幕会回退到系统字体、uosc 图标可能显示为方块。
5. **显卡相关选项**：`mpv.conf` 中 `d3d11-adapter`、`vulkan-device` 等按显卡名过滤的选项当前为注释；如旧机启用过，换机后需按新显卡名调整。`vs/` 下脚本区分 NV（NVIDIA）与 DML（DirectML）版本，需按新机显卡选择对应预设。
6. **还原是覆盖操作**：步骤 4 不会删除目标目录多余文件；如需完全干净还原，可先手工清空 `D:\Tools\mpv-lazy\portable_config`（**操作前先按步骤 3 备份**）。
7. **`saved-props.json` 的副作用**：它会记住 `volume`/`mute` 并覆盖 `mpv.conf` 中的初始值，需重置音量时删除该文件。
