# M6：HAKE-specific Security Preservation Framework

状态：分析框架已登记；**安全保持关系尚未成立/未证明**。本文件是特定 HAKE 的证明接口清单，不是通用 context elimination framework。

## 1. 两类协议对象

Original `Π_HAKE`：固定 H26 Fig.3 和 §3.1 的完整协议。

Candidate `Π_HAKE′[j]`：j=1 或 j=2，分别仅将原本地 F 调用的 context 参数替换为 [候选分析](candidate-reduction-analysis.md) 的 p1 或 p2。符号是待研究对象的最小差分规格，不是实现、最终版本或安全认可。不存在本轮的联合 `Π_HAKE′[1,2]`。

| 保持不变 | 不预先声称不变 |
|---|---|
| setup、角色、协议控制逻辑、消息结构/方向与顺序 | 两个实验的完整交互轨迹或所有中止结果 |
| KEM 算法/调用与输入关系，pk_e 在报文和 KEM 中的用途 | 不同自适应执行中随机数、接收材料逐字相同 |
| QKD 接口/配对前提/一次性/⊥ 检查 | QKD fail 时理想黑盒仍成立 |
| τ1/τ2/τ3 的 MAC 算法、消息表达式、key 来源规则 | F 输出、k_h^1、k_h^2、τ3 字节和验证结果 |
| σ_KEM、σ_QKD、label、source order、512→256+256 | 原/候选 key 数值相等或攻击者视图相同 |

因此附件中的“Protocol behavior: same”仅可作**除 context 参数外操作定义不变**的范围约束，不能作为已经证明的行为等价。特别是 τ3 的 MAC 计算规则不变，但其 key 来源 F 的值可能变化。本轮不会为了让 tag 相同而改写 MAC、强行复用旧 key 或额外发消息。

## 2. 目标及未来 theorem 的纳入资格

本轮不写 theorem。下表“拟纳入”只表示将来最小主张应审查的原目标，不是现已有形式命题。

| 性质 | 原来源/含义 | 未来最小主张定位 | 当前状态 |
|---|---|---|---|
| Session Key Secrecy | H Def.5–6 的最终 k_h^2 Key-IND | 拟纳入核心；原攻击者/查询/freshness 不缩减 | open：OI-01–04、B1/B4/B6/B7 |
| Authentication / Matching | H 的 SK/PFS 口径；Def.3 matching 与 Def.6 matching 完成正确性 | 拟保留原定义与正确性；不新增 injective agreement 或每 Accept 必有伙伴 | open：OI-01/05；原 authentication 与候选桥未建立 |
| Forward Secrecy | H 的 expire 后 corrupt 例外与原 PFS 声称 | 拟保留原范围；不能默认擦除，不加 PCS | open：OI-02/03/04/06 |
| Hybrid robustness | H Thm.1 的不同存活路径 | 若称原保持须逐路径覆盖；QS-only 不足 | open：B1–B6 及各分支前提 |
| Failure branch security | 原错误中止及 QKD fail/KEM 失效边界；Thm.2 的 ROM 条件声称另列 | 分支报告必须完整；QT 不并入计算性定理口径 | open：B2/B6；不复制未核验的无界界 |
| Key confirmation | Fig.3/§3.1 Bob→Alice 单向机制 | 作为 Key-IND/状态模拟中的机制处理；无独立双向确认 theorem | open：OI-01、B7 |

优势归一化沿用 H 的 `|Pr[win]−1/2|`；与 KDF 左右世界概率差、Boyd 乘 2 的 convention 区分。旧文献转述中的漏绝对值不复用。本轮没有计算归约常数。

## 3. 分析接口与阻塞项

### SP-01：冻结所需语义

H explicit > H referenced > external interpretation。对原/候选必须使用同一套经审查的事件、Test、freshness、Expire/Corrupt 和状态生命周期。OI-01–OI-06 未被本轮关闭。不直接选 CK01 Test、Boyd matching、完美擦除、全局 SID 去重或更强腐化。缺失行为标记 not explicitly specified，不能完成为方便证明的新规则。

### SP-02：两边均合法的 source/auxiliary 接口

为原和候选分别说明协议中真实 α 与 K25 source 条件，不通过公开秘密、重划 σ 或换 KDF 修补。本轮不做修补。C1 的 σ 重建观察不能解决 k1/k2；C2 保留原重叠。未解决 B1 时，不能启动“套用 KDF theorem”的有效 game hop。

### SP-03：多会话与查询一致性

需覆盖 matching/nonmatching、本地重复调用、原 KDF source 索引和 req、合法 Reveal/State/Corrupt 及 QKD 一次性选择。相同 reduced context 不等于相同完整 F 输入；相同最终 key 不等于相同组件 key。只识别会影响原目标的混同，不强行要求所有不同会话永不碰撞。

### SP-04：确认与自适应视图

需处理输出拆分、τ3 可见、合法泄漏和双方不同时完成。不能因为 MAC 表达式未改就断言 tag 分布/接受集合未改。不得用“候选已认证/已安全”作为证明其自身 F 输入充分的前提。

### SP-05：逐分支保持且不收窄

| 分支 | 必须回答的保持问题 |
|---|---|
| BG | 两组件正常时 C1/C2 的 source、协议与确认桥是否均成立？ |
| KO | QKD 故障包括非均匀/不等/泄漏等原边界；不假定其接口仍理想。KEM 存活路径及原中止规则如何模拟？ |
| QS | 指定 binding 存活是额外窄假设；还需单独解释认证。若仅这条成功，只能另报条件结果。 |
| QB | 不假设 KEM secrecy/binding；所有援引 K-PK/C2PRI 的步骤不得使用。 |
| QT | 原无界 ROM/QKD 声称单列；必须处理预测/碰撞余项与 RO 查询能力，不借计算 binding/MAC。 |
| FF | 无所需存活源时没有本轮承诺的非平凡安全目标；不能“证明保持”来补造原保证。 |

BG/KO/QS/QB/QT/FF 是既有审查分类，不是本轮新增 oracle。原分支表状态不变。

## 4. 最小候选结果范围，而非定理

优先审查 **C1 的单位置、HAKE-specific、原目标安全保持**，不是所有 context 的一般结论，也不是 C1/C2 联合保持。未来范围至少应明确：最终 Key-IND、matching 正确性、原 PFS 的实际语义及声明覆盖的原失败路径；若只能覆盖子集，标题和结论必须明确较窄范围。

现阶段连原/候选共同的 source 与实验接口都未闭合，故不能把 “Π_HAKE 安全则 Π_HAKE′ 安全”当作已成立命题。仅给这种形式而不给可验证条件，会把核心问题藏进前提，不构成贡献。

## 5. M7 进入条件

1. 人工批准一个位置明确的研究对象，及主张分支范围；本轮 C1 的 high 不是安全准入。
2. SP-01 中证明实际依赖的语义已有来源或明确审查裁决，任何附加假设单列，不暗中增强模型。
3. SP-02 的 baseline 和 candidate source 接口均可成立，或承认当前引用路线不可用并审查替代依据；不得借改原协议解决。
4. SP-03/04 存在可核查、非循环的查询/会话/确认映射。
5. SP-05 明确所有所称保持分支，归约损失不再用未知符号冒充上界。

当前以上条件未满足；**不满足进入 M7 formal theorem refinement 的条件**。可交付的是问题明确的框架，不是安全保持结果。详见 [义务矩阵](proof-obligation-matrix.csv) 与 [game 路线](game-transition-outline.md)。
