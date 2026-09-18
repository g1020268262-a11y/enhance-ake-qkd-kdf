# M1：原 HAKE 的 KDF 数据流（未改动输入）

依据：仓库 `2026-1231.pdf`，SHA-256 `E1F894E1F2C0973F230DE343B2133AE6C399621487EF6596C15FBF2507E58A62`；§2.4 第 6–7 页、Figure 3 第 13 页、§3.1 第 14–15 页。本文件记录原协议的计算和数据类别，不判断任何输入是否冗余。

## 两个 source/context 输入对

§2.4 把多输入 KDF 写成确定性函数 `F((σ_1,c_1),…,(σ_n,c_n),lbl,L)`。Figure 3 的执行是二输入形式，`Σ-map` 将 KEM source 固定在第一位、QKD source 固定在第二位（§2.4 第 7 页）：

```text
σ_KEM = k*
c_KEM = A ∥ pk_a ∥ B ∥ pk_b ∥ pk_e ∥ k_1 ∥ k_2 ∥ k*

σ_QKD = k_qkd
c_QKD = A ∥ B ∥ qkdKeyId

k_h = F((σ_KEM, c_KEM), (σ_QKD, c_QKD),
        "KEM-QKD-Hybrid KEX", 512)
k_h = k_h^1 ∥ k_h^2,  |k_h^1| = |k_h^2| = 256 bit
```

`k*` 有两个不同的**原文出现位置**：KEM 输入对的 secret `σ_KEM`，以及同一输入对 context `c_KEM` 的最后一项。本文件只登记这一事实。`k_1,k_2,k*` 都是 `c_KEM` 中的秘密值，所以 **context 不等于全公开 transcript**。`qkdKeyId` 是 `c_QKD` 的公开标识值；`k_qkd` 是 QKD 输入对的 secret。（§3.1 第 14 页）

| 层 | 值及来源 | 线上传输？ | 原文用途或生效时点 |
|---|---|---|---|
| 长期/会话 KEM | `pk_a,pk_b` 由初始可信分发已知；`pk_e` 在本会话由 Bob 生成；`ct_1,ct_2,ct*` 分别来自三次 `Encaps` | 只有 `pk_e,ct_1,ct_2,ct*` 在 Figure 3 的箭头上；长期公钥未在图中重发 | `pk_b` 是 `ct_1` 封装目标；`pk_a` 是 `ct_2` 目标；`pk_e` 是 `ct*` 目标；`pk_a,pk_b,pk_e` 另进入 `c_KEM` |
| KEM 派生秘密 | Alice/Bob 通过封装/解封装得到相同的 `k_1,k_2,k*`（诚实正确分支） | 不发送；`k_1,k_2,k*` 并非 ciphertext | `k_1`/`k_2` 分别关联 `τ_1`/`τ_2` 的 MAC key；三者均进入 `c_KEM`；`k*` 另为 `σ_KEM` |
| QKD 黑盒 | Alice `GetKey`，Bob `GetKeyById(qkdKeyId)` | 只发送 `qkdKeyId`；`k_qkd` 不在 Figure 3 线上发送 | Bob 在成功取到 `k_qkd` 后才运行 `F`；`k_qkd` 为 `σ_QKD`，ID 为 `c_QKD` 末项 |
| 身份/会话标识 | `A,B` 来自预期参与方；`s=ct_1∥ct_2` 双方本地重建 | 图中不单独发送 `A,B,s` | `A,B` 各出现在两个 context；`s` 在 `τ_1`,`τ_2` 的 MAC message 中，**不**是图示 KDF context 的独立字段 |
| MAC authentication material | `τ_1=Tag(k_1',pk_e∥s∥A)`；`τ_2=Tag(k_2',qkdKeyId∥ct*∥s∥B)`；`τ_3=Tag(k_h^1,k_1∥qkdKeyId∥pk_e∥τ_1∥k_2∥τ_2)` | 三个 tag 分别在后续三条箭头上传输 | `τ_1`,`τ_2` 在 KDF 前验证；`τ_3` 在 KDF 后由 Bob 发、Alice 验；每个 tag 的直接消息范围见 [baseline-spec.md](baseline-spec.md) |
| KDF 输出 | 固定 label `"KEM-QKD-Hybrid KEX"`，输出长度 `L=512 bit` | label 与长度不是 Figure 3 的单独线上字段；`k_h,k_h^1,k_h^2` 都不发送 | `k_h^1` 用作 `τ_3` 的 MAC key；`k_h^2` 是最终 256-bit session key |

§2.4 第 6 页解释 label 为协议/用途区分字符串；§3.1 第 14 页称以上字符串用于其 implementation，Figure 3 第 13 页也显式采用该 label。不能从 label 的存在推出任何尚未核验的跨协议性质。

## 时间顺序、调用数与编码精度

1. Alice 必须先拥有 `k_1,k_2',k*,k_qkd` 与收到的 `pk_e,ct_2,τ_1`，且 `τ_1` 验证成功，才能按图构成两个 KDF 输入对。图在发出 `τ_2` 后写 Alice 运行 `F`。
2. Bob 必须先验证 `τ_2`，再得到 `k*` 和非 `⊥` 的 `k_qkd`，然后按相同顺序运行 `F`。他先拆分 512-bit `k_h`、获得 `k_h^2`，再用 `k_h^1` 生成 `τ_3`。
3. Alice 在收到 `τ_3` 后按图拆分已计算的 `k_h`，用 `k_h^1` 验证；最终会话密钥仍是 `k_h^2`。Bob 没有来自 Alice 的 Figure 3 内最终确认消息。（Figure 3 第 13 页；§3.1 第 15 页）

成功执行中的**图示顶层 `F` 调用**为 Alice 一次、Bob 一次；原 PDF 没有给出 `F` 内部 SHA-3/RO 调用次数。正文仅用 `∥` 给出字段先后，不说明每一字段的精确字节编码、长度前缀、歧义消解办法；这些不是 M1 可凭常识补齐的数字。§2.4 第 7 页称 benchmark 采用 SHA-3-256，§5.1 第 20 页却称 key combination 采用 SHA3-512，而 Figure 3 与 §3.1 要求 512-bit 输出。这一实现级不一致保持为开放问题，不能静默选一个版本。

## 原论文声明与本文件的界限

M2 补充：所引 Backendal 框架的抽象 `RO-KDF`（2026 全文 Fig.4 p15）将可恢复编码的 `(σ1,c1,σ2,c2,lbl)` 输入 H 一次并截取所需长度；NOF 固定 L 且 L 不得超过 H 输出。这个**抽象 H 调用数**不等于 HAKE 实现的 SHA3 置换数，也不解决 SHA3-256 与 512-bit 输出的不一致。Def.1 将 context 包含在公开辅助信息 α 中，与上文秘密值 context 的字面映射存在差异；只记录为 [M2 B1](novelty-gap.md)，不把这些秘密改成线上公开值。

Lemma 2（第 15 页）称 KEM/QKD 子协议在最终 combiner 前独立；Figure 3 的第三条网络消息把两个子协议的材料批量发送，并不将 QKD **key** 作为 KEM 计算输入。不过 `τ_2` 的 MAC message 直接含 QKD `qkdKeyId`，所以不能将该引理概括成“两个组件完全没有跨层字段依赖”；其精确边界见 [baseline-spec.md](baseline-spec.md) 的 O13。Theorem 1（第 16–17 页）及 Theorem 2（第 18–19 页）给原协议在所述模型中的安全声明；这里没有重新证明它们，也没有修改 `F` 或上述任何输入。
