# M5：Context Reduction Candidate Analysis

状态：candidate hypotheses / 待审。仅定义用于研究的单位置投影，不修改原 HAKE、KDF 实现或构造可部署变体。不宣称任何字段可以删除。

## 1. 本轮授权与历史状态

本轮按用户附件进入 M5+M6 的**候选与证明路线文档阶段**。此前 M4/M4.5 文件中“未进入 M5”的文字是各自交付时状态，不阻止本轮文档工作。本轮授权不是对 OI-01–OI-06 或 B1–B7 的科学裁决，不把用户对 M3 完成的阶段概述解释为完整游戏已经冻结。保留 [模型审查](model-freeze-review-summary.md)、[M4 义务](m4-proof-obligation.md) 和 [三层分析](binding-layer-analysis.md) 的开放项；不进入 M7。

## 2. Original Context Baseline：固定不变

以 [H26](2026-1231.pdf) Fig.3 p13、§3.1 pp14–15 为准。用户写作 pk_A/pk_B，以下与仓库原符号 pk_a/pk_b 对应，不是新增公钥。

```text
c_KEM = A || pk_a || B || pk_b || pk_e || k1 || k2 || k*
c_QKD = A || B || qkdKeyId
σ_KEM = k*
σ_QKD = k_qkd
K_h = F(((σ_KEM,c_KEM),(σ_QKD,c_QKD)),"KEM-QKD-Hybrid KEX",512)
K_h = k_h^1 || k_h^2        (256 bits each)
```

这是原文简写。按角色本地读取，Alice 使用 k1、k2′、k_A*；Bob 使用 k1′、k2、k_B*。身份、公钥、ID 也使用本地视图，不预设一般执行中的两方相等。

| 项目 | secret input | context input | public input / visibility | transcript-related input |
|---|---|---|---|---|
| A/B | 否 | 两组 context 中各有一处 | 身份背景/非秘密标识；不据公开性推认证 | A 直接在 τ1 message；B 直接在 τ2 message |
| pk_a/pk_b | 否 | c_KEM[2]/[4] | setup 公钥，非三个 MAC 的直接 message | 分别是 ct2/ct1 封装目标 |
| pk_e | 否 | c_KEM[5] | 在线发送的临时公钥 | τ1/τ3 直接 message，ct* 封装目标 |
| k1/k2 | 非 σ 独立输入 | c_KEM[6]/[7] | 秘密 context，不在线明文发送；合法泄漏另审 | τ1/τ2 的 key，τ3 的本地 message |
| k* | σ_KEM | c_KEM[8] | 秘密；同角色 σ/context 重复 | 由 pk_e/ct* 对应调用产生，经 F 影响 τ3 key |
| qkdKeyId | 否 | c_QKD[3] | 在线公开 ID | τ2/τ3 message、GetKeyById 参数 |
| k_qkd | σ_QKD | 否 | 黑盒返回的秘密，不在线发送 | 与 ID 检索记录相关 |
| label、L、source order | 否 | 全局参数/结构，不是上述字段 | 固定 label、512、KEM-first/QKD-second | 确认/最终 key 分工固定 |

分类并不互斥。“context”不等于“public”。τ3 message 包含某秘密，不表示秘密以明文作为线上报文发送；线上发送的是 tag。s=ct1∥ct2 是原 SID 与 MAC 输入，不新增为 KDF 字段。

## 3. 候选对象：两个独立投影

本节仅指定假设协议对象的研究差分。两侧同样投影各自本地输入。不串联两个投影，不提出联合候选。消息结构、全部 KEM/MAC/QKD 操作、σ 输入、label、source 顺序、输出拆分和原失败检查均不变。保留原编码约定，不补造新的编码；其可解析性/域问题仍待审。

### C1：k*@c_KEM[8] context occurrence reduction

候选记号 p1：仅从本地 c_KEM 列表略去第 8 个位置。研究输入为 `A||pk_a||B||pk_b||pk_e||k1||k2`；σ_KEM 仍为同侧 k*。c_QKD 不变。**candidate removal hypothesis**，不是实施或可删结论。

动机是同侧重复，而不是“重复没有熵，所以安全”。应分别检查：

