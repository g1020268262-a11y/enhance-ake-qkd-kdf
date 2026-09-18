# M1：Clermont–Henrich HAKE 原协议基线

本文件只重建论文中的 `Π_HAKE`，不定义删减变体，也不判断任何字段能否省略。事实以仓库中的 `2026-1231.pdf` 为准；下文的“直接覆盖”只指 Figure 3 的 MAC 消息中实际出现的字节，不自动等于独立安全定理。

## 1. 版本、证据与边界

| 项目 | 固定值或位置 |
|---|---|
| 论文 | Sebastian Clermont、Johanna Henrich，*The Best of Both Worlds: Hybrid Authenticated Key Exchange for QKD(N) without Signatures*，本地 `2026-1231.pdf`，26 页 |
| SHA-256 | `E1F894E1F2C0973F230DE343B2133AE6C399621487EF6596C15FBF2507E58A62` |
| 协议图与消息/MAC | Figure 3，PDF/印刷第 13 页；文字解释见 §3、§3.1，第 12–15 页 |
| 原语接口 | KEM §2.2，第 4–5 页；MAC §2.3，第 5–6 页；multi-input KDF §2.4，第 6–7 页 |
| 参与方、匹配与 freshness | §2.5、Definition 3–6，第 7–9 页；更完整的 CK01/Boyd 游戏由论文外引 |
| QKD 黑盒 | §2.6、Definition 7、Lemma 1，第 10–11 页 |
| 证明边界 | Lemma 2，第 15 页；Lemma 3、Theorem 1，第 16–17 页；UKS/KCI 文字讨论及 Theorem 2，第 17–19 页 |
| 实现用散列说法 | §2.4 第 7 页称 SHA-3-256；§5.1 第 20 页称 SHA3-512；见开放问题 O1 |

页码按 PDF 的 1-based 页序，恰与正文印刷页码一致。协议事实取 Figure 3 和 §3.1；Lemma/Theorem 仅用于说明原论文声明的范围，不在 M1 重证。

## 2. 执行前条件与双方初态

Alice 持有长期 KEM `(sk_a, pk_a)` 及预期对端的 `pk_b`；Bob 持有 `(sk_b, pk_b)` 及预期对端的 `pk_a`。长期公钥在攻击者介入前由诚实方生成、对潜在通信伙伴可用；§3 第 12 页要求密钥对与各自身份绑定，彼此知道预期对端公钥。§3.1 第 15 页列出直接预分发、可信 QKDN controller、PKI 等可能的分发办法，**没有指定唯一必需的 PKI**。论文没有明确要求身份到公钥映射为单射，也没有把恶意公钥注册纳入 Figure 3。Bob 的 `pk_e,sk_e` 则是本次会话收到 `ct_1` 后生成的临时 KEM 密钥对。（§2.5 第 8 页；§3 第 12 页；Figure 3 第 13 页；§3.1 第 14–15 页）

双方可访问彼此配对、直接通信的 QKD 节点。黑盒包括底层经典认证通道；具体节点通信与 endpoint 绑定编码未在 Figure 3 展开。上层被假定提供唯一 session identifier；Figure 3 在本次执行中令 `s = ct_1∥ct_2`。这两种表述的关系应在后续模型中核对，M1 不补造唯一性证明。（Definition 3 第 8 页；Definition 7 第 10 页；§3 第 12 页；Figure 3 第 13 页）

## 3. 符号表

“获得”指诚实执行中的持有，不表示攻击者看不到线上字节。除长期密钥和 QKD 一次输出规则外，Figure 3 未逐变量规定擦除时刻；表中的“会话内”不暗示已经擦除。

