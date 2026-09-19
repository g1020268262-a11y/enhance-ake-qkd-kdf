# M4：Binding property analysis

状态：FIELD–SECURITY PROPERTY MAPPING COMPLETE / REVIEW PENDING。仅完成职责和证明义务映射，不作字段删除结论。阶段授权与验收见 [m4-proof-obligation.md](m4-proof-obligation.md) §1、§6。

## 1. 来源、证据级别与对象

[H26 原 HAKE](2026-1231.pdf) Fig.3 p13、§3.1 pp14–15 是输入位置和数据流依据；§2.5 pp7–9/Def.3–6 是最低安全目标依据，Def.7 pp10–11 是 QKD 接口依据。正文 UKS/KCI 是讨论，不自动扩成正式身份 agreement 目标。

[B23](sources/2023-167-boyd.pdf) §2.4、§4.1/Fig.8 pp20–22 用于理解 KEM-AKE 认证路径；[D24](sources/2023-1933-binding.pdf) Def.4.1/Fig.5–6 pp7–8 用于区分 binding 游戏；[X24](sources/2024-039-xwing.pdf) Def.7 p9 用于 C2PRI；[K25](sources/2025-657-kdf-20250410.pdf) Def.1–2 pp8–9、§4.2–4.3 用于 source/辅助信息和查询接口。版本及哈希沿用 [sources/README.md](sources/README.md)，不重新查新或改变 M2 结论。

- **事实**：字段在哪一操作中出现、哪一侧何时持有、MAC key 与 message 的区别。
- **原声明**：H 的 SK/PFS、单向确认机制、UKS/KCI 讨论。
- **候选职责**：该出现位置可能帮助实现哪些对应关系。不是必要性或充分性结论。
- **待证替代**：某精确游戏的保证如何成为 HAKE 原目标的独立证明依据。

[field-security-mapping.csv](field-security-mapping.csv) 的 18 行覆盖全部 11 个 component-context 位置，并补充 7 个 secret/global/session 依赖。每行只登记自己的出现位置；A/B 的两处 context、k* 的 secret/context 不能合并成一个删除对象。表中 Security Property 是候选辅助性质，只有明确映射至 final Key-IND、matching correctness、原 PFS 才进入既定研究目标；identity agreement/key independence 不是新加入的主安全目标。

## 2. 角色本地值：不预设诚实执行相等

H Fig.3 在最终 F 和 τ3 处复用了未加撇符号。M4 采用以下**本地变量读法**做依赖记账，不增加操作或宣称论文已有更细的事件模型：

| 值类 | Alice 本地来源 | Bob 本地来源 | 不可自动推得 |
|---|---|---|---|
| 第一贡献 | k1：Encaps(pk_b) 输出 | k1′：Decaps(sk_b,ct1) 输出 | 任意执行中 k1=k1′ |
| 第二贡献 | k2′：Decaps(sk_a,ct2) 输出 | k2：Encaps(pk_a) 输出 | 任意执行中 k2′=k2 |
| 临时贡献 | k_A*：Encaps(收到的 pk_e) 输出 | k_B*：Decaps(sk_e,收到的 ct*) 输出 | 验 tag 就无条件得到 k_A*=k_B* |
| QKD | k_qkd^A：GetKey 输出 | k_qkd^B：GetKeyById 输出或 ⊥ | 任意端点、ID、故障分支均相等 |

用 x^A/x^B 表示两方各自对身份、公钥、ID、tag 的本地视图。两方输入仍然是**原完整输入**：

```text
c_KEM^A = A^A || pk_a^A || B^A || pk_b^A || pk_e^A || k1  || k2' || k_A*
c_KEM^B = A^B || pk_a^B || B^B || pk_b^B || pk_e^B || k1' || k2  || k_B*
σ_KEM^A = k_A*                      σ_KEM^B = k_B*
c_QKD^P = A^P || B^P || qkdKeyId^P  σ_QKD^P = k_qkd^P
```

