# REA拆来看看

面向 Codex 的中文软件分析 Skill。它使用固定版本的 [REA](https://github.com/morluto/rea) 分析安装包和编译产物，也会在拿到完整源码时直接阅读源码，解释具体功能的入口、数据处理、状态变化、输出、证据和未知项。

本项目借鉴了[拆拆](https://github.com/hubooooooo/chaichai)面向初学者的中文表达和便捷入口，没有修改或冒充 REA 的分析内核。

## 安装

需要 Windows PowerShell、Git，以及 REA 支持的 Node.js：22.19+、24.11+ 或 26+。

```powershell
git clone https://github.com/w1076782811-hue/rea-chai-laikankan.git
Set-Location './rea-chai-laikankan'
& './scripts/install.ps1'
```

安装脚本会执行以下操作：

1. 根据 `package-lock.json` 安装 `rea-agents@6.4.0`，禁用依赖安装脚本并省略可选依赖。
2. 在 `~/.agents/skills/rea_chai_laikankan` 创建指向仓库的目录链接。
3. 保留 REA CLI 的原始参数和退出码，不修改 Codex 全局配置。

如果个人 Skill 目录中已经存在同名内容，脚本会停止，不会覆盖或删除原文件。

## 调用

重新打开 Codex 对话，然后发送：

```text
$REA拆来看看 分析 C:\Downloads\example.asar 的登录功能，说明入口、调用链、证据和可以借鉴的实现。
```

也可以使用自然语言触发：

```text
用 REA拆来看看分析这个 GitHub 项目的搜索功能，并说明怎样用于我的项目。
```

手动调用 CLI：

```powershell
& './scripts/rea.ps1' --version
& './scripts/rea.ps1' analyze-javascript-application '目标完整路径' --format json
```

## 能力范围

- 完整源码：直接阅读入口和相关模块，不先进行反编译。
- JavaScript、Electron、ASAR：使用 REA 的 JavaScript 应用分析。
- EXE、DLL、APK、.NET、网页运行行为：按目标选择相应路由；Ghidra、JDK、JADX、IDA、Chrome 等外部引擎需要单独准备。
- 输出：区分事实、推测和未知，并保留文件位置或 Evidence ID。

当前安装流程已经验证 JavaScript 静态分析入口。外部分析引擎是否可用取决于本机环境。

## 项目结构

```text
rea_chai_laikankan/
├── SKILL.md
├── agents/openai.yaml
├── assets/analysis_template.md
├── references/local_usage.md
├── scripts/install.ps1
├── scripts/rea.ps1
├── scripts/run_rea.mjs
├── package.json
└── provenance.json
```

## 来源与许可

- REA：核心分析工具，MIT License，固定运行版本为 6.4.0。
- 拆拆：交互与表达方式的参考，具体快照见 `provenance.json`。
- 本仓库的原创脚本和文档采用 MIT License。
