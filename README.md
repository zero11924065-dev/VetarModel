🌐 [官网 VetarAI.com](https://vetarai.com) ｜ ⬇️ [下载 Download](https://github.com/zero11924065-dev/VetarModel/releases/latest/download/VetarModel-0.8.15.dmg) ｜ [联系 Contact](#-联系我--反馈)

> **测试阶段 / Testing stage：** VetarModel 仍处于测试阶段，功能、性能与兼容性可能随版本变化，欢迎试用与反馈。公开测试数据及局限见 [测试数据](#测试数据--test-data)。
>
> VetarModel is still in testing. Features, performance and compatibility may change between versions; feedback is welcome. See [Test Data](#测试数据--test-data) for published results and limitations.

# VetarModel — 本地模型训练 × 模型养成 × 会话验证

# VetarModel — On-Device Model Training × Personal Model Growth × Chat & Evaluation

**建立独属于你的可成长模型。** VetarModel 是一款运行在 Mac 上的本地模型训练与管理应用：在本机准备学习材料、训练模型，并通过会话与能力验证了解训练效果。训练材料、知识库与模型保存在你的电脑上。

**Build your own scalable model.** VetarModel is a Mac app for on-device model training and management: prepare learning materials locally, train your model, and review progress through chat and capability evaluation. Training materials, knowledge and models stay on your Mac.

当前版本 / Current version：**v0.8.15**（macOS 14.0+ · DMG）

> 本仓库是 VetarModel 的开源子集快照，公开源码采用 GPL-3.0；完整应用安装包通过本仓库 Releases 提供。
>
> This repository is an open-source subset snapshot of VetarModel, licensed under GPL-3.0. The full-app installer is available through this repository's Releases.

## 💡 为什么做 VetarModel：痛点与解法

| 痛点 | VetarModel 的解法 |
| --- | --- |
| 训练资料不想交给云端 | 本地优先：训练材料、知识库与模型保存在本机 |
| 已有文档，希望模型直接学习 | 自主模式：选择文件或文件夹，作为模型学习材料 |
| 没有现成材料，整理资料成本高 | 训练模式：使用本地教师模型生成学习材料 |
| 希望模型跟随日常工作持续成长 | 探索模式：在获得系统授权后，从文档的打开与修改中持续学习 |
| 长时间训练难以管理 | 支持暂停、继续、提前结束、训练强度调整与训练守护 |
| 模型答错，训练效果难以判断 | 支持会话纠错、纠错训练与能力验证 |

## 💡 Why VetarModel: Pain Points & Solutions

| Pain point | The VetarModel solution |
| --- | --- |
| Keep training materials away from the cloud | Local-first storage for training materials, knowledge and models |
| Train directly from existing documents | Self-directed mode learns from selected files and folders |
| Prepare materials when none are available | Training mode generates learning materials with a local teacher model |
| Let a model grow with everyday work | Exploration mode learns from document activity and changes after system authorization |
| Manage long-running training | Pause, resume, stop early, adjust training intensity and use training safeguards |
| Correct answers and evaluate outcomes | Chat corrections, correction training and capability evaluation |

## 🧩 核心能力一览

### 模型创建与个性化

- **新建模型向导**：设置名称、简介、主要用途、模型类型与身份设定。
- **两种训练起点**：基于现有底座继续训练，或从零开始创建模型。
- **本机推荐**：根据 Mac 内存提供模型规模、精度、训练方式与记忆容量的推荐组合。

### 三种学习方式

- **自主模式**：把选定的文件或文件夹作为学习材料。
- **训练模式**：由本地教师模型生成教材，再用于模型训练。
- **探索模式**：在获得辅助功能与文件访问授权后，持续学习文档变化，并管理探索知识库。

### 训练与持续养成

- **轻量微调与全量微调**：按模型目标、设备条件与时间成本选择训练方式。
- **训练进度管理**：支持暂停、继续、提前结束与进度保存。
- **训练强度调整**：提供全速、均衡与夜间三种选择。
- **训练守护**：提供异常告警、停车保护与训练状态提示。
- **纠错与升档**：通过纠错训练持续改进模型，并在升档时延续已有学习成果。

### 会话、验证与模型管理

- **本地会话**：直接与自己训练的模型对话。
- **能力验证**：通过小测验了解训练效果。
- **模型管理**：管理多个模型、训练进度与版本历史。

## 🧩 Core Capabilities

### Model Creation & Personalization

- **Guided model creation**: set the name, summary, purpose, type and identity.
- **Two starting points**: train from an existing base or start from scratch.
- **Device-aware recommendations**: suggested model scale, precision, training method and memory capacity based on Mac memory.

### Three Learning Modes

- **Self-directed mode**: learn from selected files and folders.
- **Training mode**: generate learning materials with a local teacher model.
- **Exploration mode**: learn continuously from document changes after accessibility and file-access authorization, with a local exploration knowledge base.

### Training & Continuous Growth

- **Lightweight and full fine-tuning**: choose according to model goals, device capacity and time budget.
- **Progress controls**: pause, resume, stop early and preserve training progress.
- **Training intensity**: Full Speed, Balanced and Night modes.
- **Training safeguards**: anomaly alerts, parking protection and clear training-state feedback.
- **Corrections and scale upgrades**: improve through correction training and carry learning outcomes into larger model tiers.

### Chat, Evaluation & Model Management

- **On-device chat**: talk directly with models trained on your Mac.
- **Capability evaluation**: review training outcomes through short evaluations.
- **Model management**: manage multiple models, training progress and version history.

## 测试数据 / Test Data

本节选择性公开两组有代表性的研发实验，不是完整榜单或独立第三方横评。为避免只展示有利结果，本节同时保留不利读数、实验边界与未测项目。

This section selectively publishes two representative research experiments. It is not a comprehensive leaderboard or an independent third-party benchmark. Unfavorable results, scope limits and untested cases are retained alongside favorable results.

两组实验的模型、任务与统计口径不同，表格之间不可直接比较，也不能外推为对所有硬件、模型或使用场景的领先。公开文件仅包含聚合数值，不包含原始语料、用户材料、问答内容、模型或训练资产。

The two experiments use different models, tasks and metrics. Do not compare across the tables or generalize the results to every device, model or workload. Only aggregate values are published; raw corpora, user materials, questions and answers, models and training assets are not included.

### 1. 词表效率：与 Qwen3 通用词表对照

**观察重点：** 在这组实验中，VetarModel 的 `48k-zh80` 研究配置提高了中文与结构化文本的字／词元效率；英文维基和用户笔记体则低于 Qwen3 基线。

前四项指标单位为**字／词元，越高越好**；最后一项为按中文字／词元推算的 32K 窗口装载量，并非对完整应用可用上下文的承诺。

| 指标 | Qwen3 词表（151,669） | VetarModel `48k-zh80` 研究配置 | 相对变化 |
| --- | ---: | ---: | ---: |
| 中文维基（字／词元） | 1.3569 | **1.7701** | **+30.5%** |
| 英文维基（字／词元） | **4.0081** | 3.6787 | −8.2% |
| 用户笔记体（字／词元） | **1.3583** | 1.2431 | −8.5% |
| 结构化 CSV／JSON（字／词元） | 1.4309 | **1.7437** | **+21.9%** |
| 32K 窗口推算中文字数 | 44,462 | **58,002** | **+30.5%** |

#### 实验口径与边界

- 日期：2026-10-06。
- 基线为 Qwen3 代分词器，词表大小 151,669；对照项为 48,000 词表的 byte-level BPE 研究配置，训练中英文语料配比约为 8:2。
- 中文语料来自中文维基百科 20231101 分片，许可证为 CC BY-SA 4.0；中文训练集与留出集不相交，英文维基留出集为 6,335 条。
- 用户笔记体为小样本评估桶，约 1.5 万字符，不能据此推断所有笔记或真实用户语料的表现。
- 该实验衡量**分词效率**，不衡量回答质量、推理能力或模型准确率。
- `48k-zh80` 是研究配置，不代表当前所有 VetarModel 模型均采用此配置。

聚合数据：[tokenizer-efficiency.csv](docs/data/tokenizer-efficiency.csv)。

### 1. Tokenizer Efficiency: Qwen3 Baseline Comparison

**What to read:** In this experiment, the VetarModel `48k-zh80` research configuration improved character-per-token efficiency on Chinese and structured text, while trailing the Qwen3 baseline on English Wikipedia and the user-note sample.

The first four metrics are **characters per token; higher is better**. The final row is an estimated 32K-window Chinese character capacity derived from the Chinese ratio, not a promise of usable context in the complete app.

| Metric | Qwen3 tokenizer (151,669) | VetarModel `48k-zh80` research configuration | Relative change |
| --- | ---: | ---: | ---: |
| Chinese Wikipedia (characters/token) | 1.3569 | **1.7701** | **+30.5%** |
| English Wikipedia (characters/token) | **4.0081** | 3.6787 | −8.2% |
| User-note sample (characters/token) | **1.3583** | 1.2431 | −8.5% |
| Structured CSV/JSON (characters/token) | 1.4309 | **1.7437** | **+21.9%** |
| Estimated Chinese characters in a 32K window | 44,462 | **58,002** | **+30.5%** |

#### Method and limits

- Experiment date: 2026-10-06.
- The baseline is a Qwen3-generation tokenizer with 151,669 entries. The comparison is a 48,000-entry byte-level BPE research configuration trained with an approximately 8:2 Chinese-to-English corpus ratio.
- The Chinese corpus came from a Chinese Wikipedia 20231101 shard under CC BY-SA 4.0. Chinese training and holdout data were disjoint; the English Wikipedia holdout contained 6,335 entries.
- The user-note bucket was a small sample of approximately 15,000 characters and does not represent every note-taking style or real user corpus.
- This experiment measures **tokenization efficiency**, not answer quality, reasoning ability or model accuracy.
- `48k-zh80` is a research configuration and is not presented as the default for every current VetarModel model.

Aggregate data: [tokenizer-efficiency.csv](docs/data/tokenizer-efficiency.csv).

### 2. 长文档：8K 小窗召回与 32K 全量输入

**观察重点：** 在这一项同模型、同文档对照中，`8K + 召回` 的正确率高于 32K 全量输入，同时显著减少 prefill 耗时和 prompt 长度。这是架构路线对照，不是与其他应用的横评。

| 方案 | 数字事实题正确率 | prefill 均值 | prompt 均值 |
| --- | ---: | ---: | ---: |
| 32K 全量输入 | 16/20（80%） | 52.1 秒 | 31,249 词元 |
| 8K + 召回 | **18/20（90%）** | **2.7 秒** | **3,190 词元** |

召回方案使用 300 字文本块、top-4 检索；检索器在这 20 道题中均召回到含答案文本块（20/20）。召回方案的 prefill 均值约为全量方案的 1/19.3，prompt 均值减少约 89.8%，这些比例只适用于本次实验记录。

#### 实验口径与边界

- 日期：2026-10-06；表中为项目研发报告的聚合值，本仓库不附逐题生成日志。
- 模型：Qwen3-4B-Instruct-2507-4bit，通过 MLX 在本地运行，`temp=0`，`max_tokens=48`。
- 单篇中文维基长文档：41,114 字、31,149 个 Qwen 词元；任务为 20 道数字事实定位题。
- 样本很小，且只覆盖单文档类型、单模型和数字事实题；未测多跳推理、跨块归纳或开放式问答。
- prefill 是本次单机对照读数，不是跨硬件统一基准；其他设备、模型和任务的结果可能不同。
- 该结果不能外推为所有长文档任务都更适合小窗召回，也不构成对其他应用的普遍性能领先声明。

聚合数据：[long-context-recall.csv](docs/data/long-context-recall.csv)。

### 2. Long Documents: 8K Retrieval vs. 32K Full Context

**What to read:** In this same-model, same-document comparison, `8K + retrieval` achieved higher answer accuracy than 32K full-context input while substantially reducing prefill time and prompt length. This is an architecture comparison, not a benchmark against other applications.

| Approach | Numeric-fact accuracy | Mean prefill | Mean prompt length |
| --- | ---: | ---: | ---: |
| 32K full context | 16/20 (80%) | 52.1 s | 31,249 tokens |
| 8K + retrieval | **18/20 (90%)** | **2.7 s** | **3,190 tokens** |

The retrieval arm used 300-character chunks and top-4 retrieval. The retriever returned a chunk containing the answer for all 20 questions (20/20). Its mean prefill was approximately 1/19.3 of the full-context arm, with an approximately 89.8% smaller mean prompt; these ratios describe only this experiment.

#### Method and limits

- Experiment date: 2026-10-06. Values are aggregates from the project research report; per-question generation logs are not included in this repository.
- Model: Qwen3-4B-Instruct-2507-4bit, running locally through MLX with `temp=0` and `max_tokens=48`.
- One Chinese Wikipedia long document contained 41,114 characters and 31,149 Qwen tokens; the task contained 20 numeric-fact localization questions.
- The sample is small and covers only one document type, one model and numeric-fact questions. Multi-hop reasoning, cross-chunk synthesis and open-ended question answering were not tested.
- Prefill values are from this single-machine comparison, not a cross-hardware benchmark. Results may differ on other devices, models and tasks.
- The result does not establish that retrieval is better for every long-document task or that VetarModel universally outperforms other applications.

Aggregate data: [long-context-recall.csv](docs/data/long-context-recall.csv).

### 公开与复现边界 / Publication and Reproduction Scope

两份 CSV 仅用于核对本节表格与计算相对变化，不包含可重建完整实验的全部资产。公开源码同样是架构节选，不能据此构建完整产品或复现全部产品能力。测试阶段欢迎反馈，但应结合上述样本、口径与局限理解所有数字。

The CSV files contain aggregate values for checking the tables and relative changes; they do not include every asset needed to reproduce the complete experiments. The published source is also an architecture excerpt and cannot be used to build the complete product or reproduce every product capability. Feedback is welcome during testing, but all figures should be read with the samples, methods and limitations above.

## 🚀 使用安装包（推荐普通用户）

VetarModel 0.8.15 需要 macOS 14.0 或更高版本。

[⬇️ 下载 VetarModel 0.8.15 安装包](https://github.com/zero11924065-dev/VetarModel/releases/latest/download/VetarModel-0.8.15.dmg)

1. 下载并双击挂载 VetarModel `.dmg` 安装包。
2. 把 VetarModel 拖入 Applications 文件夹。
3. 从启动台打开。

安装包由本仓库 Releases 提供。

## 🚀 Install (Recommended)

VetarModel 0.8.15 requires macOS 14.0 or later.

[⬇️ Download the VetarModel 0.8.15 installer](https://github.com/zero11924065-dev/VetarModel/releases/latest/download/VetarModel-0.8.15.dmg)

1. Download and mount the VetarModel `.dmg`.
2. Drag VetarModel into Applications.
3. Open it from Launchpad.

The installer is available through this repository's Releases.

## 📖 源码说明

本仓库为 VetarModel 的开源子集快照（GPL-3.0），公开 17 个 Swift 文件，覆盖界面基础组件、显式导航、会话文本处理、探索工具、训练界面辅助、设备状态抽象和通用工具。不包含训练与推理执行、模型包导出、检索、账号授权、更新、运行时或密钥实现，也不包含模型、原始语料、私有构建配置与私有依赖。公开树用于展示部分架构与通用实现，**不能独立构建为 VetarModel 应用**。

各文件的职责、分层关系与公开数据流见 [架构节选](docs/ARCHITECTURE.md)。选择性公开的研发数据、对照结果和实验局限见 [测试数据](#测试数据--test-data)。

## 📖 Source Notes

This repository is an open-source subset snapshot of VetarModel (GPL-3.0), containing 17 Swift files across UI foundations, explicit navigation, chat text processing, exploration utilities, training-UI support, device-state abstraction, and general utilities. It excludes training and inference execution, model-package export, retrieval, account licensing, updates, runtime and key implementations, as well as models, raw corpora, private build configuration and private dependencies. The public tree presents selected architecture and reusable implementations; it **cannot be built into the complete VetarModel app**.

See the [Architecture Excerpt](docs/ARCHITECTURE.md) for file responsibilities, layering and public data flows. See [Test Data](#测试数据--test-data) for selected research results, comparisons and experimental limitations.

## 🗂 目录结构 / Directory Structure

```text
VetarModel/
├── .gitignore
├── LICENSE
├── README.md
├── docs/
│   ├── ARCHITECTURE.md
│   ├── TESTING.md
│   └── data/
│       ├── long-context-recall.csv
│       └── tokenizer-efficiency.csv
└── Sources/VetarModel/
    ├── Account/
    │   └── LogSanitizer.swift
    ├── Chat/
    │   ├── ChatMarkdown.swift
    │   └── ChatTextFilter.swift
    ├── Core/
    │   └── PowerMonitor.swift
    ├── Exploration/
    │   ├── BackgroundLearningLog.swift
    │   └── TextDiffer.swift
    ├── Navigation/
    │   └── RootNavigation.swift
    ├── Training/
    │   └── TrainingParamStepperDebouncer.swift
    ├── UI/Theme/
    │   ├── BrandComponents.swift
    │   ├── MCallout.swift
    │   └── MTheme.swift
    ├── Utilities/
    │   ├── AppVersion.swift
    │   ├── LogCleaner.swift
    │   ├── SemanticVersion.swift
    │   └── StorageUsage.swift
    └── Views/
        ├── FoldRow.swift
        └── KBActionBarAvailability.swift
```

## 📮 联系我 / 反馈

如果你在使用中遇到任何问题，或者有更好的建议，欢迎随时联系我！  
If you encounter any issues or have suggestions, feel free to reach out!

- 官网 / Website：[VetarAI.com](https://vetarai.com)
- 微信 / WeChat：ISEEVetar
- 邮箱 / Email：zero11924065@foxmail.com
- 抖音 / Douyin：VidjeliSteVetar

## 📄 许可

本仓库内公开源码采用 **GNU GPL v3.0** 开源协议。你可以自由使用、学习、修改和分发这些公开源码，但分发修改后的版本时必须同样以 GPL v3.0 开源，并保留版权声明与许可文件。完整条款见仓库根目录的 LICENSE 文件，每个源代码文件头部也附有许可声明。本许可说明仅针对本仓库实际公开的文件。

## 📄 License

The source files published in this repository are licensed under the **GNU General Public License v3.0**. You are free to use, study, modify and distribute these published sources, but any distributed modified version must likewise be released under GPL v3.0 with copyright notices and license preserved. See the LICENSE file at the repository root for full terms; each source file also carries a license header. This license statement applies to the files actually published in this repository.