| 符号 | 类型；产生者与获得者 | 线上/保密性；生命周期与作用 | 依据 |
|---|---|---|---|
| `A`, `B` | Alice、Bob 的身份；执行前双方知道预期身份 | Figure 3 箭头不单独发送；公开语义标识；用于 MAC/KDF context，跨会话身份 | §3 第 12 页；Fig. 3 第 13 页 |
| `(sk_a,pk_a)` | Alice 长期 KEM 私/公钥对；Alice 有 `sk_a,pk_a`，Bob 已知 `pk_a` | 图中不发送；`sk_a` 秘密、`pk_a` 公开；长期；`pk_a` 是 `ct_2` 封装目标，`sk_a` 解封 `ct_2` | §2.5 第 8 页；§3 第 12 页；Fig. 3 第 13 页 |
| `(sk_b,pk_b)` | Bob 长期 KEM 私/公钥对；Bob 有 `sk_b,pk_b`，Alice 已知 `pk_b` | 图中不发送；`sk_b` 秘密、`pk_b` 公开；长期；`pk_b` 是 `ct_1` 封装目标，`sk_b` 解封 `ct_1` | 同上 |
| `(pk_e,sk_e)` | Bob 会话临时 KEM 密钥对；Bob 持有两者，Alice 收到 `pk_e` | `pk_e` 在第二条消息发送，`sk_e` 不发送；临时/秘密私钥；承接 `ct*` | Fig. 3 第 13 页；§3.1 第 14 页 |
| `ct_1`, `k_1` | Alice 以 `pk_b` 封装得到的密文/密钥；Bob 收到 `ct_1` | `ct_1` 第一条消息发送、公开；`k_1` 不发送、会话秘密；`k_1` 验证 `τ_1` 并进 `c_KEM` | Fig. 3 第 13 页 |
| `k_1'` | Bob 以 `sk_b,ct_1` 解封所得；Bob 持有 | 不发送、会话秘密；作为 `τ_1` 的 MAC key；诚实 KEM 正确时等于 `k_1` | Fig. 3 第 13 页；§2.2 第 5 页 |
| `ct_2`, `k_2` | Bob 以 `pk_a` 封装得到的密文/密钥；Alice 收到 `ct_2` | `ct_2` 第二条消息发送、公开；`k_2` 不发送、会话秘密；验证 `τ_2` 并进 `c_KEM` | Fig. 3 第 13 页 |
| `k_2'` | Alice 以 `sk_a,ct_2` 解封所得；Alice 持有 | 不发送、会话秘密；作为 `τ_2` 的 MAC key；诚实 KEM 正确时等于 `k_2` | Fig. 3 第 13 页；§2.2 第 5 页 |
| `ct*`, `k*` | Alice 以 `pk_e` 封装得到的密文/密钥；Bob 收到 `ct*` 并解封得 `k*` | `ct*` 第三条消息发送、公开；`k*` 不发送、会话秘密；`k*` 同时是 `σ_KEM` 和 `c_KEM` 的末项 | Fig. 3 第 13 页；§3.1 第 14 页 |
| `k_qkd`, `qkdKeyId` | Alice 调 `GetKey` 从本侧 QKD 节点取；Bob 用收到的 ID 调配对节点 `GetKeyById` | ID 在第三条消息发送、公开；`k_qkd` 不在线上发送、黑盒输出秘密；同一 key 最多输出一次；分别作 `σ_QKD` 与 `c_QKD` 的 ID | Def. 7 第 10 页；Fig. 3 第 13 页 |
| `s` | Bob 与 Alice 各自由 `ct_1∥ct_2` 计算 | 不单独发送；公开可重建的会话标识；会话内用于 `τ_1`,`τ_2`；其全局唯一性另由上层假设 | Def. 3 第 8 页；Fig. 3 第 13 页 |
| `τ_1` | Bob 用 `k_1'` 生成；Alice 在第二条消息收到并用 `k_1` 验证 | 公开传输的 MAC tag；会话内，成功验证后 Alice 才继续 `ct_2` 解封、QKD 取键；也是 `τ_3` 的消息项 | Fig. 3 第 13 页 |
| `τ_2` | Alice 用 `k_2'` 生成；Bob 在第三条消息收到并用 `k_2` 验证 | 公开传输的 MAC tag；会话内，成功验证后 Bob 才解封 `ct*`、取 QKD key；也是 `τ_3` 的消息项 | Fig. 3 第 13 页 |
| `k_h` | 双方各自运行同一 `F` 得 512-bit 输出 | 不发送、派生秘密；会话内，分成 `k_h^1∥k_h^2` | Fig. 3 第 13 页；§3.1 第 14–15 页 |
| `k_h^1` | `k_h` 前 256 bit；双方可得 | 不发送、派生秘密；作 `τ_3` 的 MAC key，不是最终会话密钥 | Fig. 3 第 13 页；§3.1 第 15 页 |
| `k_h^2` | `k_h` 后 256 bit；双方可得 | 不发送、派生秘密；最终会话密钥；Figure 3 不给出具体擦除时刻 | Fig. 3 第 13 页；§3.1 第 15 页 |

