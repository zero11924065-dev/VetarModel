🌐 [官网 VetarAI.com](https://vetarai.com) ｜ ⬇️ [下载 Download](https://github.com/zero11924065-dev/VetarModel/releases/latest/download/VetarModel-0.8.15.dmg) ｜ [联系 Contact](#-联系我--反馈)

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

本仓库为 VetarModel 的开源子集快照（GPL-3.0），仅包含少量通用 SwiftUI 组件与语义版本工具。不包含训练、推理、导出、检索、账号、授权、更新或安全相关实现，也不包含模型、数据、构建配置与私有依赖。公开树仅作代码展示，**不能独立构建为 VetarModel 应用**。

## 📖 Source Notes

This repository is an open-source subset snapshot of VetarModel (GPL-3.0), containing only a small set of general SwiftUI components and a semantic-version utility. It excludes training, inference, export, retrieval, account, licensing, update and security implementations, as well as models, data, build configuration and private dependencies. The public tree is for source review only and **cannot be built into the complete VetarModel app**.

## 🗂 目录结构 / Directory Structure

```text
VetarModel/
├── .gitignore
├── LICENSE
├── README.md
└── Sources/VetarModel/
    ├── UI/Theme/
    │   ├── MTheme.swift
    │   └── MCallout.swift
    ├── Views/
    │   └── FoldRow.swift
    └── Utilities/
        └── SemanticVersion.swift
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
