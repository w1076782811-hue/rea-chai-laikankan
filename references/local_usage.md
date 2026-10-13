# 本地调用与排错

## 固定入口

在 Skill 根目录执行：

```powershell
& './scripts/rea.ps1' --version
& './scripts/rea.ps1' analyze-javascript-application --help
```

启动器使用当前系统中受支持的 Node.js 和仓库锁定的 REA 6.4.0，保留上游命令参数与退出码。首次使用前运行 `scripts/install.ps1`。

## 分析 JavaScript 或 Electron

目标必须来自当前用户请求，使用完整路径并加引号。只需要理解完整源码架构时，直接检索和阅读源码。

```powershell
& './scripts/rea.ps1' analyze-javascript-application '用户指定的完整目标路径' --format json > '用户指定的结果文件.json'
```

CLI 输出完整 Evidence 时，选择 `evidence_id`、`normalized_result` 中需要的部分、覆盖信息和 `limitations`，不要把完整文件直接塞入聊天。遇到错误时同时检查退出码以及 JSON 中的 `error` 或 `code`。

MCP 场景先确认真实工具 schema，再考虑 `detail: "summary"`。保留原连接中的 `parent_evidence_id`；不同 CLI 进程不共享内存会话。

工具示例与参数以 `node_modules/rea-agents/skills/reverse-engineer-anything/references/javascript-applications.md` 为准。不要把 MCP 参数猜成 CLI 选项，先查看命令帮助。

## 上游参考

基础路径：`node_modules/rea-agents/skills/reverse-engineer-anything/`

- 原生文件、包与 .NET：`references/native-and-artifacts.md`
- JavaScript 或 Electron：`references/javascript-applications.md`
- APK：`references/android-applications.md`
- 运行观察：`references/runtime-observation.md`
- 比较、未知项与验证：`references/evidence-workflows.md`

## 环境故障

只检查阻塞当前任务的能力。Ghidra、JDK、JADX、IDA、Chrome 等按任务使用已有环境；没有准备的引擎不得报为可用。工具包移动后无需修改 Skill，启动器会按自身位置寻找依赖。