## 4. Figure 3 消息图与精确操作

图中的四个箭头仅为 Figure 3 的 HAKE 线上消息。QKD 节点调用是本地接口，`s`、KDF 输入、`k_1/k_2/k*` 不作为独立协议报文发送。

```mermaid
sequenceDiagram
    participant Alice
    participant Q_A as Alice QKD node
    participant Bob
    participant Q_B as Bob QKD node
    Note over Alice,Bob: 预置长期密钥与预期对端公钥
    Note over Alice: (k_1,ct_1) ← Encaps(pk_b)
    Alice->>Bob: ct_1
    Note over Bob: (pk_e,sk_e) ← KGen; k_1' ← Decaps(sk_b,ct_1)
    Note over Bob: (k_2,ct_2) ← Encaps(pk_a); s ← ct_1∥ct_2
    Note over Bob: τ_1 ← Tag(k_1', pk_e∥s∥A)
    Bob->>Alice: pk_e, τ_1, ct_2
    Note over Alice: s ← ct_1∥ct_2; 验证 τ_1，失败则 fail
    Note over Alice: k_2' ← Decaps(sk_a,ct_2); (k*,ct*) ← Encaps(pk_e)
    Alice->>Q_A: GetKey
    Q_A-->>Alice: (qkdKeyId,k_qkd)
    Note over Alice: τ_2 ← Tag(k_2', qkdKeyId∥ct*∥s∥B)
    Alice->>Bob: ct*, qkdKeyId, τ_2
    Note over Bob: 验证 τ_2，失败则 fail; k* ← Decaps(sk_e,ct*)
    Bob->>Q_B: GetKeyById(qkdKeyId)
    Q_B-->>Bob: k_qkd 或 ⊥
    Note over Bob: 若 ⊥ 则 fail；否则运行 F，拆分 k_h^1∥k_h^2
    Note over Bob: τ_3 ← Tag(k_h^1, k_1∥qkdKeyId∥pk_e∥τ_1∥k_2∥τ_2)
    Bob->>Alice: τ_3
    Note over Alice: 已运行同一 F；接收后拆分 k_h^1∥k_h^2
    Note over Alice: 验证 τ_3，失败则 fail
```

| 步骤 | 原文操作、线上内容与失败点 |
|---|---|
| 1 | Alice：`(k_1,ct_1) ←$ Encaps(pk_b)`；发送 `ct_1`。 |
| 2 | Bob：`(pk_e,sk_e) ←$ KGen(1^λ)`；`k_1' ← Decaps(sk_b,ct_1)`；`(k_2,ct_2) ←$ Encaps(pk_a)`；`s ← ct_1∥ct_2`；`τ_1 ←$ Tag(k_1',pk_e∥s∥A)`；发送 `(pk_e,τ_1,ct_2)`。 |
| 3 | Alice：同样计算 `s`；`Vrfy(k_1,pk_e∥s∥A,τ_1)` 失败即 `fail`；之后 `k_2' ← Decaps(sk_a,ct_2)`，`(k*,ct*) ←$ Encaps(pk_e)`，`(qkdKeyId,k_qkd) ←$ GetKey`，`τ_2 ←$ Tag(k_2',qkdKeyId∥ct*∥s∥B)`；发送 `(ct*,qkdKeyId,τ_2)`。Figure 3 的 QKD 返回元组顺序写 `k_qkd,qkdKeyId`，Definition 7 写 `qkdKeyId,k_qkd`；两处均指同一对值。 |
| 4 | Bob：`Vrfy(k_2,qkdKeyId∥ct*∥s∥B,τ_2)` 失败即 `fail`；`k* ← Decaps(sk_e,ct*)`；`k_qkd ← GetKeyById(qkdKeyId)`，若 `⊥` 则 `fail`；然后运行 `F`、拆分 `k_h`、生成 `τ_3`，发送 `τ_3`。 |
| 5 | Alice：运行与 Bob 同一参数的 `F`；Figure 3 在收到 `τ_3` 后列出拆分 `k_h` 与验证 `Vrfy(k_h^1,k_1∥qkdKeyId∥pk_e∥τ_1∥k_2∥τ_2,τ_3)`；失败即 `fail`。 |

