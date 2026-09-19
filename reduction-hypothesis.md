# Reduction Hypotheses：HAKE-specific

状态：仅候选，所有安全保持主张未证明。本轮只提出 C1、C2 的独立单位置差分，不选择一个已通过安全门槛的变体。

## H1：k* 的 context occurrence

问题：在保留 σ_KEM=k* 的前提下，C1 是否仍满足原 HAKE 最终 Key-IND、matching 完成正确性及原 PFS/故障合同？“同值已在 secret 输入中”仅是动机。

候选依赖：

- **结构关联：** 仅在合法同侧记录中，c_KEM[8]=σ_KEM。需保留实际编码与 source 次序，区分完整输入和 context 子串。
- **source 合法性：** 分别为原对象和候选说明秘密 context、对手真实可见 α、相关性和允许泄漏。不得通过公开 k1/k2 或改变 σ 来满足外部定理。
- **查询桥：** 协议本地调用、匹配双方、重复调用和 Test/Reveal 到 KDF 索引的一致映射。
- **输出桥：** 同一执行中 512-bit 输出到确认/最终半段、τ3 与公开 transcript 的联合分析。
- **分支桥：** BG/KO、QS、QB、QT 分开，不增加失效分支中已不存在的计算保证。

目前不能推出 H1。需评估的失败模式是**对原安全目标有影响的派生记录混同、合法泄漏污染或查询关联丢失**；“两个 reduced context 相同”本身不足以构成反例。即使完整候选元组足以重建原元组，也还没有完成 RO 查询、source 游戏和协议状态的耦合。

## H2：pk_e 的 context occurrence

问题：C2 中保留的 KEM 调用、τ1/τ3 覆盖及其他输入，是否能在原目标/分支内承接 pk_e 的候选职责？

候选前提分层登记：

1. L1：实际实例满足精确、适域的 K-PK 或其他经核验关系。不能用固定公钥 C2PRI 替代跨公钥问题。
2. L2：组件关系通过独立的来源/角色/SID/本地状态论证连接 HAKE session。仅有 key/pk 关系不提供 identity/matching。
3. L3：两 source 的接口、QKD endpoint/ID 和可用故障路径可组合。binding 存活不蕴含 MAC 存活。

这些是未验证的候选前提，不是本轮新增到原 HAKE 的假设。若只能在额外 binding 条件下成立，必须标为较窄合同，而不是“原安全保持”。QS 只用于识别这种范围缩窄，不自动成为最终研究目标。

潜在失败类别是临时凭据/会话对应丢失，或身份视图不一致却错误复用局部 binding 结果。这里没有操作轨迹、已构造反例或协议漏洞判断；是否影响原 Key-IND 或 correctness 还须论证，不能把独立 UKS 游戏暗加为主目标。

## 共同前提不能被当作结论

| 不成立的捷径 | 本轮要求 |
|---|---|
| 原 HAKE 有总体结果，所以候选只改 context 也安全 | 原结果不蕴含逐位置保持；原基线接口也要先闭合 |
| 两者消息结构一样，所以攻击者视图相同 | F 输出可不同，τ3 key/tag 及后续验证结果可不同；需独立证明 |
| τ3 仍含某字段，所以 F 之前已经绑定 | 后置确认依赖待分析输出；需非循环联合论证 |
| 同 key 所以同 pk，所以同 identity/session | 每一段有独立游戏域/协议映射，不允许跳步 |
| 秘密输入没改，所以 Key-IND 和 PFS 不变 | 编码、查询、合法泄漏、确认视图及擦除时序仍相关 |
| 仅 BG 或 QS 成功，所以 hybrid robustness 保持 | 不能省略 KO/QB/QT 或悄悄增强它们的前提 |

## 证据定位

- 原输入、MAC 方向和确认：H26 Fig.3、§3.1 pp13–15。
- 原目标、freshness 与原语/故障边界：H26 Def.3–7、Lemma1–3、Thm.1–2；源文件见 [来源清单](sources/README.md)。
- secret/context overlap：K25 Def.1–3 pp8–9；B1 是外部模型直接套用缺口，不是线上泄密结论。
- K-PK/K-CT：D24 Def.4.1；C2PRI：X24 Def.7；KEM-AKE 背景：B23 Fig.8。
- 逐项待证工作：[proof-obligation-matrix.csv](proof-obligation-matrix.csv)。事件/泄漏缺失处继续标记 open / not explicitly specified。

不提出 C1+C2 联合假设；即使将来分别证明，也不能自动推出联合保持。
