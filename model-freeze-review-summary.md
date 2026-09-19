# Confirmed

> 2026-09-19 阶段更新：用户依据 AKE+QKD 最新审查授权进入 **M4 仅字段职责／证明义务映射**。M3.2 baseline interpretation 审查通过，不等于完整安全游戏冻结；OI-01–OI-06 和 B1–B7 仍开放。下文原阶段“不得进入 M4／等待审查”的停止记录仅保留为历史，不再阻止描述性映射；不授权变体或安全保持证明。当前映射交付及 G3-M4 待审状态见 [m4-proof-obligation.md](m4-proof-obligation.md)。

Model Freeze Review，2026-09-19。此处 Confirmed 仅表示有原文依据，不表示模型已冻结或安全已证明。

- H26 §2.5、Def.3–6 明示会话、带相反角色条件的 matching、Key-IND、matching 完成双方 key 一致性和 PFS 目标。
- H p8 明示网络控制、Corrupt、Session-State、Reveal、Test、Expire；p9 给出 QPT 和经典协议 oracle 限制。
- Test 的已完成/fresh 前置条件与等长均匀随机回答有明文。Def.4 是非正式 freshness 定义，不能称完整游戏已给出。
- 最终 key 为 k_h^2；Bob→Alice 单向确认机制有明确流程与文字来源。
- H 声明上层 SID 唯一性前提及诚实长期密钥 setup。确认的是论文的假设，不是协议已经实现完美唯一性或身份绑定。
- QKD 黑盒接口和 QKD fail、KEM-AKE 的计算假设范围有来源；原 Thm.1/2 声称保留，不在本轮重证。

# Not confirmed

以下均记录为 not explicitly specified，而不是默认安全或默认禁止：

- Figure 3 中逐角色的正式 Accept、key 输出/Complete 精确程序点，以及独立 confirmation/agreement 游戏。
- Test 完整预算与调用规则、过期后历史 key 保存和返回、无 matching 等边界的操作化 freshness。
- State/Corrupt 之后的完整进程控制行为、Expire 的单侧/联合范围、主机与外部 QKD/KMS 腐化边界。
- k1、k2、k*、sk_e、QKD material 的逐项擦除时间和残留规则。
- SID 唯一性机制与精确作用域、公钥到身份的单射或完美 identity binding。
- PCS 恢复游戏、失陷结束和自愈机制。PFS 不是 PCS；仅补 erase 也不足以建立 PCS。
- 统一量子哈希查询能力/预算及任意组件故障的完整操作游戏。

不据此断言原协议不安全。原文 PFS 声称存在，但不能将其升级为本项目已证明的更强或实现级 PFS。

# Recommended baseline

建议采用 **HAKE 原文优先、保持原目标且不自动补全的部分语义合同**：

1. 最低性质集是 Def.6 的最终 key 保密和 matching 完成正确性，并保留原 PFS 目标。Authentication 使用 H 自己的 SK/PFS 口径，不新增独立 identity/injective agreement。
2. 保留 H 的会话身份/角色及 matching；单向确认仅作为已描述机制。SID 上层前提和 setup 必须显式登记，不视为已验证的完美机制。
3. 保留 H 的攻击能力与 freshness 明示条件。final Reveal、未完成会话 State、当前全状态 Corrupt、组件故障分别记录。
4. Expire 只采用原文明示的最终 key 删除语义，不附带完美中间状态擦除或恢复保证。
5. 保留 QKD 黑盒、故障事件和 KEM-AKE 假设边界；不把原语失效等同腐化，不在故障分支暗加 binding。
6. 缺口保持 OPEN ISSUE。CK01/Boyd 仅解释，不替换 H 的 Test、freshness、matching 或事件；Thm.2 的 ROM 条件 ITS 单列，不与 QPT 规则融合。

这是一份 **PROPOSAL / NOT FROZEN**，不是可以立即执行证明的完整新模型。source hierarchy 为：

HAKE explicit definition > HAKE referenced definition > external model interpretation

# Still requires human decision

| 项目 | 待审决定 |
|---|---|
| OI-01 | 两角色完成/输出/接受对应关系及其原文依据 |
| OI-02 | Test 实验细节、预算、历史 key 和前后 freshness；不能直接选择 CK Test |
| OI-03 | Expire 作用域、查询行为及腐化资格边界 |
| OI-04 | 泄漏后控制行为与 HAKE 主机/外部设备范围 |
| OI-05 | SID 上层假设的域和后续使用依据 |
| OI-06 | 状态生命周期及任何额外擦除假设；不得默认完美 erase |
| 关联项 | 性质集/扩展边界、哈希接口、组件故障的证明使用范围 |

M4 必须先冻结 security property set、attacker capability、session freshness、acceptance relation、component failure model 五项。当前仍有开放问题，**不能进入 M4**。

详细来源、confidence 和核心问答见 [model-freeze-proposal.md](model-freeze-proposal.md)；24 项、8 列审查表见 [model-freeze-table.csv](model-freeze-table.csv)。本轮只交付这三个文件，保持既有 M2/M3 文档及路线图不变；未分析字段删除、未执行优化、theorem、Tamarin 或 attack search。