Figure 3 对三个 `Vrfy` 失败写 `⊥`，§2.3 第 5 页却将 `Vrfy` 定义为布尔返回；这里仅采用共同语义“验证不通过则 fail”，不猜测具体 API 编码。图中没有单列 KEM `Decaps` 失败、密文格式检查、所有中间秘密的擦除步骤。（见 O2、O4、O5）

## 5. MAC 的精确覆盖

`s` 在下表展开为 `ct_1∥ct_2`。这里“直接”只表示当前 tag 的 **MAC message** 中逐项出现；使用某值作为 MAC key、KEM 输入或 KDF secret 另列，不偷换为该值直接被 MAC 消息覆盖。`τ_3` 消息中确实含 `τ_1`,`τ_2` 两个 tag 的字节，但没有直接重写它们各自消息里的全部字段。

| Tag | 生成者 → 验证者；MAC key | 完整 MAC message（按 Figure 3） | 当前 tag 直接覆盖 | 只经另一个 tag 间接出现 | 验证时点、失败行为 |
|---|---|---|---|---|---|
| `τ_1` | Bob 用 `k_1'` → Alice 用 `k_1` | `pk_e∥s∥A = pk_e∥ct_1∥ct_2∥A` | `pk_e,ct_1,ct_2,A` | 无 | Alice 收到第二条消息后、`Decaps(sk_a,ct_2)` 和 `GetKey` 前；失败即 `fail` |
| `τ_2` | Alice 用 `k_2'` → Bob 用 `k_2` | `qkdKeyId∥ct*∥s∥B = qkdKeyId∥ct*∥ct_1∥ct_2∥B` | `qkdKeyId,ct*,ct_1,ct_2,B` | 无 | Bob 收到第三条消息后、`Decaps(sk_e,ct*)` 和 `GetKeyById` 前；失败即 `fail` |
| `τ_3` | Bob 用 `k_h^1` → Alice 用 `k_h^1` | `k_1∥qkdKeyId∥pk_e∥τ_1∥k_2∥τ_2` | `k_1,qkdKeyId,pk_e,τ_1,k_2,τ_2` | `τ_1` 的 message 中有 `A,ct_1,ct_2`；`τ_2` 的 message 中有 `B,ct*,ct_1,ct_2` | Alice 收到最后一条消息并拆分 `k_h` 后；失败即 `fail`；Bob 不验证来自 Alice 的最终-key tag |

`k_1'`/`k_1` 与 `k_2'`/`k_2` 分别是前两个 MAC 的密钥；`k*` 和 `k_qkd` 进入 KDF、影响 `k_h^1`，因此关联 `τ_3` 的 MAC key。这是操作依赖，不是上述 MAC message 的直接字段覆盖，也不能单凭依赖推得 identity/partnering 定理。§3.1 第 15 页称最终 MAC 认证“entire transcript”，但 Figure 3 给出的直接输入仅为上表公式；此处以公式为可复核基线，把正文措辞与形式化覆盖范围的关系留作 O6。

## 6. KDF、完成时点和原安全陈述

