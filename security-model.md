# M3：安全模型来源与 closure 审查

> 2026-09-19 阶段更新：用户依据 AKE+QKD 最新审查授权进入 **M4 仅字段职责／证明义务映射**。M3.2 baseline interpretation 审查通过，不等于完整安全游戏冻结；OI-01–OI-06 和 B1–B7 仍开放。下文原阶段“不得进入 M4／等待审查”的停止记录仅保留为历史，不再阻止描述性映射；不授权变体或安全保持证明。当前映射交付及 G3-M4 待审状态见 [m4-proof-obligation.md](m4-proof-obligation.md)。

版本：2026-09-19。对象：原 HAKE Figure 3，不含 reduced 变体。

**M3.2：OPEN ISSUE — WAITING FOR HUMAN REVIEW。** 已锁定来源与原文明示规则，但完整安全模型尚未冻结，不批准进入 M4。来源差异不是协议漏洞结论。

## 1. 模型采用状态与来源

研究目标仍是 HAKE context reduction 的 protocol-level proof bridge，不扩展为一般 Context Elision Framework。M2 已经用户审查通过 G1；这不代表任何字段删除结论。

| 标识 | 锁定来源 | 地位 |
|---|---|---|
| H | [H26](2026-1231.pdf) §2.5 pp7–9、Fig.3 p13、§3.1 pp14–15 | HAKE 原规范；明示规则保留，缺失处不擅自补全 |
| R-CK | [C01](sources/2001-040-ck01.pdf) §3.2–3.3、§4.1 | 独立 CK01 参考模型；下文使用印刷页，PDF 页码加 2 |
| R-Boyd | [B23](sources/2023-167-boyd.pdf) §2.4 pp10–11、§4.1 pp21–22 | 独立 KEM-AKE 参考模型，不与 R-CK 合并 |
| W | 本项目观察记号、候选解释及证明义务 | 非原文规则，未作安全证明 |

H 和 B23 的上述印刷页与 PDF 页一致；版本与 SHA-256 见 [来源清单](sources/README.md)，来源文件未改动。

**最终采用状态：**本项目的规范目标固定为 H26 的 HAKE 模型；目前没有获批准、语义完整的可执行游戏。未选择 R-CK 替代 H，也未选择历史 Test 的补全方案。旧版将 CK01 与 Boyd 合称 R-CK 并直接补充规则的做法在此撤回。须待 OI-01–OI-06 人工裁决后，才能宣告完整模型冻结。

## 2. HAKE original semantics 与 reference model semantics

