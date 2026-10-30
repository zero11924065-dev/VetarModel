# VetarModel 架构节选 / Architecture Excerpt

本文说明本仓库实际公开的源码结构，帮助读者从通用组件理解 VetarModel 的部分设计方式。

This document describes the source files actually published in this repository. It is an architecture excerpt, not the complete application architecture or a buildable app package.

## 公开范围 / Scope

本仓库是 GPL-3.0 开源子集快照。公开内容集中在界面基础组件、显式导航、文本处理、日志与存储工具、设备状态抽象和训练界面辅助逻辑。

This repository is a GPL-3.0 open-source subset snapshot. Published code covers UI foundations, explicit navigation, text processing, logging and storage utilities, device-state abstraction, and training-UI support.

完整应用中的模型执行、训练管线、模型包导出、检索、账号授权、更新、运行时和私有构建配置不在本仓库公开。完整应用通过 Releases 提供安装包。

Model execution, training pipelines, model-package export, retrieval, account licensing, updates, runtime, and private build configuration are not published here. The complete app is distributed as an installer through Releases.

## 分层视图 / Layering

```text
Presentation / 表现层
├── UI/Theme             设计令牌与通用品牌组件
├── Views                通用视图与纯展示状态判断
└── Navigation           显式页面状态与导航动作

Interaction & Text / 交互与文本
├── Chat                 会话文本过滤与 Markdown 展示
├── Exploration          文本差异与本地事件日志
└── Training             与训练算法无关的界面辅助逻辑

Support / 支撑层
├── Core                 电源状态协议与系统实现
├── Account              通用日志脱敏，不含账号或授权实现
└── Utilities            版本、存储与日志清理工具
```

这些目录表示公开文件在产品中的逻辑归属，不代表各目录的全部实现均已公开。

These directories show the logical ownership of the published files; they do not imply that every implementation in those areas is public.

## 公开源码地图 / Published Source Map

| 目录 / Directory | 文件 / File | 职责 / Responsibility |
| --- | --- | --- |
| `UI/Theme` | `MTheme.swift` | 颜色、字号、圆角、阴影和动效令牌 |
| `UI/Theme` | `MCallout.swift` | 通用提示组件 |
| `UI/Theme` | `BrandComponents.swift` | 按钮、输入框、提示条、标签与弹窗基础组件 |
| `Views` | `FoldRow.swift` | 可折叠行视图 |
| `Views` | `KBActionBarAvailability.swift` | 根据最小状态摘要判断操作可用性 |
| `Navigation` | `RootNavigation.swift` | 用显式状态机管理页面、侧栏与向导 |
| `Chat` | `ChatTextFilter.swift` | 定稿和流式场景下移除思考段 |
| `Chat` | `ChatMarkdown.swift` | 会话文本的轻量 Markdown 渲染 |
| `Exploration` | `TextDiffer.swift` | 段落级文本差异、变更率与容量限制 |
| `Exploration` | `BackgroundLearningLog.swift` | 串行 JSONL 日志追加与有界截断 |
| `Training` | `TrainingParamStepperDebouncer.swift` | 可注入调度器的步进器防抖，不含训练算法 |
| `Core` | `PowerMonitor.swift` | 电源监控协议、IOKit 实现与可替换假实现 |
| `Account` | `LogSanitizer.swift` | 邮箱、令牌、长串和用户路径脱敏 |
| `Utilities` | `SemanticVersion.swift` | 严格的语义版本解析与比较 |
| `Utilities` | `AppVersion.swift` | 从 Bundle 读取版本和构建号 |
| `Utilities` | `StorageUsage.swift` | 存储分项、目录测量与字节格式化 |
| `Utilities` | `LogCleaner.swift` | 只删除白名单中的已知日志 |

## 设计方式 / Design Patterns

### 1. 纯逻辑与视图分离 / Pure logic separated from views

`KBActionBarAvailability`、`TextDiffer` 和 `StorageUsage` 不依赖完整应用状态。输入保持小型、明确，便于测试和复用。

Small state summaries and pure functions keep behavior independent from the full application state, making the code easier to test and reuse.

### 2. 用协议和注入替换系统依赖 / Replace system dependencies through protocols and injection

`PowerMonitoring` 将电源状态消费者与 IOKit 解耦；`TrainingParamStepperDebouncer` 通过注入调度器，将时间相关行为与具体队列分离。

`PowerMonitoring` decouples consumers from IOKit, while scheduler injection keeps debounce decisions independent from a concrete dispatch queue.

### 3. 显式导航状态 / Explicit navigation state

`RootNavigation` 将会话、模型管理、模型详情、探索知识库和设置表达为明确状态。点击与键盘导航汇入同一组动作，减少隐式绑定造成的分歧。

`RootNavigation` represents pages as explicit state. Pointer and keyboard navigation share the same actions, reducing divergence caused by implicit bindings.

### 4. 有界且防御性的本地处理 / Bounded, defensive local processing

日志按大小截断，文本差异片段按长度限制，版本解析拒绝不完整输入，日志脱敏按固定规则执行。这些组件体现了本地优先应用对可预测资源占用和数据边界的重视。

Bounded logs, capped diff fragments, strict version parsing, and deterministic log sanitization support predictable resource use and clear data boundaries.

## 三条公开数据流 / Three Public Data Flows

### 会话展示 / Chat presentation

```text
输入文本 → ChatTextFilter → ChatMarkdown → 视图展示
```

文本过滤与排版分为两个独立步骤；本仓库不包含文本生成或推理实现。

Filtering and formatting are separate steps. Text generation and inference are not part of this repository.

### 步进器持久化 / Stepper persistence

```text
连续 tick → Debouncer 合并 → flush / 到期 → 调用方提供的持久化回调
```

防抖器只决定何时回调，不知道具体设置存储或训练管线。

The debouncer decides when to emit a callback; it has no knowledge of settings storage or training pipelines.

### 文本变更 / Text changes

```text
旧文本 + 新文本 → TextDiffer → 差异片段 + 变更率 + 小改动标记
```

差异结果的后续存储和消费不在公开范围内。

Storage and consumption of the resulting fragments are outside the published subset.

## 构建说明 / Build Note

本仓库没有公开完整应用的 Package 配置、私有依赖或全部模块，因此不能独立构建为 VetarModel 应用。公开源码用于阅读、学习和复用；需要实际使用产品时，请下载 Releases 中的正式安装包。

This repository does not include the complete app's package configuration, private dependencies, or all modules. It cannot be built into the complete VetarModel app. Use the official installer in Releases for the actual product.