双方在 Figure 3 中各运行一次 `F`，参数为两个固定顺序的 `(secret,context)` 输入对、label `"KEM-QKD-Hybrid KEX"`、输出长度 512 bit。`σ_KEM=k*`，`c_KEM=A∥pk_a∥B∥pk_b∥pk_e∥k_1∥k_2∥k*`；`σ_QKD=k_qkd`，`c_QKD=A∥B∥qkdKeyId`。详见 [kdf-dataflow.md](kdf-dataflow.md)；注意 context 含 `k_1,k_2,k*`，不能统称公开 transcript。（§2.4 第 6–7 页；Figure 3 第 13 页；§3.1 第 14–15 页）

| 方 | 派生与本地图示时点 | 能确认的事与不能擅称的事 |
|---|---|---|
| Bob | 验证 `τ_2`、成功取 `k_qkd` 后运行 `F`，立即拆为 `k_h^1∥k_h^2`，随后用 `k_h^1` 发 `τ_3`。 | Bob 此时已取得最终 `k_h^2`，但 Figure 3 没有 Alice → Bob 的最终密钥确认消息；发出 `τ_3` 不等于 Alice 已收到并验证。 |
| Alice | 发送 `τ_2` 后运行 `F` 得 `k_h`；Figure 3 在收到 `τ_3` 后列出拆分 `k_h^1∥k_h^2`、用 `k_h^1` 验证 `τ_3`。 | Alice 在验过 `τ_3` 后才有图示的成功结束路径；收到 tag 或本地派生本身不等于验证成功。 |

论文没有给 `Accept_A`、`Accept_B` 的正式事件定义，也未规定“完成”是否与计算出 `k_h^2`、最终 MAC 验证或应用交付完全同义。§2.5 第 8 页仅将 completed session 解释为已计算 session key；M1 使用“已派生”“已验证”“图示成功路径”分开描述，不自造精确 Accept oracle。§3.1 第 15 页明确只称 Bob → Alice 的单向 explicit key confirmation；Alice 日后首次用 `k_h^2` 发应用消息可能给 Bob 隐式确认，但这不是 Figure 3 的消息。

原论文的证明边界：Lemma 2 是子协议独立性；Lemma 3 引用 Boyd 等 KEM-AKE 结果并给证明概要；Theorem 1 在其 CK01/PQ、combiner 模型下给 QPT hybrid SK 界；Theorem 2 是随机预言机模型下的条件无界攻击者声明。§4 的 UKS/KCI 段落是文字讨论，不作为本文件新证的独立游戏。（第 15–19 页）

## 7. QKD black-box 接口

Definition 7（第 10 页）规定 `GetKey` 无入参，在 Alice 侧选取可用 QKD key 并返回该 key 与唯一 `qkdKeyId`；Alice 把 ID 随第三条消息送 Bob。Bob 在配对节点以 `GetKeyById(qkdKeyId)` 取同一 key，或得专用失败符号 `⊥`，Figure 3 随即 `fail`。同一个 key 最多输出一次，已使用 ID 的重复 `GetKeyById` 返回 `⊥`。黑盒包含 QKD 的经典认证通道；`QKD fail` 在第 10–11 页囊括任何偏离理想行为，包括同 ID 不同 key、非均匀 key、常量输出、实现缺陷或侧信道，而非只指秘密泄漏。节点内部存储、失败概率如何实例化和 endpoint 绑定内部机制未在 Figure 3 明示，不在 M1 发明。

## 8. 一条完整诚实执行 trace（正确性 sanity check）

取执行前已有可信身份–长期公钥绑定、双方 KEM 正确、MAC 正确、QKD 未发生 `QKD fail` 且未重复取 key 的正常分支。该条件化 trace 只说明相同输入如何产生相同结果，**不是安全证明**。（§2.2–2.3 第 5–6 页；Definition 7 第 10 页；Figure 3 第 13 页）

