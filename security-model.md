# M3：威胁模型、安全合同与准入规则

版本：2026-09-18。对象：原 HAKE Figure 3，**不含 reduced 变体**。输入是 M0/M1 和 [M2 核查](novelty-gap.md)；文献编号见 [来源清单](sources/README.md)。机器可读合同为 [security-contract.csv](security-contract.csv)，逐位置门槛为 [hybrid-branch-compatibility.csv](hybrid-branch-compatibility.csv)。

本文件已固定可由证据确定的能力、目标和边界；原文不唯一决定的完成/擦除/Test 语义保留为参数，不通过增加有利规则“完成证明”。因此 M3 分析交付完成，**与原论文完全一致的可执行安全模型尚不能冻结**。这不是需要用户替论文发明事实，而是需要后续证明接口澄清。

## 1. 三层证据与模型版本

- `H`：H26 §2.5、Fig.3、Def.7 和 Thm.1–2 的实际声明。
- `R-CK`：H 引用的 CK01 全文及 B23；用来补充查询语义，但明确记录与 H 的差异。
- `W`：本项目为以后形式化设计的事件记号/合同，不冒充原文规则，也未执行证明。

主目标仍是 H 所声称的 SK：匹配且未腐化的双方完成后 key 相同，以及 fresh 目标的 `k_h^2` 不可区分。分支差别写在合同里，不改变允许的第一轮转换：只删一个明确的 component-context 出现位置，其余消息、检查、接口、secret、label、L、输出拆分与方向不动。原文未给出的 pk/ct 校验不得自行加入。

## 2. Oracle 与可见输出

下列参数使用统一记号 `π=(P,Q,s,role)`；这是名称归一化，不更改游戏。

| 操作 | 激活与返回 | 状态作用/限制 | 证据 |
|---|---|---|---|
| Setup | 诚实生成长期密钥并提供公共凭据 | 在攻击者交互前完成；不提供恶意注册 oracle | H p8；B23 p10 |
| NewSession(P,Q,s,role) | 启动预期对端为 Q 的会话；可能返回首个网络消息 | UM 的 s 可尚未确定；图中随后由 ct1、ct2 构造 | B23 p10脚注2；H Fig.3 |
| Send(P,Q,m) | 向 P 递交声称来自 Q 的 m；得到协议输出消息、拒绝/完成等可观察行为 | 可伪造、丢弃、延迟、转送及重排；不凭此读取秘密 | H p8；B23 p10 |
| Corrupt(P) | 返回 P 当时完整内部状态，包括仍存长期/会话秘密 | B23 中诚实进程停止，攻击者可冒用该身份；H 只概述泄漏，引用细节采用 R-CK 并标记 | B23 p10；CK01 §3.2 |
| Session-State(π) / RevealState | 返回尚未完成会话的本地内部状态，不是只返回 sk_e | H 禁止完成后查询；CK01 返回时擦除非输出状态，因此完成后为空。两者分别记录 | H p8；CK01 §3.3 p11 |
| Reveal(π) / RevealKey | 返回完成会话的 session key，即 `k_h^2`，不是整个 F 输出 | R-CK 只允许未过期；不能合法泄漏目标或 matching 后仍称 fresh | H p8；CK01 §3.3 |
| Expire(π) | 不返回秘密；删除该参与方保存的 session key，记录过期 | CK01 是每侧独立的本地事件；不自动让对侧同时过期 | CK01 §3.3；H 的复数措辞未给同步机制 |
| Test(π) | 返回真实 `k_h^2` 或等长随机串；隐藏位 b 在游戏内固定 | B23 明确仅一次；R-CK 查询时 completed、unexpired、unexposed；后续仍须保持目标不暴露 | B23 p11；CK01 §4.1 pp13–15 |

本文件采用 `b=1` 表示真 key 的记号（B23）；CK01 原文用 `b=0` 表示真 key，交换命名无安全影响。H 的 advantage 为 `Pr[猜中]−1/2`；B23 与 KDF 的归一化不同，后续归约须显示换算，不直接复写常数。

允许其他会话的合法 State/Reveal/Corrupt；不把全局禁止泄漏偷换成原模型。协议 oracle 输入/输出为经典字符串，QPT 仅说明攻击者计算能力。哈希是否允许量子叠加查询是单独维度，见 §6。

