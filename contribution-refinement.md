# M6.5：Contribution Refinement

主对象：**C1，HAKE c_KEM[8] 中k*的单个context出现位置，σ_KEM=k*保留。** C2作为后续独立研究，不合并成一般KDF框架。

## 1. 研究问题的准确表达

> Identify whether existing security guarantees subsume explicit KDF context binding in the HAKE-specific C1 setting, while preserving the original security targets and stated failure-branch boundaries.

中文：针对HAKE的C1候选，识别已有secret输入、协议和混合组合保证，是否足以承担显式KDF context绑定所对应的安全职责，并检查其能否保持原安全目标及声明的失效范围。

这里的“是否”保留肯定、否定和证据不足三种结果。不是预设字段冗余，不把移除一个重复字符串本身称为论文贡献。

建议工作标题：**HAKE中秘密输入与显式KDF Context绑定的安全职责：单位置候选的适用边界研究**。标题不承诺优化成功或安全定理已经建立。

## 2. 贡献分层：已完成与待建立

| 层级 | 当前可陈述的成果 | 不能提前陈述的成果 |
|---|---|---|
| 基线和目标 | 已重建HAKE输入/调用，区分原声明、外部参考模型和开放语义 | 完整可执行模型已经冻结，原论文全部证明已独立验证 |
| 分层和接口 | 已区分primitive、protocol、hybrid composition，登记B1/B4等接口问题 | primitive binding等价于身份/会话绑定，原协议因接口问题已被攻破 |
| 研究对象 | 已选择C1作为单位置、HAKE-specific主对象，C2为future work | C1职责已被subsume，或安全减少context已获证明 |
| 后续潜在正面贡献 | 若闭合接口，可能给出该位置与原目标/明确分支之间的非循环保持分析 | 一般context elimination theorem，或未经证明的全分支安全优化 |
| 后续可能的边界成果 | 若条件不足，精确说明哪些源/语义/分支前提阻止现有结果直接适用 | 把证明失败当作字段必要性、攻击成功或不可能性定理 |

这些是项目进展与贡献规划，不是新颖性或发表价值认证。已有文献边界沿用 [M2审查](novelty-gap.md)；没有进行足以支持“首次”的穷尽性检索。

## 3. C1为何仍是协议研究，而非单纯KDF语法讨论

σ仍含同侧k*，使合法元组中重复项的结构关联可以被清晰观察。但HAKE目标还涉及：哪些派生调用属于同一匹配记录、哪些泄漏允许、τ3暴露怎样关联最终key、QKD检索如何进入source索引，以及各故障分支能引用哪些保证。

只说明元组有足够信息，不回答这些协议问题；只给理想符号模型中的一致性，也不回答计算Key-IND、RO查询损失或原PFS。因此主线保持HAKE-specific的安全职责问题，不以抽象可恢复性作为完成标志。

同时不为了凸显primitive binding而强行给C1加入K-PK/C2PRI假设。C1若不需要某类binding，应据实际证明需求说明；C2才更直接面向primitive→ephemeral session的候选衔接。这一差别不能被论文叙事抹平。

## 4. 最小有意义的后续结果与新颖性风险

最小目标不是笼统写“原协议安全则候选安全”，而是对C1明确：原模型的哪些已审语义、哪种合法source/查询接口、何种确认/泄漏视图以及哪些原失败路径支持对应结论。当前不写该定理或证明。

若最终仅得到既有KDF结果的直接实例化，应称实例化，不能宣称新的协议级安全原理。若只有BG或新增binding条件下的结果，应明确其窄范围，不能把原hybrid robustness作为已保持卖点。若只能厘清B1/B4，应称接口/基线适用边界分析，不包装成优化成果。

潜在创新必须来自经验证的HAKE-specific衔接或精确适用边界，不能来自字段数量减少、未测量的性能收益、形式工具给出的单一PASS，或未被证明的反例类别。

## 5. 对外可用的阶段性表述

本研究以HAKE中k*的显式KDF context出现位置为主要候选，考察保留的secret输入与既有协议及混合组合保证是否能承担其安全职责。当前已完成来源约束、字段职责分层、候选比较和证明义务登记，尚未建立安全保持结论。后续分析限定于HAKE原目标及明确的故障边界，不扩展为一般KDF框架；pk_e候选作为独立后续方向。

## 6. 本轮范围与交付

只新增 [候选比较](reduction-target-selection.md)、[主路线选择](primary-reduction-selection.md) 和本文件。已有HAKE、KDF、来源、模型、CSV与路线图均不改动。没有开始证明、编写形式模型、运行工具或删除字段。

M6.5的完成表示研究对象选择文档完成，**不表示M7准入**。停止并等待人工审查。
