# 测试数据 / Test Data

> **测试阶段：** VetarModel 仍处于测试阶段，功能、性能与兼容性可能随版本变化。本页用于公开研发进展，不构成正式性能承诺。
>
> **Testing stage:** VetarModel is still in testing. Features, performance and compatibility may change between versions. This page shares research progress and is not a formal performance guarantee.

本页选择性公开两组有代表性的研发实验，不是完整榜单或独立第三方横评。为避免只展示有利结果，页面同时保留不利读数、实验边界与未测项目。

This page selectively publishes two representative research experiments. It is not a comprehensive leaderboard or an independent third-party benchmark. Unfavorable results, scope limits and untested cases are retained alongside favorable results.

两组实验的模型、任务与统计口径不同，表格之间不可直接比较，也不能外推为对所有硬件、模型或使用场景的领先。公开文件仅包含聚合数值，不包含原始语料、用户材料、问答内容、模型或训练资产。

The two experiments use different models, tasks and metrics. Do not compare across the tables or generalize the results to every device, model or workload. Only aggregate values are published; raw corpora, user materials, questions and answers, models and training assets are not included.

## 1. 词表效率：与 Qwen3 通用词表对照

**观察重点：** 在这组实验中，VetarModel 的 `48k-zh80` 研究配置提高了中文与结构化文本的字／词元效率；英文维基和用户笔记体则低于 Qwen3 基线。

前四项指标单位为**字／词元，越高越好**；最后一项为按中文字／词元推算的 32K 窗口装载量，并非对完整应用可用上下文的承诺。

| 指标 | Qwen3 词表（151,669） | VetarModel `48k-zh80` 研究配置 | 相对变化 |
| --- | ---: | ---: | ---: |
| 中文维基（字／词元） | 1.3569 | **1.7701** | **+30.5%** |
| 英文维基（字／词元） | **4.0081** | 3.6787 | −8.2% |
| 用户笔记体（字／词元） | **1.3583** | 1.2431 | −8.5% |
| 结构化 CSV／JSON（字／词元） | 1.4309 | **1.7437** | **+21.9%** |
| 32K 窗口推算中文字数 | 44,462 | **58,002** | **+30.5%** |

### 实验口径与边界

- 日期：2026-10-06。
- 基线为 Qwen3 代分词器，词表大小 151,669；对照项为 48,000 词表的 byte-level BPE 研究配置，训练中英文语料配比约为 8:2。
- 中文语料来自中文维基百科 20231101 分片，许可证为 CC BY-SA 4.0；中文训练集与留出集不相交，英文维基留出集为 6,335 条。
- 用户笔记体为小样本评估桶，约 1.5 万字符，不能据此推断所有笔记或真实用户语料的表现。
- 该实验衡量**分词效率**，不衡量回答质量、推理能力或模型准确率。
- `48k-zh80` 是研究配置，不代表当前所有 VetarModel 模型均采用此配置。

聚合数据：[tokenizer-efficiency.csv](data/tokenizer-efficiency.csv)。

## 1. Tokenizer Efficiency: Qwen3 Baseline Comparison

**What to read:** In this experiment, the VetarModel `48k-zh80` research configuration improved character-per-token efficiency on Chinese and structured text, while trailing the Qwen3 baseline on English Wikipedia and the user-note sample.

The first four metrics are **characters per token; higher is better**. The final row is an estimated 32K-window Chinese character capacity derived from the Chinese ratio, not a promise of usable context in the complete app.

| Metric | Qwen3 tokenizer (151,669) | VetarModel `48k-zh80` research configuration | Relative change |
| --- | ---: | ---: | ---: |
| Chinese Wikipedia (characters/token) | 1.3569 | **1.7701** | **+30.5%** |
| English Wikipedia (characters/token) | **4.0081** | 3.6787 | −8.2% |
| User-note sample (characters/token) | **1.3583** | 1.2431 | −8.5% |
| Structured CSV/JSON (characters/token) | 1.4309 | **1.7437** | **+21.9%** |
| Estimated Chinese characters in a 32K window | 44,462 | **58,002** | **+30.5%** |

### Method and limits

- Experiment date: 2026-10-06.
- The baseline is a Qwen3-generation tokenizer with 151,669 entries. The comparison is a 48,000-entry byte-level BPE research configuration trained with an approximately 8:2 Chinese-to-English corpus ratio.
- The Chinese corpus came from a Chinese Wikipedia 20231101 shard under CC BY-SA 4.0. Chinese training and holdout data were disjoint; the English Wikipedia holdout contained 6,335 entries.
- The user-note bucket was a small sample of approximately 15,000 characters and does not represent every note-taking style or real user corpus.
- This experiment measures **tokenization efficiency**, not answer quality, reasoning ability or model accuracy.
- `48k-zh80` is a research configuration and is not presented as the default for every current VetarModel model.

