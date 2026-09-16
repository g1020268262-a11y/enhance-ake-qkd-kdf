# M0 研究范围与安全合同（2026-09-16）

## 研究对象与证据边界

基线是 Clermont–Henrich 的 `Π_HAKE`（本地 `2026-1231.pdf`，SHA-256 `E1F894E1F2C0973F230DE343B2133AE6C399621487EF6596C15FBF2507E58A62`），以论文 Figure 3、§2.4–2.6、§3.1、§4 为准。协议将 KEM-AKE 和黑盒 QKD 的 `(secret, context)` 输入二元 KDF `F`；原文写 `σ_KEM=k*`、`c_KEM=A∥pk_a∥B∥pk_b∥pk_e∥k_1∥k_2∥k*`，`σ_QKD=k_qkd`、`c_QKD=A∥B∥qkdKeyId`，512-bit 输出拆为确认用 `k_h^1` 和最终 256-bit 会话密钥 `k_h^2`（第 13–15 页）。这不是预先批准任何字段可删。`claims-register.csv` 逐项登记论文证据及新证明义务。

## 第一轮允许的协议转换

记 `Π−{x@c}` 为只在明确列出的角色、KDF 调用、context 位置删除字段 `x` 的出现位置；不删除字段本身，也不改变编码可解析性、source 顺序、label 或输出长度。两侧采用同一投影。保留 Figure 3 的消息/顺序、所有 MAC 密钥与完整输入、密文及公钥生成检查、`GetKey/GetKeyById` 和一次性/失败语义、`σ_KEM=k*`、`σ_QKD=k_qkd`、`k_h^1∥k_h^2` 的分割及 `τ_3` 的方向。特别是 `k*` 在 secret 输入和 context 各出现一次，若只删后者，前者仍在。初轮单字段、单位置；联合删减须另证前提在每次投影后仍成立。更改报文、MAC、QKD 接口、secret、确认或分割的方案另立版本，不借用本合同。

## 攻击者、挑战会话与赢的游戏

主模型沿用论文所述 CK01/其 PQ 扩展：攻击者控制网络消息并可启动并发会话，拥有 `Corrupt`（当前参与方内部状态）、未完成会话的 `Session-State`、已完成会话密钥的 `Reveal`、`Expire-Session`（删除该会话派生密钥）、以及对**已完成且 fresh** 会话的 `Test`；对端 matching session 同受 freshness 限制。Matching 依 Definition 3：对端、相反角色和相同的外部唯一 `s`；唯一 `s` 的建立由上层保证，不在论文模型内证明。Definition 4 的 freshness 是非正式表述：被测会话及 matching 会话的密钥与会话状态均未 reveal；若参与方已被 corrupt，该会话必须先 expire。允许 expire 后腐化所体现的 PFS，但不扩大成任意状态泄漏后的恢复。`Test` 返回实际 `k_h^2` 或等长均匀串；攻击者猜测隐藏位，目标是使 Key-IND advantage 非可忽略，同时匹配且未受损双方应得到同一密钥（Definition 5–6，第 8–9 页）。QPT 攻击者不获协议 oracle 的量子叠加访问；无界攻击者仅对应下述条件 ITS 分支。完整 CK01 oracle 细节论文指向所引 Boyd/CK01 工作，M3 再精确定义；这里不填造未给出的次数/时序规则。

原始 setup 是双方长期 KEM 公钥与身份绑定、彼此知道预期对端公钥，且密钥由诚实方在攻击者介入前生成（第 8、12、15 页）。不擅自把该关系加强为公钥唯一归属/可恶意注册。QKD 是包含经典认证通道的黑盒，`GetKey` 产生随机密钥及唯一 ID，配对节点 `GetKeyById` 可返回密钥或 `⊥`，同一 key 最多输出一次；不把 QKD fail 当成仅仅“秘密泄漏”（Definition 7、Lemma 1，第 10–11 页）。

## 主目标、分支与不得偷换的主张

在**相同 setup、CK01 freshness、攻击者范围、QKD 黑盒及 KDF 理想化条件**下，首先重证匹配会话正确性、最终密钥 SK/Key-IND 与其涵盖的 PFS。分别核对原 Theorem 1 的 QPT `2·min(KEM-AKE 归约项, Pr[QKD fail])` 两条路径：QKD fail 时保留 KEM 计算安全；KEM 计算假设失效时保留 QKD 路径。另核对 Theorem 2 在随机预言机模型、QKD 未失效条件下的无界攻击者界 `2·Pr[QKD fail]`；它不等于具体 SHA-3 对无界攻击者的无条件现实安全（第 16–19 页）。不能以计算性 C2PRI/K–PK 等 binding 项悄悄填入 QKD-only/ITS 分支；若 KEM secrecy 可坏但仍须 binding，结论只能称“新增 binding 假设下的条件保持”。是否允许 KEM binding 也坏、原证明在何种意义上覆盖该故障，留给 M3 逐分支核对；当前不宣称删减已保持任何分支。