1. Alice 对 `pk_b` 执行 `Encaps`，本地得 `(k_1,ct_1)`；发 `ct_1`。Bob 以 `sk_b` 解封得到 `k_1'=k_1`。
2. Bob 生成 `(pk_e,sk_e)`，对 `pk_a` 封装得 `(k_2,ct_2)`，以 `s=ct_1∥ct_2` 和 `k_1'` 计算 `τ_1=Tag(k_1',pk_e∥s∥A)`；发 `(pk_e,τ_1,ct_2)`。
3. Alice 重建相同 `s`，以 `k_1` 验证 `τ_1`；正常分支继续。她以 `sk_a` 解封 `ct_2` 得 `k_2'=k_2`，对 `pk_e` 封装得 `(k*,ct*)`。
4. Alice 调本侧 `GetKey` 得 `(qkdKeyId,k_qkd)`，以 `k_2'` 计算 `τ_2=Tag(k_2',qkdKeyId∥ct*∥s∥B)`；发 `(ct*,qkdKeyId,τ_2)`。这里将 Definition 7 的元组顺序用于叙述；Figure 3 图示顺序相反但命名值相同。
5. Bob 用 `k_2` 验证 `τ_2`，再用 `sk_e` 解封 `ct*` 得与 Alice 相同的 `k*`；他以 `qkdKeyId` 在配对节点调用 `GetKeyById` 得与 Alice 相同的 `k_qkd`，而非 `⊥`。
6. 两侧身份、公钥、`k_1,k_2,k*`、`qkdKeyId` 相同，固定 label、source 顺序与 512-bit 长度也相同；因此各自 `σ_KEM,c_KEM,σ_QKD,c_QKD` 相同。确定性的 `F` 输出相同的 `k_h`，从而相同的 `k_h^1` 与 `k_h^2`。（§2.4 第 6 页）
7. Bob 以 `k_h^1` 计算 `τ_3=Tag(k_h^1,k_1∥qkdKeyId∥pk_e∥τ_1∥k_2∥τ_2)` 并发给 Alice；Alice 在图示位置拆分自己的 `k_h`，以同一 `k_h^1` 验证 `τ_3` 成功。此时双方均已取得同一个最终 `k_h^2`；只有 Alice 收到 Bob → Alice 的显式 key confirmation，Bob 没有收到反向确认。

## 9. Open Questions / Ambiguities 与 M0 核对