## 3. Session、matching、freshness 与完成

### 3.1 身份和会话标识

局部会话标识 `π=(P,Q,s,role)`；Figure 3 中 `s=ct1∥ct2`。H Def.3 的 matching 是 `(A,B,s,initiator)` 对 `(B,A,s,responder)`。CK01/B23 仅要求反向身份和同 s，不要求相反 role；本项目不删除 H 明写的 role 条件。`s` 的唯一性在 H 是上层假设；B23 优化要求双方间未完成会话不重用 s；CK01 shell 更强地禁止曾用会话标识。**不把其中某个唯一性实现偷偷加进 Figure 3**。实例的碰撞概率、去重和编码机制仍属待澄清。

### 3.2 可复用的 R-CK freshness 精确规则

令 `LocalExposed(π)` 表示发生过有效 State/Reveal，或在 π 本地 Expire 前其所属方被 Corrupt（包括启动前腐化）。`Exposed(π)` 是它本身或任一 matching 会话局部暴露。对预期 peer 的腐化也不能因 matching 会话尚不存在而豁免：只有该侧对应会话已本地过期，才可使用过期后腐化例外。R-CK 的 Test 在查询时要求：

`Complete(π) ∧ ¬Expired(π) ∧ ¬Exposed(π)`，并且全游戏只选一个目标。

Test 后仍不得暴露目标及 matching；可在某侧本地会话过期后腐化该侧，并继续运行攻击者。这就是本项目所引用的 CK01-PFS 路径。它**不要求先双方一起过期**，也不允许目标临时状态泄漏后仍挑战。

B23 p11 的 Test 条目逐字禁止此前 Corrupt(A) 或 Corrupt(B)，没有在该条目展开 CK01 的过期例外。这里以 CK01 §4.1/脚注6 为 R-CK 的过期语义来源，不把 B23 的简略列表说成与它逐字相同；H-history 仍须独立处理。

H p9 的非正式 freshness/PFS 文字还允许“已过期、后被腐化”的会话被 Test，而未解释已擦除 key 如何返回。可由 challenger 额外保存历史 key 形成另一个游戏，但 H 没有给出完整规则，且它不同于 R-CK 的 Test 前置条件。本项目不声称二者等价：`TestTiming=R-CK` 是参考合同，`TestTiming=H-history` 是未冻结参数。证明若选择前者，只能称 CK01 参考语义下保持，不能宣称已覆盖 H 的全部字面可挑战集合。

### 3.3 事件与接受不能混为一谈

为避免把“派生”自动升级为“认证接受”，定义 W 观察事件：

- `Derive_A`：Alice 按 Fig.3 本地算出 F 输出；此时尚未成功验证 τ3。
- `Derive_B`：Bob 验证 τ2、解封、QKD 查询非 ⊥ 后算出 F 输出。
- `ConfirmSend_B`：Bob 用 `k_h^1` 生成并发送 τ3。
- `ConfirmVerify_A`：Alice 成功验证 τ3；失败时仍走原 fail 分支。

论文级 `Complete` 究竟对应 Alice 的 `Derive_A` 还是 `ConfirmVerify_A`，原文“calculated session key”与图的后续处理之间没有唯一的正式解释。不能把二者合并以减少攻击者能力。若未来用 `Accept_A=ConfirmVerify_A`、`Accept_B=ConfirmSend_B`，这是显式标明的 W 细化，须另证与 H 游戏的关系；Bob 没有收到 Alice 的反向确认事件。

CK01 约定返回时擦除全部非输出会话状态；它解释抽象 PFS，不证明 HAKE 实现何时擦除 `sk_e,k1,k2,k*,k_qkd,k_h^1`。尤其 Alice Derive 后还需 k_h^1 验 τ3，故不能同时假设“Derive 即返回且所有非输出都已擦除”。这项冲突记为 B5，未被 M3 消除。

## 4. Setup 与 QKD 边界