1. **Secret-input binding。** 在原合法本地记录中，原第 8 项与 σ_KEM 相同。因此在元组层面，若秘密仍在完整输入里，原则上可据 σ 重建该项。此观察限于合法记录和既定编码，不是安全保持定理；它既不证明跨会话 matching，也不覆盖任意 adversarial RO 字节串、source 登记或泄漏。
2. **Secret/context overlap。** [K25](sources/2025-657-kdf-20250410.pdf) Def.1 p8 要求 c 可从 α 提取，预测游戏给对手辅助信息。字面搬用原 HAKE 时，α 将暴露 σ_KEM。定义允许相关元组，不等于该重叠仍满足非平凡不可预测性条件。候选中 k1/k2 仍为秘密 context；B1 尚未解决，不能为适配定理公开这些值或重划 σ。
3. **Final key secrecy。** 需将合法本地记录映射至 KDF 查询，处理重复查询、目标/非目标 Reveal、匹配双方共享派生记录及确认半段 tag 的联合分布。完整 F 输入与“仅 reduced context 相等”要严格区分。
4. **Hybrid 分支。** BG/KO 不能跳过 B1；QB/QT 不能加入计算性 binding。重复项的结构观察本身不保证无界 ROM 声称或原余项消失。

优先级判断：high，仅表示最窄、最易定位的研究切口，不是成功概率或删除建议。状态 hypothesis；安全结论受 SP-01–05、C1-BG–FF 阻塞/待证。

### C2：pk_e@c_KEM[5] context reduction

候选记号 p2：仅略去本地 c_KEM 第 5 项。研究输入为 `A||pk_a||B||pk_b||k1||k2||k*`；pk_e 的原消息、τ1/τ3 message、KEM 调用和本地状态用途全部保留，c_QKD 与 σ 均不变。独立于 C1。状态 hypothesis。

- **L1：pk_e 与 KEM contribution。** 适用的 K-PK 或其他精确定义结果可能约束相同组件 key 对应不同公钥。须给定实际实例、HON/LEAK/MAL、PPT/QPT、接收材料的生成域及泄漏域。C2PRI 固定同一诚实 keypair，不能提供跨 pk_e 保证。
- **L2：pk_e 与 ephemeral session。** 需从 τ1 的认证路径、预期身份、s、角色及本地记录建立关系。收到 pk_e 不等于来自预期匹配会话；pk_e 不是 SID；不得由最终 F 输出相等倒推组件 key 相等。
- **L3：分支及组合。** QS 中假定 binding 存活不自动保留 MAC 认证；QB/QT 不能走计算 K-PK 路径。原 k* context 重叠问题也仍完整存在。
- **后置确认。** τ3 仍含 pk_e，但其 key 依赖候选 F 输入。不能从原 τ3 的安全结论推出候选中相同结论；需要非循环的联合论证。

优先级 medium：有具体 L1/L2 接口可审查，但比 C1 多出凭据和会话映射义务。没有字段安全评价。

### C3：其他字段的初步登记

A、B、pk_a、pk_b、k1、k2、qkdKeyId 仅登记职责和可能需要的桥。**C3 是待研列表，不是一个投影或联合变体。** A/B 两个 context 出现位置分别登记；本轮没有它们的 reduced context 公式。

pk_a/pk_b 的 K-PK 到身份/会话桥可继续调查，初步 potential 为 medium。A/B、k1/k2、qkdKeyId 为 low：目前缺少独立、充分且适配全部相关分支的替代链。Low 不表示证明必要或永远不可替代。

## 4. 表格、证据与停止条件

[候选表](context-reduction-candidates.csv) 使用用户指定的 8 列，11 行位置级记录；status 仅使用 hypothesis、blocked、requires-proof、rejected。blocked 表示当前证明接口缺失，rejected 若未来出现也仅可针对明确提案，不等于不可替代性结果。本轮没有 rejected 项。

来源沿用 [sources/README.md](sources/README.md)。D24 Def.4.1/Fig.5–6、X24 Def.7、B23 Fig.8 和 K25 Def.1–2 各有不同作用域；详见 [假设登记](reduction-hypothesis.md) 与 [安全保持框架](security-preservation-framework.md)。没有原语保证被自动升级为 HAKE 结论。

本轮停止在文档框架。没有实现、benchmark、Tamarin、攻击搜索或形式定理。