P 表示当前角色。两端同名字段一致只在相应正确性、合法接口和协议对应条件满足时才可使用，不能先假设所有 context 相等再证明认证。

τ3 的 Bob 本地 message 读取 k1′、k2，Alice 验证 message 读取 k1、k2′；其余字段也读取各自视图。这是将原式中局部变量显式标注的分析记号，**不是修改 τ3**，也不声称 EUF-CMA 已证明两方这些变量相等。旧 M1 简写仅可在来源说明或诚实正确性条件下理解，本轮不改动 M1 原始账本。

## 3. 五类 binding 职责

### 3.1 Identity Binding：A、B

**事实。** A 在 τ1 message、c_KEM[1]、c_QKD[1]；B 在 τ2 message、c_KEM[3]、c_QKD[2]。τ3 直接包含 τ1/τ2 的 tag 字节，不直接重写 A/B。身份和角色也属于会话/预期对端背景。（H Fig.3、p14）

应分开：

1. 身份认证：消息来自预期凭据持有者的协议级论证。
2. identity-to-key association：某最终 key 对应哪两个有序身份视图。
3. transcript binding：本地身份字节和被验证消息之间的对应。

把身份写入 hash 仅建立算法输入依赖，并不凭空认证身份。H pp17–18 的 UKS 讨论给出候选动机，但不是独立 injective agreement/UKS 游戏。

**可能的已有保证。** 预置凭据、τ1/τ2 认证路径及 H matching 定义。KEM K-PK binding 的游戏里没有 A/B 逻辑身份，不能单独覆盖此职责。QKD 的配对节点与认证通道也没有详细定义应用身份到节点的映射。

**缺口。** 若未来审查某一个身份出现位置，必须证明剩余记录与该位置所代表身份视图的非循环关联、编码区分、角色和 matching/Freshness 对应。另一 source 中仍有相同字符串不是自动替代证明。PO-01/03 保留两个独立位置的义务，不联合省略。OI-01/05 尚开放。

### 3.2 Credential Binding：pk_a、pk_b

**事实。** pk_a 是 ct2 的封装目标、c_KEM[2]；pk_b 是 ct1 的封装目标、c_KEM[4]。它们不直接出现在三个 MAC message 中。经 KEM 生成 k2/k1 再作为 MAC key 的依赖，不等于公钥字节直接被认证。（H Fig.3、p14）

候选问题是 key substitution、credential swapping 是否影响预期身份/会话的 key 关联。当前诚实 setup 没有授权恶意注册 oracle；这些术语是对应关系的审查问题，不在本轮构造额外攻击模型。

**已有保证与不足。** H p8、p15 的预分发/可信第三方/PKI 背景给出凭据来源前提，不给公钥到身份单射，也不表示在线存在签名。要考虑的链分别为：

- pk_a 路径：k2/k2′ 与 pk_a → 预期 A → 相关会话。
- pk_b 路径：k1/k1′ 与 pk_b → 预期 B → 相关会话。

X-BIND-K-PK 只可能帮助链的第一段；它不直接给凭据所有者和协议伙伴。同 key 是否出现、两次使用是否属于相应游戏域，也要先证明，不能由最终 F 输出相同倒推出 KEM key 相同。PO-02 与 PO-04 必须分别处理时序和泄漏；不能用一方的证明直接镜像覆盖另一方。

### 3.3 Ephemeral Binding：pk_e

**事实。** Bob 生成 pk_e；Alice 先验证含 pk_e、s、A 的 τ1，再封装 ct*；pk_e 另在 c_KEM[5] 和 τ3 message。Bob 拥有自己生成的 key，不代表 Alice 在所有故障分支收到的 key 都可当成诚实生成。

**候选职责。** 临时 credential 与 k* 的对应、收到的 key 与认证消息的对应、会话视图一致性。pk_e 不是 H SID；H 的 SID 是 ct1∥ct2，故不能仅凭 pk_e 的存在宣布 session uniqueness。