保持 `A↔pk_a`、`B↔pk_b` 的 authenticated setup 与预期 peer lookup。可信映射不等于 `pk_A=pk_B ⇒ A=B`；是否允许两身份共用同一凭据未明示。正常诚实 KeyGen 的随机碰撞与攻击者主动注册同一 key 是不同事件。M3 不添加恶意注册、主动共用凭据、目录替换、凭据回滚或状态回滚接口。

Def.7 的 QKD 黑盒含认证经典通道：GetKey 选择可用 key 与随机分配的唯一 ID；配对端 GetKeyById 返回对应 key 或 ⊥；本端同一 key 最多输出一次，重复使用 ID 失败。保持 Figure 3 在 Bob 查询失败时中止。接口值的编码和内部 endpoint–ID 绑定未具体实现，不能另加更强唯一绑定证明。

`QKDfail` 指偏离理想服务的事件，包含非均匀、不同端 key 不一致、固定值或泄漏等，不仅“被窃听”。QKD-failed 分支不再使用该 source 的不可预测性。它不是允许攻击者任意改写整台 HAKE 主机；组件故障与 Corrupt oracle 仍分开。

## 5. 故障不是同一个“broken”开关

| 名称 | 含义 | 对 freshness / binding 的影响 |
|---|---|---|
| LTK-leak | 协议 Corrupt 返回仍存长期私钥及状态 | 目标过期前通常不 fresh；不能用它模拟 fresh 会话上的任意 secrecy failure |
| EPH-leak | 未完成会话 State 返回临时状态 | 目标/matching 不 fresh；B23 明确不保证目标临时泄漏安全 |
| KEM-secrecy-fail | 所用原语的 IND-CPA/CCA 等保密假设不成立 | 不自动触发会话 State/Corrupt，也不逻辑蕴含每种 binding 成败 |
| KEM-binding-fail | 某个明确 X-BIND-P-Q 或 C2PRI 不成立 | 不是一个通用性质；要列游戏、实例和攻击者。可能与 secrecy 同时失效 |
| MAC-fail | authenticator 所需 EUF-CMA 假设不可用 | KEM 路径也不可称存活；QKD-only 不能继续借用此认证界 |
| QKD-fail | Def.7 理想服务保证不可用 | QKD 路径不可称存活；不改变主机内存权限 |

“KEM 路径存活”要求整个 KEM-AKE 路径：认证用 CCA、临时 CPA、MAC、setup/freshness 和合法 KDF 映射；不只是某个 KEM 的名字。

合同分支：`BG` 两分量正常；`KO` QKD failed 而 KEM 路径正常；`QS` QKD good、KEM secrecy failed 但指定 binding 假设仍可用；`QB` QKD good、KEM secrecy 与指定 binding 均不作安全假设；`QT` H 声称的无界 ROM/QKD 分支；`FF` 两条路径均失效。`QS` 和 `QB` 分拆的是原文宽泛 KEM 故障口径，H 未逐个枚举 binding 游戏。H p19 声称所有 KEM 计算假设失效时仍安全，不能因此在 QB/QT 偷加 binding；但该声称的证明衔接目前受 B1–B7 限制。

## 6. KDF 与攻击者维度合同

`F((σ_KEM,c_KEM),(σ_QKD,c_QKD),lbl,512)` 的 source 顺序、label 和长度固定。K25/K26 source 内允许相关秘密，source 集合要求独立采样；context 属攻击者辅助信息。B1 说明 HAKE 字面实例化目前不满足所期望的 KEM 不可预测源接口。

KDF 游戏的四个查询是：NewKey(i,j) 登记一次 honest 元组并返回 α；SetKey(i,σ,c) 在支持集内登记 dishonest 元组；KDF 返回真实派生值；Ro$-KDF 返回真实或等长随机值。它们是**证明里的查询**，不是额外赋予网络攻击者的 HAKE API。

后续 source 映射必须逐项验证：

1. `reqNOF`：challenge 的完整索引向量、label、长度不能与其他 real/challenge 记录重复。
2. `req1HKey`：每次 challenge 至少一个 honest 输入。
3. `reqNoDColl`：两个不同 dishonest 索引不得代表同 `(σ,c,source)`。
4. `reqValidPos`：每个输入位置对应固定 source。
5. `reqHybrid(S)`：S 非空，属于 S 的所有查询输入都 honest 且不重用该索引；不是仅最终 Test 满足一次性。