Aggregate data: [tokenizer-efficiency.csv](data/tokenizer-efficiency.csv).

## 2. 长文档：8K 小窗召回与 32K 全量输入

**观察重点：** 在这一项同模型、同文档对照中，`8K + 召回` 的正确率高于 32K 全量输入，同时显著减少 prefill 耗时和 prompt 长度。这是架构路线对照，不是与其他应用的横评。

| 方案 | 数字事实题正确率 | prefill 均值 | prompt 均值 |
| --- | ---: | ---: | ---: |
| 32K 全量输入 | 16/20（80%） | 52.1 秒 | 31,249 词元 |
| 8K + 召回 | **18/20（90%）** | **2.7 秒** | **3,190 词元** |

召回方案使用 300 字文本块、top-4 检索；检索器在这 20 道题中均召回到含答案文本块（20/20）。召回方案的 prefill 均值约为全量方案的 1/19.3，prompt 均值减少约 89.8%，这些比例只适用于本次实验记录。

### 实验口径与边界

- 日期：2026-10-06；表中为项目研发报告的聚合值，本仓库不附逐题生成日志。
- 模型：Qwen3-4B-Instruct-2507-4bit，通过 MLX 在本地运行，`temp=0`，`max_tokens=48`。
- 单篇中文维基长文档：41,114 字、31,149 个 Qwen 词元；任务为 20 道数字事实定位题。
- 样本很小，且只覆盖单文档类型、单模型和数字事实题；未测多跳推理、跨块归纳或开放式问答。
- prefill 是本次单机对照读数，不是跨硬件统一基准；其他设备、模型和任务的结果可能不同。
- 该结果不能外推为所有长文档任务都更适合小窗召回，也不构成对其他应用的普遍性能领先声明。

聚合数据：[long-context-recall.csv](data/long-context-recall.csv)。

## 2. Long Documents: 8K Retrieval vs. 32K Full Context

**What to read:** In this same-model, same-document comparison, `8K + retrieval` achieved higher answer accuracy than 32K full-context input while substantially reducing prefill time and prompt length. This is an architecture comparison, not a benchmark against other applications.

| Approach | Numeric-fact accuracy | Mean prefill | Mean prompt length |
| --- | ---: | ---: | ---: |
| 32K full context | 16/20 (80%) | 52.1 s | 31,249 tokens |
| 8K + retrieval | **18/20 (90%)** | **2.7 s** | **3,190 tokens** |

The retrieval arm used 300-character chunks and top-4 retrieval. The retriever returned a chunk containing the answer for all 20 questions (20/20). Its mean prefill was approximately 1/19.3 of the full-context arm, with an approximately 89.8% smaller mean prompt; these ratios describe only this experiment.

### Method and limits

- Experiment date: 2026-10-06. Values are aggregates from the project research report; per-question generation logs are not included in this repository.
- Model: Qwen3-4B-Instruct-2507-4bit, running locally through MLX with `temp=0` and `max_tokens=48`.
- One Chinese Wikipedia long document contained 41,114 characters and 31,149 Qwen tokens; the task contained 20 numeric-fact localization questions.
- The sample is small and covers only one document type, one model and numeric-fact questions. Multi-hop reasoning, cross-chunk synthesis and open-ended question answering were not tested.
- Prefill values are from this single-machine comparison, not a cross-hardware benchmark. Results may differ on other devices, models and tasks.
- The result does not establish that retrieval is better for every long-document task or that VetarModel universally outperforms other applications.

Aggregate data: [long-context-recall.csv](data/long-context-recall.csv).

## 公开与复现边界 / Publication and Reproduction Scope

两份 CSV 仅用于核对本页表格与计算相对变化，不包含可重建完整实验的全部资产。公开源码同样是架构节选，不能据此构建完整产品或复现全部产品能力。测试阶段欢迎反馈，但应结合上述样本、口径与局限理解所有数字。

The CSV files contain aggregate values for checking the tables and relative changes; they do not include every asset needed to reproduce the complete experiments. The published source is also an architecture excerpt and cannot be used to build the complete product or reproduce every product capability. Feedback is welcome during testing, but all figures should be read with the samples, methods and limitations above.