| 项目 | H：HAKE original semantics | R-CK：reference model semantics | R-Boyd：reference model semantics | 采用解释／状态 |
|---|---|---|---|---|
| Setup／网络 | p8：预先诚实生成长期密钥；攻击者控制启动和消息 | §3.2–3.3 pp9–10：攻击者调度；初始化认证分发公钥 | §2.4 p10：NewSession、Send、预先生成长期密钥 | 保留 H；不添加恶意注册 |
| matching | Def.3 pp8–9：反向身份、同 SID、相反角色 | §3.3 p11：反向身份、同 SID，不要求相反角色 | §2.4 p10：反向身份、同 SID，无相反角色条件 | 保留 H 角色条件；三者不等同 |
| SID 唯一性 | p8：由上层保证；Fig.3 为 ct1∥ct2 | p11：shell 禁止相同双方/SID 历史重用，不因 role 改变放行 | §4.1 p21：优化中双方间未完成会话 SID 唯一 | 原则保留，作用域未冻结：OI-05 |
| Accept／Complete | p8：完成并计算 key；Fig.3 无正式 Accept/Return 点 | p11：子程序返回非空 key 为完成，空值为 abort | p10：有会话状态；Send 可 accept，但未定位 HAKE 事件 | 不合并派生、拆分、验证：OI-01 |
| State reveal | p8：仅未完成会话，返回内部状态 | §3.2 p9：泄漏后该会话不再产生输出；§3.3 p11：返回后非输出状态已擦除 | p11：返回当前状态含临时秘密，条目未写同样完成限制或停止规则 | 保留 H 前置限制；查询后控制：OI-04 |
| Corrupt | p8：返回当前全部内部状态 | p9：返回状态，诚实进程不再激活，由攻击者控制 | p10：同样明确不再激活 | 不把参考停止规则说成 H 明写：OI-04 |
| Reveal key | p8：返回已完成会话 key | p11：不能查询已过期 key | p11：若有已接受 key 则返回 | H 的过期查询行为：OI-02/03 |
| Erase | Expire 删除派生 key；Fig.3 没有临时状态擦除点 | p11：Return 擦除全部非输出局部状态；Expire 擦除输出 key | p10：完成且未过期会话保留 key，不能据此定位 HAKE 擦除点 | 不移植 Return 时间点：OI-06 |
| Test eligibility | p8：completed 且 fresh；p9 文字允许先过期后腐化的会话仍可 Test | §4.1 p14：查询时 completed、unexpired、unexposed；之后仍不得暴露目标或匹配会话 | p11：仅一次；无此前目标 RevealKey/State 或任一方 Corrupt；列表未展开过期例外及完整后续限制 | 不把历史 Test 与 CK 路径等同：OI-02 |
| Freshness | Def.4 p9：无 key/state reveal；若腐化须先过期；匹配会话同样满足 | pp11–14：目标或 matching 暴露均影响资格，含启动前腐化 | p11：Test 条目较简略，不从省略推导额外能力 | 保留 H 明示条件；完整拒绝规则：OI-02/03 |
| Expire／Corrupt | pp8–9：在 respective parties 删除 key，先过期后腐化例外 | p11：本地已完成会话过期；p14脚注6：该侧过期即可腐化，不要求另一侧过期甚至完成 | p11：本地已完成会话 Expire；Test 的此前腐化禁令未展开例外 | CK 单侧语义已查明，但不自动移入 H：OI-03 |
| 随机 Test 回答 | p8：等长均匀随机串 | p14：从协议 key 分布采样 | p11：从 keyspace 随机采样 | 保留 H；参考分布等价需另证 |
| 攻击者 | p8：QPT，无 key-exchange oracle 的叠加访问 | 经典协议查询 | KEM-AKE 查询模型 | 保留 H 经典协议接口；哈希查询能力见 §6 |

H p9 的优势定义是 **有绝对值的** `|Pr[ExpKeyIND=1]−1/2|`；B23 p11 为 `2·|Pr[b′=b]−1/2|`。旧转述漏写绝对值，在本模型中更正，不据此制造新研究 gap。CK 用 b=0 表示真实 key，Boyd 用 b=1；隐藏位改名本身无影响，但不能掩盖时序或采样分布差异。

## 3. 冻结边界与人工审查

### 3.1 已解决的原文定位

H matching 的相反角色条件已确定。CK01 的 Return/Expire 区分、单侧过期后腐化规则、State reveal 后停止输出也已查明；这些不是 H 的自动补充条款。PFS 不等于目标临时状态泄漏安全或 PCS；matching 正确性不保证双方一定完成、活性或双向显式确认。

以下 W 记号仅记录 Fig.3 的可见顺序，不是新增协议事件：

- Alice 的 `FDone_A`（完整 F 输出）在接收 τ3 之前；`Split_A`（拆分 k_h^1、k_h^2）画在接收 τ3 之后、验证之前；随后才是 `ConfirmVerify_A`（验证成功）。
- Bob 在 τ2 验证、解封、QKD 查询成功后，依次 F 输出、拆分、`ConfirmSend_B`（生成并发送 τ3）。
- 保留所有原中止分支；Fig.3 没有 Bob 接收 Alice 反向确认的事件。

不能仅凭 calculated session key 选定 FDone、Split 或成功验证作为 Complete；B23 的 Send 可 accept 也不能代替 HAKE 的程序点定位。

### 3.2 OPEN ISSUE 清单

| ID | 未闭合语义 | 人工审查需要明确的规则；本轮均未选择 |
|---|---|---|
| OI-01 | Accept／Complete／Return | 分别定位 Alice、Bob 的完成、对外 key 输出和认证接受；解释 F、拆分、验证/发送的关系 |
| OI-02 | Test freshness 与历史 key | 如何补全 H 的过期后 Test，或是否显式改用 CK 参考目标；明确历史 key 保存、Test 次数及前后暴露限制；后者改变采用范围，不能宣称等价 |
| OI-03 | Expire 与 corrupt ordering | H 的调用对象、单侧/双侧操作、过期后 Reveal 行为；对端尚无 matching 会话时的腐化如何判断；不可擅加同步过期或腐化豁免 |
| OI-04 | 泄漏后的控制行为 | H 是否继承 CK 的 State reveal 后会话停止输出及 Corrupt 后诚实进程停止；给出依据与影响 |
| OI-05 | SID 唯一性域 | 上层唯一性覆盖哪些实例与历史、如何对应 ct1∥ct2；不自动加入 CK 历史去重或 Boyd 未完成去重 |
| OI-06 | 临时状态擦除时间 | 每侧 Return/Expire 的保留状态；Alice 仍需 k_h^1 验 τ3，不能同时假定 FDone 即 Return 且所有非输出已擦除 |