匹配两端的相同派生需要一致模拟，不能作为两个 fresh Ro$-KDF 调用返回独立随机 key。context 投影可能合并元组，必须重证索引及重复条件（B4）。诚实执行一致性不足以证明这些条件。

攻击者合同维度为 `(计算能力, 协议查询接口, 哈希查询接口, 查询预算)`。H 的 QPT 不获协议叠加访问；K25/K26 的所引证明使用经典 RO 查询记录。量子 RO 的扩展未核验。QT 必须保留理想哈希限制，且 B2 表明 qRO/猜测项不能在无界声称中丢弃。现阶段**不认证 QT 的纯 2·Pr[QKDfail] 界，也不以较窄的查询受限结论冒充它**。

## 7. Binding 假设与较窄合同 C-BIND

D24 Def.4.1/Fig.5–6：`X-BIND-P-Q` 禁止两次非 ⊥ 结果在 P 上相等而 Q 上不同。`HON` 使用诚实密钥与解封 oracle；`LEAK` 还给出诚实 sk，攻击者可检查中间值；`MAL` 允许选择密钥材料并比较 Encaps/Decaps 的不同组合。原文 Def.4.1 针对 PPT，应用到 QPT 须有相应实例结论。MAL 不是 HAKE 主模型自动具有的注册能力。

例如 K–PK 是相同共享 key 对不同 pk 的碰撞限制；K–CT 是对不同 ct 的限制。C2PRI 则在固定诚实 `(pk,sk)` 和诚实 `(k,ct)` challenge 后（sk 也已给出）限制另一个解封到 k 的 ct。它不蕴含跨 pk 身份绑定，不能与 K–PK/K–CT 互换。HON 也不能在有合法 sk 泄漏的归约中替 LEAK。对接收的 pk_e 是否可视为诚实，依赖 τ1 认证及分支，不由 Bob 正常执行 KeyGen 一句话保证。

建立独立的待证合同 `C-BIND(D,X,P,Q)`：

- D 为一个明确位置投影；保持主机、QKD 和原消息边界。
- 限定为具备指定 `X-BIND-P-Q` 性质的 KEM 实例，并注明 QPT/PPT 与 hash 假设。
- 仅覆盖 BG、KO 和 QS；QS 虽允许 secrecy 失效，仍要求该 binding 存活，且其余 source/协议义务必须另证。
- 不覆盖 QB、QT，不声称完整原 hybrid 保持；新增假设同时限制**实例、攻击者及允许的故障集合**。
- binding 是候选必要前提而非已证充分条件；必须另补 credential/identity、角色、完成时间和非循环的协议归约。

此合同已经登记，以防后续无意收窄主张；本阶段没有任何字段被判为“仅附加 binding 条件下兼容”，因为连该条件的充分性也尚未证明。

## 8. 性质合同与退出判据

`security-contract.csv` 每个 cell 是一个分支/性质组合，区分原声明、独立核验与变体证明义务。正确性与 Key-IND 分列；PFS 是原 freshness 下的历史 key 保密性，不是 PCS。显式确认只观察 Bob→Alice；其游戏化认证结论未由原文独立给出。identity/role、contribution、source separation、MAC 输入对应是后续辅助不变量；UKS/KCI 是原文文字讨论；多 Test independence 和全 transcript 完整性是扩展，不擅自填到每个原分支里。

逐字段门槛必须引用具体合同 cell。只有所有原承诺 cell 都覆盖、且 B1–B7 已闭合或有明确不影响证明的理由，才可写“全部原分支兼容”。只有附加假设的充分性已经得到论证才可写“仅附加 binding 条件下兼容”。“候选依据在某分支失效”不等于“删字段一定不安全”，因此目前均判**证据不足**，不是“不兼容”或“已有反例”。

M3 尚未冻结的精确接口：Complete/Return 事件；每侧的擦除状态；H-history Test 的保存/查询语义；SID 唯一性在 Figure 3 上的落实；KDF source 与 α 的合法映射；RO 查询能力。它们已变成可定位的证明义务，不通过假定这些问题已解决来批准 M4 正面删减。