| ID | 原文位置 | 待核对之处；M1 处理 | 后续材料/步骤 |
|---|---|---|---|
| O1 | §2.4 第 7 页；§5.1 第 20 页；Fig. 3 第 13 页 | 前处说实现以 SHA-3-256，后处说 key combination 用 SHA3-512，图与 §3.1 要求 512-bit 输出。M1 记录三种说法，不自行选定精确实现。 | M2/实现源码或作者澄清；M3 固定论文级理想化与具体实现界线 |
| O2 | §2.3 第 5 页；Fig. 3 第 13 页 | MAC `Vrfy` 定义为 `true/false`，图用 `⊥ = Vrfy(...)` 作为失败条件。M1 只记录失败即终止的共同语义。 | M3 若形式化，固定返回类型 |
| O3 | §2.5 第 8–9 页；Fig. 3 第 13 页 | completed/Test 以“已计算 session key”叙述，但 Figure 3 不给正式 Accept 事件；Alice 的最终确认晚于本地 `F`，Bob 无反向确认。 | Boyd/CK01 原文与 M3 事件定义 |
| O4 | Fig. 3 第 13 页；§2.5 第 8 页 | 图未指定 `k_1,k_2,k*,k_qkd,sk_e,k_h^1` 何时擦除；CK01 的 `Expire-Session` 删除派生 session key，不能自动填到图中每个中间量。 | M3 状态/腐化时序模型 |
| O5 | §2.2 第 5 页；Fig. 3 第 13 页 | 图对 MAC 失败与 `GetKeyById=⊥` 有显式 `fail`，未列 `Decaps`/公钥/密文格式失败的单独检查。`research-scope.md` 的“密文及公钥生成检查”若被理解成图内已有检查，会过度断言。 | M3/Boyd 原图或实现；必要时回修 M0 措辞 |
| O6 | §3.1 第 15 页；Fig. 3 第 13 页 | 正文称最终 MAC 认证“entire transcript”，但 Figure 3 的 `τ_3` message 是六项固定公式，其他字段最多经先前 tag、KDF key 或上下文产生依赖；不能写作 `τ_3` 全部直接覆盖。 | M2 Boyd；M3 明确 correspondence 目标 |
| O7 | Def. 3 第 8 页；Fig. 3 第 13 页 | 模型要求上层保证唯一 `s`，图用 `ct_1∥ct_2`；原文未给该拼接编码或全局唯一性的独立证明。 | M3 partnering/编码，必要时核对 CK01 |
| O8 | Def. 7 第 10 页；§3 第 12 页 | 配对 QKD 节点、直接连接、认证经典通道已假定；`qkdKeyId` 对端点如何绑定、重复/失败状态的底层实现没有给出。 | M3 只沿用黑盒；不另造攻击模型 |
| O9 | §2.4 第 6–7 页；§3.1 第 14 页 | `∥` 给出字段顺序，但各值长度、序列化、长度前缀、底层 RO-KDF 内部调用次数未在该 PDF 精确给出。 | M2 Backendal 原文；实现源码；M3 再固定形式模型 |
| O10 | Fig. 3 第 13 页；§5.2 第 21 页 | Figure 3 有四个 HAKE 网络箭头；性能段称五次 sequential message transmissions。可能计入 §5 的服务控制传输，但论文未在该处解释，M1 按 Figure 3 画四箭头。 | 若需实现级时序，M2 查实现；不改协议图 |
| O11 | §2.5 第 8–9 页；Lemma 3 第 16 页 | CK01 oracle 细节与 Boyd 组件定理只被引用/概述，不可由本 PDF 补齐全部查询次数、状态内容和 partnering 细节。 | M2 Boyd；M3 CK01/Boyd 原定义 |
| O12 | §2.2 第 5 页；Fig. 3 第 13 页 | 通用 KEM 接口把 `Encaps(pk)` 的输出写作 `(ct,k)`，Figure 3 的各次赋值写作 `(k_i,ct_i)`；M1 遵循 Figure 3 的变量名及对应关系，不把元组书写顺序当成额外操作。 | M3/实现接口如需精确返回序，再核对源码 |
| O13 | Lemma 2 第 15 页；Fig. 3 第 13 页 | Lemma 2 将两子协议称为独立，Figure 3 的 `τ_2` MAC message 却直接含 QKD 输出的 `qkdKeyId`。这至少是跨层数据依赖；是否仍满足该引理所用的精确定义，本 PDF 的证明概要没有展开。M1 不把“独立”改写成“互不读取任何字段”。 | M2 Backendal/Boyd 所需接口；M3 明确组件边界 |

M0 的协议对象、单向确认方向、KDF 两输入对及 QKD 一次输出大体与 Figure 3 一致；需警惕的措辞是 O5 的“检查”、O3 中尚未形式定义的 `Accept` 草案，以及 `claims-register.csv` 的 C06 若被解读为“完全不存在跨组件数据依赖”（O13）。UKS/KCI 被列为文字讨论、而非独立定理，与本次核对一致。M1 不触碰字段删减结论。

## 10. M2/M3 回填（不改写 Figure 3）

- O5 的 M0 措辞已改为“原有 KEM 调用及显式失败检查”，未添加公钥或密文验证步骤。
- O11 的原始参考已核查：Boyd §2.4 明确单 Test、目标状态泄漏限制；CK01 §3.3–4.1 明确返回擦除、每侧过期以及 Test 后继续攻击。O3/O4/O7 **仍未关闭**：HAKE 与所引原文的 role、SID 唯一性、Complete/Test 语义并非逐字相同，见 `security-model.md` §3。
- O9 部分补充：Backendal 2026 全文 Fig.4 p15 的抽象 RO-KDF 是一次 H 调用后截断，要求可恢复编码；不能因此确定 HAKE 实现的字节序列化或 SHA3 置换次数。O1 仍开放。
- O13 没有因找到组件定理而关闭；现在明确为 source 分布/auxiliary 与消息处理接口的衔接义务 B3。
- 新发现 B1/B2：公开 context 的 source 定义与 HAKE 秘密 context 不直接相容；源伪随机到不可预测的归约有预测/碰撞余项。详见 `novelty-gap.md`，不据此宣称协议漏洞。