逐项登记见 [model-assumption-table.csv](model-assumption-table.csv)。这些问题是规范差异或信息不足，不是攻击结论。任何补全均是 requires validation，尚未成为本项目采用假设。

审查者须记录批准规则、依据、偏离 H 的范围及对 freshness/状态可见性的影响，再重新判断是否冻结。不能只批准“统一按 CK01”而忽略 H 的明示差异。本轮停止语义选择；§4–8 保留既有合同背景，不开展新字段职责或删除分析。

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

## 7. Binding 候选假设与未启用合同 C-BIND

D24 Def.4.1/Fig.5–6：`X-BIND-P-Q` 禁止两次非 ⊥ 结果在 P 上相等而 Q 上不同。`HON` 使用诚实密钥与解封 oracle；`LEAK` 还给出诚实 sk，攻击者可检查中间值；`MAL` 允许选择密钥材料并比较 Encaps/Decaps 的不同组合。原文 Def.4.1 针对 PPT，应用到 QPT 须有相应实例结论。MAL 不是 HAKE 主模型自动具有的注册能力。

例如 K–PK 是相同共享 key 对不同 pk 的碰撞限制；K–CT 是对不同 ct 的限制。C2PRI 则在固定诚实 `(pk,sk)` 和诚实 `(k,ct)` challenge 后（sk 也已给出）限制另一个解封到 k 的 ct。它不蕴含跨 pk 身份绑定，不能与 K–PK/K–CT 互换。HON 也不能在有合法 sk 泄漏的归约中替 LEAK。对接收的 pk_e 是否可视为诚实，依赖 τ1 认证及分支，不由 Bob 正常执行 KeyGen 一句话保证。

仅登记 candidate hypothesis / proof obligation：待证合同 `C-BIND(D,X,P,Q)`，尚无安全结论：

- D 为一个明确位置投影；保持主机、QKD 和原消息边界。
- 限定为具备指定 `X-BIND-P-Q` 性质的 KEM 实例，并注明 QPT/PPT 与 hash 假设。
- 拟议目标范围仅为 BG、KO 和 QS，尚未证明覆盖；QS 虽允许 secrecy 失效，仍要求该 binding 存活，且其余 source/协议义务必须另证。
- 不覆盖 QB、QT，不声称完整原 hybrid 保持；新增假设同时限制**实例、攻击者及允许的故障集合**。
- binding 是待验证的候选假设，必要性和充分性均未证明；必须另补 credential/identity、角色、完成时间和非循环的协议归约。

此合同已经登记，以防后续无意收窄主张；本阶段没有任何字段被判为“仅附加 binding 条件下兼容”，因为连该条件的充分性也尚未证明。

## 8. 性质合同与退出判据

`security-contract.csv` 每个 cell 是一个分支/性质组合，区分原声明、独立核验与变体证明义务。正确性与 Key-IND 分列；PFS 是原 freshness 下的历史 key 保密性，不是 PCS。显式确认只观察 Bob→Alice；其游戏化认证结论未由原文独立给出。identity/role、contribution、source separation、MAC 输入对应是后续辅助不变量；UKS/KCI 是原文文字讨论；多 Test independence 和全 transcript 完整性是扩展，不擅自填到每个原分支里。

逐字段门槛必须引用具体合同 cell。只有所有原承诺 cell 都覆盖、且 B1–B7 已闭合或有明确不影响证明的理由，才可写“全部原分支兼容”。只有附加假设的充分性已经得到论证才可写“仅附加 binding 条件下兼容”。“候选依据在某分支失效”不等于“删字段一定不安全”，因此目前均判**证据不足**，不是“不兼容”或“已有反例”。

M3.2 以 §3 和假设表为准：OI-01–OI-06 均为 OPEN ISSUE，等待人工审查，本轮不进入 M4。未来 M4 首先做职责映射，不以已经证明可删为入场条件。B1–B7 中 source/KDF/RO 等证明义务继续保留，本轮不解决；假设登记不是证明完成。