**待证替代的两层。**

- KEM 层：若实际实例满足适用攻击者和泄漏域下的 K-PK，则限制相同 KEM key 对应不同 pk 的碰撞。没有证明它适用于本 HAKE 执行前，不能使用。
- AKE 层：τ1 验证、凭据背景、会话与本地状态映射必须支持消息的来源和目标解释。B23 的整体 SK 结果不是一条任意时间点的“pk_e 已认证”引理，也不是单字段不影响 HAKE 的结论。

C2PRI 固定一个诚实 keypair，挑战为该 keypair 下的诚实封装，甚至给对手 sk；它约束不同密文再次解封到同一挑战 key，**不比较不同 pk**。因此不能代替 pk_e 的跨公钥职责，也不提供 session matching。PO-05 登记所有缺口，不判断删除后的行为。

### 3.4 Secret Binding：k1、k2、k*

必须区分三个问题：

| 问题 | 需要的保证类型 | 不能混淆为 |
|---|---|---|
| secrecy | 在允许泄漏和辅助信息下无法预测/区分秘密 | 两端数值一致 |
| consistency | 两角色使用的贡献与同一合法执行相对应 | 不同会话永不重用同一值 |
| uniqueness | 某定义域内没有造成安全影响的碰撞/别名 | IND 安全或 binding 自动保证所有意义的唯一性 |

k1/k2 是认证 MAC key 的来源，也是 τ3 message 和秘密 context 的成员；只说“认证已经完成”忽略了它们后续使用。EUF-CMA 通常针对特定 key 下的伪造，不自动提供跨不同 key 的 key-commitment。其 source/α 表达还受 M2 B1 约束；不能把 context 一律视为公开，也不能仅保留熵不变的论据。

k* 在**同一角色**中作为 σ_KEM 和 c_KEM[8] 出现两次，这是语法重复事实，不是已证冗余。它并未直接进入 τ3 message，而是经 F 影响确认 key。其 KEM secret 位置代表 KEM source 输入；末尾 context 位置是否还承担查询区分或 source 映射职责，须单独证明。C2PRI 不是“k* 无需进入 context”的定理。

K25 Def.1 将 context 包含在公开 α，H context 却包含 k1/k2/k*。这仍是 M2 B1 的接口问题；删除某一个重复值也不能被先当作解决了另外两个秘密 context 或全部 source 合法性。PO-06/07/08 保留这一义务，未提出新的 source 构造。

### 3.5 QKD Binding：qkdKeyId

**事实。** ID 是公开检索标识，在 τ2、τ3 message 和 c_QKD[3] 中出现；Bob 在 τ2 验证后据它调用 GetKeyById，返回 ⊥ 就中止。k_qkd 只作为 source secret，不在线发送。（H Def.7、Fig.3）

**已有保证。** 配对节点检索、key 一次输出、重复 ID 失败和理想黑盒认证通道。需要区分 ID 唯一性、随机 key 值相等概率、应用会话唯一性；它们不是同一保证。

**候选职责。** QKD key 与这一次 HAKE 会话、逻辑双方和 source 输入的关联。接口并未逐项给出 HAKE session 到 QKD endpoint 的完整关系，所以“QKD 已认证”不自动替代 c_QKD 的全部语义。τ2 的接口 ID 覆盖是 KEM 认证路径的条件性保证，不能在该路径失效时继续无条件引用。

PO-09 只检查黑盒边界的检索、同步、错误与一次性语义，不分析或攻击 QKD 设备内部。不得将 GetKeyById 的 ⊥ 分支改成继续计算。

## 4. 精确游戏与跨层缺口

