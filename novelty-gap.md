# M2：HAKE-specific 差异与直接套用审查

核查日期：2026-09-18。状态：文献核查与问题收缩已完成；创新性、删减安全和原 HAKE 全部证明均未获独立验证。文献编号、版本及哈希见 [sources/README.md](sources/README.md)，逐篇比较见 [related-work-matrix.csv](related-work-matrix.csv)。页码默认论文印刷页；CK01 的 PDF 页比印刷页多 2。

## 1. 可被证伪的研究问题

在固定 HAKE Figure 3、原 authenticated setup、单 Test/暴露时序和 QKD 一次输出接口后，是否存在一个**只删除一个 component-context 出现位置**的投影，使最终 `k_h^2` 的 SK 安全与原声称的故障分支得到非循环的协议级证明？首批审查 `k*@c_KEM[8]`、`pk_e@c_KEM[5]`、`pk_a@c_KEM[2]`、`pk_b@c_KEM[4]`，不预判任何一个可删。

这是待解问题，不是“首次”结论。若已有定理在完全相同的 source、泄漏、partnering、完成事件和故障语义下直接给出该投影的结论，本研究的正面创新应降为实例化。若只能证明 secrecy 坏而 binding 仍好，则贡献必须称为**较窄合同下的条件保持**；若只能完成接口纠错，应转为基线证明边界研究，不包装成优化。

## 2. 最近邻结果究竟给了什么

| 来源 | 已有结果 | 不能直接移植到 HAKE 的部分 |
|---|---|---|
| B23 §2.4、Thm.2–4、Fig.8，pp10–22 | AM 的 KEM 密钥交换经 KEM/MAC authenticator 编译成 UM 的 SK 协议；诚实 matching 正确性和单 Test 密钥不可区分 | 不含 QKD、HAKE 的 F、秘密 context 或 τ3。HAKE 的 τ2 还多了 QKD ID；不能用原 Fig.8 的结论直接证明删 F 输入 |
| K25/K26 Def.1–4、Fig.3/Table1、Thm.9 | 固定 source 集合与查询条件下的 multi-input RO-KDF hybrid 安全 | 必须重新建立 source/auxiliary/context 映射、输入索引和查询合法性；不是任意 context 的投影不变性定理 |
| D24 Def.4.1/Fig.5–6、§5–6/Table2 | HON/LEAK/MAL binding 游戏及细粒度符号分析；具体 KEM-AKE 的认证性质需要哪些 binding | 不是 HAKE 的计算 SK/PFS 归约；其 symbolic HON/LEAK 抽象不能代替计算泄漏差异（Appendix C） |
| X24 Def.7、Thm.1–2、§6 | QSF/X-Wing 不把 PQ 公钥和密文输入 combiner；两侧安全采用不同假设 | C2PRI 是固定诚实公钥和诚实 challenge ciphertext 的第二原像性质，不是 identity/role/session agreement |
| S26 Fig.7、Thm.14、Thm.16–22及附录 | QSI 对两份共享秘密和 label 哈希；一方 IND-CCA、另一方 C2PRI 加 skPRF；binding 保持另有定理 | 两 KEM 的 IND-CCA/binding 不是 KEM-AKE 与状态化 QKD 的 SK；不同 binding 有 existential/universal 的不同前提，不能统称“一个好就够” |
| I11 §5.3–5.6、§6.1–6.4、§8 | UG/UK 与 CG/CK 构造，后者省略 PQ pk/ct 而承担 C2PRI；分开讨论 IND-CCA 与 LEAK binding | 是固定 draft-11，不是 RFC；协议设计者仍需检查协议层输入用途。不能据此删 HAKE context |

因此“用 binding 减少哈希字段”本身已被覆盖；可能新增的是**HAKE 投影到协议 SK 的具体衔接以及原故障分支是否被收窄**，不是一个新的通用 combiner。

## 3. 原 HAKE 到所引定理的七项接口审查

以下为本次推导/核验结果；它们是证明适用性问题，**不等于已证明协议可攻击**。

### B1：secret-bearing context 与公开辅助信息冲突

K25、K26 Def.1（均 p8）要求 `c` 可从攻击者收到的 `α` 提取。HAKE §3.1 p14 却把 `k1,k2,k*` 放在 `c_KEM`，其中 `σ_KEM=k*`。若逐字映射，`α` 已给出 `σ_KEM`，不能再用该 source 的不可预测性得到非平凡 KEM 存活分支界。这是**直接套用失败**，不是说线上公开了这些秘密。