认证/确认目标只按实际角色：`τ_1` 由 Bob 产生、Alice 验证，`τ_2` 由 Alice 产生、Bob 验证；派生后 `τ_3` 由 Bob 使用 `k_h^1` 产生、Alice 验证。原文只称 Bob→Alice 单向显式 key confirmation，Bob 的反向确认仅在 Alice 后续用 `k_h^2` 发消息时才可能是隐式的，Figure 3 不含该消息（第 13、15 页）。不可将这一点写成双方在同一时刻的显式确认定理。

| 原论文已形式证明（在其模型内） | 原论文文字讨论/流程说明 | 本研究新增目标（均未证明） |
|---|---|---|
| Definition 6 与 Lemma 1–3、Theorem 1–2：匹配正确性、SK/Key-IND、CK01-PFS、两来源的条件界及 ROM 条件 ITS | §3.1 单向确认；§4 UKS、KCI 的论述，未列独立安全游戏/定理 | context 投影后的原目标保持、下表语义事件与分离边界 |

## 删减相关性质的研究定位

以下是**本研究拟定义的事件/游戏草案**，不是论文已有事件或已证结论。令 `Send_i(m, v)`、`Verify_i(m, v)`、`Derive_i(v, K)`、`Accept_i(v, K)` 分别记录角色 `i∈{A,B}` 的发送、成功验证、派生与接受；`v` 含 `(A,B,role,s,pk_a,pk_b,pk_e,ct_1,ct_2,ct*,qkdKeyId)` 的实际可得值，`K=k_h^2`。接受事件必须在 M1 按 Figure 3 的实际程序点定义：Bob 验证 `τ_2`、取得 QKD key 并派生后，Alice 验证 `τ_3` 后；不可凭空给 Bob 添加收到确认的事件。

| 性质 | 第一轮可检查目标 | 定位 |
|---|---|---|
| identity/role agreement | `Accept_A` 应对应同 `A,B,s`、相反角色/公钥映射的 `Send_B(τ_3)`；`Accept_B` 应对应同参数的 `Send_A(τ_2)`，**不要求 Alice 已 Accept**。是否唯一对端另定 | 主定理的语义绑定条件；非原文独立定理 |
| contribution agreement | 对 matching 且双方均 `Derive` 的实例，KEM/QKD source 引用、`qkdKeyId` 与 `K` 相同；对只一方完成者不虚构对端完成 | 辅助不变量，必要时作主定理条件 |
| session separation | 定义 `Bad_alias`：两次可查询或已派生执行的 `(secret, retained context, label, L)` 相同而 `v` 的必要身份/角色/会话/贡献语义不同；要求其概率有明确归约界 | 主定理 Bad 事件；不要求不同会话密钥必不同 |
| key independence | 扩展游戏允许指定 fresh 目标与另一会话的合法 Reveal/Test 后区分目标 `K` 与随机；需另定双会话 freshness、查询一致性和优势 | 扩展性质；单 Test SK 不自动蕴含 |
| transcript integrity | 每个 `Verify_A(τ_1)`、`Verify_B(τ_2)`、`Verify_A(τ_3)` 应对应发送方对**该 tag 实际 MAC 输入**的 `Send`；不要求 Figure 3 未覆盖字段也受保护 | 辅助认证对应；全 transcript 强化为扩展 |

论文第 18 页对 UKS/KCI 作文字论述，不把它们升级为独立已证游戏。PCS、协商/降级、QKD key 重复输出、恶意注册、状态回滚、组合式安全与部署攻击均不在第一轮；若构造范围外 separation，必须明确标为抽象反例，而非原 HAKE 漏洞。

## M0 交付判定

本文件固定了对象、投影边界、攻击者、可挑战会话、赢的游戏与待保留分支；登记表区分原形式结果、文字讨论和新增目标。M0 的范围定义已完成，**安全保持和字段可删均未证明**。M1 须复核 Figure 3 的字段/接受时点与第 7、13、17 页对 SHA-3 输出长度/实例的表述；M3 再以原始形式定义补全非正式 freshness 和 Hybrid failure-branch compatibility，不能以本页替代证明。