| 参考保证 | 游戏范围 | 可作为哪类候选解释 | 仍缺什么 |
|---|---|---|---|
| D24 X-BIND-P-Q | 两个非 ⊥ 结果在 P 相同、Q 不同为获胜；HON 是诚实 keypair 加解封接口，LEAK 给 sk，MAL 可选材料及 Encaps/Decaps 组合；Def.4.1 针对 PPT | K-PK、K-CT 等局部对应限制 | 实例、QPT 扩展、生成域、合法泄漏、失败行为，以及到 H 身份/会话的桥接 |
| X24 C2PRI | 固定诚实 keypair 和诚实封装的挑战，给 sk 后找不同 ct 解到同一挑战 key | 特定诚实挑战下的密文第二原像限制 | 不给跨 pk、任意两输入碰撞、身份/角色/SID 或 final Key-IND |
| KEM IND-CPA/CCA | 给定挑战及合法查询下的 key 不可区分 | 原 KEM-AKE 保密与认证路径所需原语假设 | 不等同 binding、credential 归属或会话唯一性 |
| MAC EUF-CMA / KEM-AKE SK | 原假设域中不可伪造/协议 key 安全 | 原 τ1/τ2 路径的来源解释 | 完整多会话模拟、不同 key 的关系、可用时间点和故障分支 |
| H QKD 黑盒 | 理想配对检索与失败事件边界 | QKD source 的正确性及安全背景 | 应用身份/会话关联，及故障发生时仍可引用哪些保证 |
| K25 KDF/source 游戏 | source/α、诚实与非诚实登记、real-or-random 查询及 req | 待建立 final Key-IND 的证明接口 | B1–B7、源索引/重复查询/输出拆分与 H oracle 映射 |

任何候选替代不能只写“使用 KEM binding”。需列 X、P、Q、实例、PPT/QPT、泄漏范围、两条执行属于游戏哪种输入、目标性质和失败分支。MAL 不表示 H 自动允许恶意注册；HON 也不能无视接收材料的来源或合法 sk 泄漏。

## 5. 保证的生效时点

下列是局部先后关系，不假设网络两端 F 调用之间有全局同步：

| 程序点 | 可记录的事实 | 不可提前使用的结论 |
|---|---|---|
| setup | 预置长期 key 及预期 peer | 完美 identity binding、所有会话去重 |
| Alice 验 τ1 成功后 | 她可继续处理收到的 pk_e/s/A | 认证结论仍依赖合法 key、MAC、模拟与分支；非正式 Accept |
| Bob 验 τ2 成功后 | 他可解封 ct* 并查询 QKD | 不证明 Alice 已收到最终确认 |
| 本地 F 前 | 材料已按各角色流程获得；Bob 检索非 ⊥ | 尚无最终 τ3 支持的结论 |
| Bob F、拆分、发 τ3 | 确认 tag 已生成 | 不是 Alice 验证成功，不是双方同时完成 |
| Alice 拆分并验 τ3 成功 | 原单向机制的成功路径 | 不能反推 F 前已具备所有拟替代 guarantee |
| Alice 后续应用消息 | H p15 的隐式确认讨论 | 不属于 Fig.3，不能作为本轮默认输入 |

## 6. Hybrid 分支与不成立的捷径

沿用 [security-contract.csv](security-contract.csv) 的 BG/KO/QS/QB/QT/FF。这些是审查分类，不是新增攻击 oracle。

- BG/KO：正常 KEM-AKE 路径可能支持 τ1/τ2，但字段级职责和 source 接口仍需证明。
- QS：只是假定指定 binding 仍存活的较窄假设环境；保密性失效不自动保留 MAC 认证，不能无条件使用 τ1/τ2 来源。
- QB：KEM secrecy/binding 均不作安全假设；不能通过绑定性质补回缺口。
- QT：原无界 ROM/QKD 声称不能依赖计算性 binding/MAC 安全。M2 的界和 RO 接口问题继续开放。
- FF：不补造原协议未承诺的非平凡保证。

所有位置状态保持 hypothesis / proof obligation / requires validation。没有任何字段被分类为已证必要、已证冗余或已证不可替代。后续如何验证见 [m4-proof-obligation.md](m4-proof-obligation.md)。
