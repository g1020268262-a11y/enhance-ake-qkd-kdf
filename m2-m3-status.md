# M2–M3 任务卡与交付状态

日期：2026-09-18。用户范围：完成路线图 M2–M3；不扩展到 M4 选定变体、删字段、攻击复现、形式验证或 benchmark。

## M2

- 输入：M0/M1、H26；实际引用的 CK01/Boyd/Backendal；binding、X-Wing、Starfighters 和固定 IETF draft-11。
- 已执行：归档原始资料、锁定正文/元数据版本差异；核查模型与具体定理；比较近邻；排查能否直接套用；明确 B1–B7 证明接口义务。KDF 的 2025 原版和 2026 修订版对关键发现交叉核对。
- 产物：[文献矩阵](related-work-matrix.csv)、[差异与适用性分析](novelty-gap.md)、[BibTeX](references.bib)、[带哈希来源清单](sources/README.md)。
- 验收：M2.1–M2.8 的核查任务完成；未证明创新性成立。G1 只支持继续研究 HAKE 特定衔接，不能把原语字段省略当新贡献。

## M3

- 输入：H26 的非正式 CK01、R-CK 原始定义、M2 的具体接口问题。
- 已执行：列出 oracle/返回；区分原文与参考语义；建六分支安全合同；逐位置分析完整故障兼容性；预先登记较窄 C-BIND 合同，未把它冒充原保证。
- 产物：[安全模型](security-model.md)、[33 个分支/性质合同单元](security-contract.csv)、[四位置准入表](hybrid-branch-compatibility.csv)。
- 验收：M3.1、M3.3–M3.11 的分析/登记任务完成。M3.2 **部分完成**，原文事件/Test/擦除冲突未唯一裁定。G2 **未通过**：四字段均证据不足；没有“已证明可删”“已证明不可删”或“发现协议漏洞”的结论。

## 未解决问题与后续最小步骤

| 问题 | 证据 | 最小闭合工作 | 不能采用的捷径 |
|---|---|---|---|
| 秘密 context 与公开 α | K25/K26 Def.1 对 H26 §3.1；B1 | 给 baseline/source 的正确形式映射，说明是否只是证明重表达 | 把 k* 在线上当公开；或先删字段再称原证明自动成立 |
| 原纯 min/ITS 界 | Thm.9 + Lemma23；B2/B6 | 保留预测/碰撞项与 RO 能力，重新核对完整归约 | 删除余项、混同查询无界与计算无界、替换 combiner |
| Complete/Test/擦除 | H26 pp8–9/Fig.3 对 CK01 §3.3–4.1；B5 | 明确参考游戏与 H-history 的关系及每个事件程序点 | 以对证明有利的 Accept 或双侧同步 Expire 静默替代 |
| source 独立与查询索引 | H26 Lemma2、KDF Def.2/Table1；B3/B4 | 模拟 ID/中止与 matching 双侧派生并验证 req | 把诚实执行正确性或 QKD 一次输出直接当查询合法性 |
| binding 到协议性质 | D24、X24、S26；四位置表 | 分别给游戏域、实例及故障分支下的替代论证 | C2PRI 当 K–PK；HON 当 LEAK；QB 中重新假设 binding |

## 同步修改与验证边界

M0 仅修正“图已有 pk/ct 检查”的过度措辞并追加审查提示；claims-register 保留论文证据分类，给 C02/C03/C06/C08/C09 加入核验状态；M1 追加参考定义和抽象 H 调用数回填，不改 Figure 3。路线图仍把 M3.2 留未勾选；M0.1 和 M1 原有未完成项未伪装关闭。

验证结果见本文件末尾的记录。只做文档、表格、交叉引用及来源校验；没有协议实现测试或安全证明运行，也未 commit/push。

## 核验记录

复核命令：PowerShell 执行 `& ./scripts/validate-m2-m3.ps1`，以及 `git diff --check`。

- field-ledger：27 行 / 18 列；claims-register：18 行 / 8 列，均保持原 schema。
- related-work-matrix：9 行 / 12 列（8 项工作，KDF 两版本分列）；security-contract：33 行 / 11 列；hybrid-branch-compatibility：4 行 / 17 列。
- 合同 cell ID 唯一、候选引用存在、门槛状态与准入一致。
- 10 个来源文件的 SHA-256 与清单一致，包含未修改的原 HAKE PDF。
- 9 个 BibTeX key 唯一且花括号平衡；这是结构检查，不是排版或出版元数据认证。
- 本地 Markdown 链接通过；M2 八项已勾选，M3.2 仍未勾选。
- `git diff --check` 通过；Git 提示工作副本行尾以后会转换为 CRLF，不是内容错误。
- 关键视觉核查包括 K25 Def.1、K26 Thm.9/Lemma23、D24 Fig.5、CK01 Def.4/脚注6、S26 Thm.14、X24 Def.7/Thm.1；公式中的查询数和 `u²` 项经页面核对。

临时 PDF 文本、网页下载中间页及渲染 PNG 已完成核验，但清理请求被环境策略拒绝，**仍保留在 `tmp/m2-reading/` 和 `tmp/pdfs/`**；没有绕过限制或删除材料。它们可从保留来源重新生成，不属于最终研究证据。`sources/` 的 PS/PDF/TXT 为正式证据，不删除。