可研究的修复包括重新划分 secret/context 或给 secret-bearing context 建立适用定理；本阶段不实施修复。只删 context 内的 k* 也不自动解决 k1/k2 的辅助泄漏、认证模拟和相关性问题。这个发现使该候选值得进一步审查，但尚未通过 G2。

### B2：不能丢掉预测/碰撞项，尤其不能据此外推无界 ITS

K26 Thm.9 p17（K25 p16）给出

`Adv_kdf ≤ 2 min_{i∈S} Adv_up(Σ_i,B_i)`，`qPredict(B_i) ≤ n·u·qRO(A)`。

K26 Lemma23 p38（K25 p37）给出

`Adv_up ≤ Adv_pr + (qPredict + u²)·2^(−m)`。

这不是 `Adv_up ≤ Adv_pr`。即使 QKD 密钥理想均匀，后项也不会仅由 `Pr[QKD fail]=0` 消失。故 HAKE pp17–19 的纯 `2 Pr[QKD fail]` 无界界不能由这两条公式直接得到。计算无界但 oracle 查询受限与查询也无界必须分开；当前不为原文补造查询上限或新优势界。K26 §7.2/Thm.17 的 ITS-KDF 使用一次性均匀份额异或，是不同构造，不能悄悄替换 HAKE 的 RO-KDF。

### B3：独立 source 与消息处理独立不是同一件事

K26 Def.2 p9 要求各 source 可独立采样，source 内可相关。HAKE Lemma2 p15 的证明概要称子协议不依赖对方中间量，但 Fig.3 的 τ2 直接认证 `qkdKeyId`。不因此推断 KEM/QKD 秘密一定相关；需要显式模拟 ID、认证、选择和中止，并论证条件分布及 α，不能把“只是同一报文”当作完整接口证明。

### B4：协议运行到 KDF 索引的映射尚未给全

`reqN` 含 NOF freshness、至少一个 honest 输入、无重复 dishonest 元组、正确 source 位置；`reqHybrid(S)` 还要求 S 的输入诚实且索引一次使用（K26 Table1 p12）。匹配双方算相同 F 是同一个逻辑派生记录还是两次 oracle 调用？完成前派生、重放、合法 Reveal 怎么映射？删除 context 后是否把原来不同的输入合并？这些都是 HAKE 新证明义务，不能由 QKD 的一次输出一句话覆盖。

### B5：完成、擦除及 partnering 的来源存在差异

CK01 §3.3/§4.1 的 matching 不要求相反 role；B23 Def.9 也没有这一限制，HAKE Def.3 有。CK01 Test 选择已完成、未过期、未暴露会话，随后可 expire 再 corrupt；HAKE 的非正式文字还描述 expire/corrupt 后仍可被 Test。CK01 会话返回时擦除非输出状态；HAKE 图中 Alice 派生后仍要处理 τ3。不能把三份文献拼成一套未经声明的“原模型”。具体采用边界见 [security-model.md](security-model.md)。

### B6：QPT 不自动等于量子访问 RO

HAKE 声称 QPT，协议查询是经典的。K25/K26 Thm.9 的证明枚举具体 RO 查询并调用 Predict，没有给出量子叠加查询的同一模拟。当前只记录来源接口，不称其为已核验 QROM 定理。若允许量子 RO，需独立的提升依据及损失；若只准经典 RO，须显式标记限制。

### B7：优势归一化与确认密钥暴露需单独处理

HAKE Def.5 是 `Pr[win]−1/2`，B23 Def.11 使用乘 2 的 convention，KDF 则使用左右世界概率差；搬运常数须先统一。另从 512-bit F 输出安全到“公开基于前半输出的 τ3 后，后半仍是安全会话密钥”需要 reduction，不等同于整个 F 输出直接作为 Test。不得使用已含待删字段的 τ3 结论反证该字段冗余。

## 4. G1 / G2 决策与最小后续工作

G1：在本次固定的文献集中**未找到直接覆盖 HAKE context 投影的定理**，但不能据有限查新断言全球首创。M2 的有效结果是上面的可核查差异与 B1–B7，而非正面安全结论。

G2：四个首批位置均为“证据不足”，没有候选准入完整保持主张。`pk_e` 尤其不能仅凭 C2PRI 获准：C2PRI 固定 pk，不能推出 k* 绑定哪个 pk。即使改用合适 K–PK 游戏，QKD-only 且 binding 也失效时仍不能使用它。

后续最小任务是闭合 B1/B4 的 baseline source 接口，并裁定 B5 的 Test/完成语义，然后重新运行 G2；不是马上写 reduced 协议、运行攻击搜索或 benchmark。若接受较窄研究范围，可采用 M3 的 `C-BIND` 合同候选，但它现在也不是已证定理、不是已获用户接受的新贡献口径。
