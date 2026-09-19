# Model Freeze Review: baseline security interpretation proposal

> 2026-09-19 阶段更新：用户依据 AKE+QKD 最新审查授权进入 **M4 仅字段职责／证明义务映射**。M3.2 baseline interpretation 审查通过，不等于完整安全游戏冻结；OI-01–OI-06 和 B1–B7 仍开放。下文原阶段“不得进入 M4／等待审查”的停止记录仅保留为历史，不再阻止描述性映射；不授权变体或安全保持证明。当前映射交付及 G3-M4 待审状态见 [m4-proof-obligation.md](m4-proof-obligation.md)。

日期：2026-09-19。状态：PROPOSAL / NOT FROZEN。本文件只回答未来 HAKE 安全分析应采用哪些最低限度的语义，不构造安全游戏或协议变体。M3.2 documentation 已完成，security model 尚未冻结；本轮不进入 M4。

“最低限度”指覆盖 HAKE 原声明所必需的语义接口，不指选择最弱攻击者、最强模型，或删去难以证明的原目标。建议采用的内容不等于已经批准，更不等于安全证明。现有 [security-model.md](security-model.md) 的开放状态保持不变。

# 1. Security model sources

## 1.1 HAKE source

主来源是仓库锁定的 [H26 原论文](2026-1231.pdf)，对应论文引用编号 [8] 为 Boyd 等、[10] 为 Canetti–Krawczyk。版本和 SHA-256 见 [sources/README.md](sources/README.md)，不以在线更新替换本地版本。下文 H26、B23 使用印刷页＝PDF 页；C01 使用印刷页，PDF 页加 2。

| 原文位置 | 本轮所依据的内容 | 证据地位 |
|---|---|---|
| §2.5 pp7–9 | 声称使用 Boyd 所用、继承 CK01 的 AKE 安全模型；采用 SK 与 PFS；给出本地会话及 oracle 描述 | 模型引用声明及 H 自己的语义优先，不能理解为外部条款全部逐字继承 |
| Def.3 p8 | matching：反向身份、同 SID、相反 initiator/responder 角色 | 明确定义 |
| Def.4 pp8–9 | freshness 的四条条件 | 明示但原文标为 informal，非完整操作规则 |
| Def.5 p9 | real-or-random Key-IND 目标与优势 | 原文标为 informal |
| Def.6 p9 | 未腐化双方完成 matching sessions 时 key 一致；fresh key 不可区分；扩展至 QPT且无协议 oracle 叠加查询 | 核心性质集和攻击者限制 |
| PFS 段 p9 | 历史会话过期后再腐化仍应受保护 | 原目标；不是每项材料的擦除规范 |
| Def.7 pp10–11 | QKD 黑盒、认证经典通道、GetKey/GetKeyById、单次输出和失败值；QKD fail 汇总理想行为的偏离 | 明确接口及故障抽象，不是详细设备 compromise 游戏 |
| Lemma1 p11 | 抽象 ΠQKD 的 SK/PFS 声称；证明中将该子协议视为无状态 | 仅子协议论述，不是整个 HAKE 或实际 KMS 无状态的依据 |
| Fig.3 p13、§3.1 pp14–15 | 最终 key 为 k_h^2；确认使用 k_h^1；Bob→Alice 单向确认；公钥启动分发背景 | 算法和文字机制，不提供独立 Accept 事件定义 |
| Lemma3 p16 | 引用 Boyd Fig.8、Thm.2–4 解释 KEM-AKE 的 SK 路径；涉及认证 KEM 的 CCA、临时 KEM 的 CPA 和 MAC 假设 | 引用证明路径，不自动继承全部查询行为 |
| Thm.1 pp16–17 | QPT 下的 HAKE SK hybrid 声称，依赖 KEM-AKE/QKD 与 combiner 衔接 | 保留原声明范围，不重证、不视为已经独立核验 |
| §4 pp17–18 | UKS、KCI 的文字讨论 | 不升级成独立 formal agreement/KCI 游戏 |
| Thm.2 pp18–19 | QKD 存活时的无界攻击者、ROM 条件 ITS 声称 | 单独登记，不与 QPT 游戏融合，不等于具体哈希的无条件安全 |

本轮不重写 theorem，也不把 M2 已登记的证明接口问题视为解决。

## 1.2 CK01

解释来源：[C01 原始模型阅读副本](sources/2001-040-ck01.pdf)。H26 §2.5 pp7–8 明确引用 CK01 的 SK 模型、上层 SID 假设，并指向 [10,8] 查阅完整形式化；Lemma3 p16 也提到 authenticated-links 到 unauthenticated-links 的路径。

可以用于理解的是：消息驱动会话、攻击者控制、session output、matching、暴露、过期和 SK/PFS 概念。以下细节没有被 H 单独明确展开或与 H 有措辞差别，必须记录出处，不能自动采用：

- C01 §3.3 p11（PDF13）的 Return 非空输出事件、返回时全部非输出状态擦除。
- 同页 matching 不要求相反角色；H Def.3 明确要求。
- 同页 shell 的历史 SID 去重，不等于 H 已实现该机制。
- C01 §3.2 p9（PDF11）的 State reveal 后会话不再输出，以及 Corrupt 后诚实进程停止。
- C01 §4.1 p14（PDF16）的 Test 时未过期要求、按协议 key 分布采样，以及脚注6的单侧过期后腐化规则。

H 的总括引用表明模型来源，不足以消除这些对应缺口。特别不能因“都是 CK01”就替换 H 的 freshness 或过期后可 Test 的文字。

## 1.3 Boyd KEM-AKE

解释来源：[B23](sources/2023-167-boyd.pdf) §2.4 pp10–11 的 Def.9–11 与查询列表，及 §4.1/Fig.8 pp21–22。H26 §2.5、Lemma3 明确以此理解 KEM-AKE 与 SK 证明路径。

可以理解：会话状态、KEM-AKE 角色、长期凭据背景、oracle 的一般用途，以及 H 所引用的 KEM-AKE 安全目标。

不能直接继承：不带相反角色条件的 matching；Send 中笼统的 accept；一次 Test 的精确预算；此前任一方 Corrupt 的禁令；Corrupt 后停止诚实进程；仅未完成会话的 SID 去重条件。这些是 B23 自己的规则或优化约束，不能用来定位 H 的完成程序点、擦除点或补全 freshness。

## 1.4 Source hierarchy

HAKE explicit definition > HAKE referenced definition > external model interpretation

该顺序是证据优先级，不是自动补全算法：

1. HAKE 自己的定义优先。流程和文字声称按各自证据强度登记。
2. HAKE 明确引用的定义只能说明引用范围；有差异时保留原文两列，不能以引用覆盖 H 的明示规则。
3. 外部解释仅提出候选理解；没有确定原文依据的部分记为 **not explicitly specified**。
4. not explicitly specified 不表示“不允许”或“攻击者得不到”；也不许可选择对证明有利的默认值。

# 2. Model Freeze Table

完整的 24 项记录见 [model-freeze-table.csv](model-freeze-table.csv)。CSV 严格使用用户指定的 8 列。explicit/implicit/absent 分类针对该行核心语义在 H 中的证据；explicit 不代表细节齐全或已经冻结。status 独立记录剩余缺口。

以下 confidence 衡量来源定位的把握，不是安全成立概率，也不是对某项补全方案的批准。

| 项目 | source | adopted interpretation（仅拟采用） | confidence | open issue |
|---|---|---|---|---|
| Accept | H §2.5、Fig.3 | session accept event：not explicitly specified；不自行定义 | 高：核查了定义及流程，未定位正式事件 | OI-01：逐角色接受关系 |
| Complete / key output | H p8、Fig.3、p15 | 有抽象 Complete 与本地 key 输出；输出值为 k_h^2，精确交付时点 not explicitly specified | 高：对象有明文，程序点未定 | OI-01 |
| Key confirmation | H p15、Fig.3 | 保留 Bob 发 τ3、Alice 验证的单向机制；正式 confirmation event/game not explicitly specified | 高：方向明文；独立游戏未给出 | 不与 Accept 等同 |
| Test | H p8、Def.4–5 | completed 且 fresh；真实最终 key 或同长度均匀串 | 高：核心明示；完整实验不完整 | OI-02：预算、历史 key、后续查询 |
| Reveal | H p8、p15 | Reveal 最终 session key；Session-State 返回未完成会话内部状态；不合并两者 | 高：通用接口明文；材料清单未定 | OI-03/04/06 |
| Corrupt | H p8、Def.4、PFS段 | 返回当前全部本地秘密，不缩成仅长期私钥；查询后进程行为 not explicitly specified | 高：泄漏范围明文；控制语义未定 | OI-04/06 |
| Expire | H pp8–9 | 过期删除最终 session key，参与 freshness；不推导全面 erase 或恢复 | 高：有明文；作用域未定 | OI-02/03 |
| State Erasure | H Fig.3、§3.1；区别于 Lemma1 | 中间秘密具体擦除规则 not explicitly specified，不采用 CK Return 即全部擦除 | 高：所列材料无逐项擦除规范 | OI-06 |

## 2.1 Accept / Complete

H p8 明示完成会话计算本地输出；p15 定义最终输出值。H 没有把正式 session accept、key output、key confirmation 三个事件分别关联到 Figure 3 的程序点。

图示 Alice 的 F 输出在接收 τ3 之前，拆分在收到 τ3 之后、验证之前；Bob 算出 F、拆分后生成并发送 τ3。这些是流程观察，不等于采用任何一个位置为 Accept。不能因验证成功看起来适合证明，就定义 Accept_A；也不能因 Bob 没有反向确认而新增一条消息或隐含事件。

最低需要的是双方各自完成、输出和认证接受之间的**有来源对应关系**。若原文无法确定，应保持开放；不得把缺口降格成纯命名问题。

## 2.2 Test

H 已明示 Test、real-or-random 回答及 freshness，因此不是从零设计 Test。最低解释保留：被测对象是已完成且 fresh 会话的最终 k_h^2，随机分支为等长均匀串，区分目标遵守 Def.5。

H 文字未完整写出隐藏位采样过程、Test 次数、多个查询的一致性规则、过期后历史 key 如何留存和返回。将 b 理解为隐藏的公平随机位，是由 Def.5 的随机猜测基线和其引用实验支持的解释建议（C01 §4.1、B23 Def.10），不是 H 独立给出的完整算法；仍需审查确认。隐藏位的 0/1 命名不是实质冲突。

不选用 CK 的 unexpired Test 替代 H。H p9 明说先过期后腐化的会话仍可被测试；是否使用 challenger 历史保存、或如何解释该措辞，保持 OI-02。也不直接借 Boyd 将“一次 Test”冻结为 H 的预算。不能通过排除这些会话，使原 PFS 目标变弱后仍称完全保持。

Def.4 的四条条件优先于 p9 末尾的直观举例。尤其不能把“腐化双方可造成平凡获胜”的解释句解读成“只腐化一方就必然仍 fresh”。

## 2.3 Reveal：final key 与 component secrets

| 类型 | H 是否定义 | 最低解释 |
|---|---|---|
| 最终 session key reveal | 是，p8 Reveal；p15 指定最终 key | 对象为 k_h^2，不是完整 F 输出或确认 key |
| intermediate secret reveal | 通用 Session-State 定义存在；各时点具体成员 not explicitly specified | 泄漏未完成会话当前内部状态，不能缩成一个预选临时值 |
| KEM secret reveal | 独立选择性 oracle：not explicitly specified | 仍存主机的 KEM 秘密受通用 State/Corrupt 描述约束，不新增特殊查询或 freshness 豁免 |
| QKD key reveal | 独立选择性 oracle：not explicitly specified | 主机已持有的 k_qkd 与设备/KMS 内部状态分开；不假定两者共享同一腐化边界 |

组件保密假设失效是另一维度，不自动等同于调用 final Reveal。反过来，也不能因没有独立组件 oracle 就宣布中间秘密永不泄漏。

## 2.4 Corrupt

H 的 current internal state 包括所有当前本地秘密，语义上涵盖仍存的长期密钥和临时材料；不采用仅泄漏长期私钥的缩弱解释。具体哪些临时材料在何时仍存，由尚未定义的状态/擦除映射决定。

QKD compromise 需区分 HAKE 主机、外部 QKD/KMS 和论文的 QKD fail 事件。H 没有给出分设备腐化权限、撤销、修复或恢复时间线。不能以主机 Corrupt 自动获得整个外部服务状态，也不能把主机中的 QKD 材料排除在“全部本地秘密”之外。

H Def.4 给出腐化须晚于过期的 freshness 边界，但精确调度、无 matching 的边界情形和查询后执行行为仍不完整。CK/Boyd 的进程停止或接管只供解释，不自动加入。

## 2.5 Expire

H 明确有 session expiration、删除最终 key 和 freshness/PFS 边界。respective parties 没有精确说明一次调用是单侧还是联合操作，也没有完整列出过期后 Reveal/Test 的响应规则。

CK 单侧 Expire 可以帮助发现需要回答的问题，不能当答案。Expire 不隐含删除所有组件秘密、擦除备份、恢复诚实身份、重新获得认证能力或撤销设备失陷。先过期后腐化涉及过去 key 的保密，不是 PCS。

## 2.6 State Erasure

| 材料 | H 中逐项擦除规范 |
|---|---|
| k1 | not explicitly specified |
| k2 | not explicitly specified |
| k* | not explicitly specified |
| ephemeral sk_e | not explicitly specified |
| QKD material（主机 k_qkd、设备/KMS 缓存等须分开） | not explicitly specified |

H 的 Expire 明文仅删除派生 session key。Lemma1 p11 对抽象 ΠQKD 的“无状态”论述不是整套 HAKE 的中间秘密擦除规范，也不能被当成实际 KMS 的完美 erase。

因此，PFS 的操作化/实现级分析需要额外明确状态生命周期、可见残留材料和擦除边界，或提供不依赖某项擦除的论证；本提案不预先选用完美擦除。PCS 还需要失陷结束、恢复和新秘密引入等定义，**仅补充擦除假设也不足以得到 PCS**。

# 3. 核心问题

## Q1. 最小需要冻结哪些安全语义？

建议后续证明保持以下最低合同，但目前仅是待审提案：

| 语义 | 最低承诺或边界 | 来源 |
|---|---|---|
| Security property set | 最终 key 的 Key-IND 与未腐化 matching 完成双方的 key 一致性；保留原 PFS 目标，不降为单纯 key secrecy | H Def.4–6、PFS 段、Thm.1 |
| Authentication | 使用 H 的 AKE=SK加PFS 口径；独立 authentication/identity agreement 事件集合不自行引入 | H §2.5 p7、Def.6 |
| Identity / matching | 会话保留双方身份、SID、role；采用 H Def.3，不借 Boyd 去除角色条件；setup 不提升为公钥—身份单射 | H pp7–8、Fig.3、p15 |
| Key confirmation | 记录单向机制及失败处理，不新增双向显式确认游戏 | H Fig.3、p15 |
| Attacker capability | 消息控制与启动、当前全状态 Corrupt、未完成会话 State、已完成 key Reveal、Test、Expire；QPT 和经典协议 oracle | H pp8–9 |
| Freshness / acceptance / lifecycle | 保留四条件并解决完成/输出/接受、过期与腐化、Test 时间窗、每侧状态生命周期的对应缺口 | H Def.4与Fig.3；OI-01–OI-06 |
| Component failure | QKD 理想黑盒与 QKD fail；KEM-AKE 计算假设及 MAC 依赖；不得把故障等同主机腐化 | H Def.7、Lemma1/3、Thm.1–2 |

SID 上层唯一性是 H **已经声明的外部前提**，不能删去不报，也不能默认它在 Figure 3 中完美实现。最小合同先如实登记此前提；后续依赖它之前必须明确唯一性域、提供者及违反前提的处理。身份背景同样不得推导完美 identity binding。

Thm.2 的条件 ITS 作为独立原声明保留；不合成一个“无界计算＋所有额外 oracle”的更强主模型。ROM/哈希查询能力和预算须另行明确，不能由经典协议 oracle 自动推导 QROM。

## Q2. 哪些安全性质当前不能声明？

- 本项目已经冻结了完整 H 安全游戏，或已经独立证明 H 原声明。
- 任意“strong forward secrecy”、临时状态泄漏后仍安全、无擦除前提的实现级 PFS。这里不引入 strong 的新定义；需要先写清实际泄漏能力与时序。原文称 PFS 的事实保留。
- PCS、设备或主机失陷后的自愈、密钥刷新后的恢复保证。
- 完美身份绑定、独立身份 agreement、injective agreement、对端一定存在/完成、活性、双向显式 key confirmation。
- 任意 QKD/KMS 腐化权限或任意组件故障组合下仍保持安全。
- ROM 条件 ITS 等于具体 SHA-3 的无条件安全，或未界定哈希 oracle 下的统一无界保证。

这不是证明上述性质为假，而是现有模型证据不足以支持本项目作出这些声明。

## Q3. M4 进入条件

| 必须冻结的维度 | 可审查的通过条件 | 当前状态 |
|---|---|---|
| 1. security property set | 明确 Def.6 两项、PFS 原目标与扩展性质的边界；单向确认机制、UKS/KCI 文字声称及 ITS 分别标识，不冒充同一已证性质集 | 原依据已确认，baseline 建议待批准 |
| 2. attacker capability | 五类 oracle 与网络能力、泄漏后的控制效果、主机/设备边界及协议/哈希查询能力均明确；无静默强化或缩弱 | OPEN：OI-04/06 及哈希接口 |
| 3. session freshness | Def.4 操作规则、Test 前后资格、过期/腐化顺序和无 matching 边界闭合 | OPEN：OI-02/03 |
| 4. acceptance relation | 保留 H matching，逐角色关联完成、key 输出、确认与可测试时点；SID 上层前提的使用域明确 | OPEN：OI-01/05 |
| 5. component failure model | 区分正常组件保证、故障事件、计算假设失效和主机暴露；逐声称明确存活假设，不补入故障 oracle 或 binding | 原抽象已确认，证明所用精确边界待审 |

五项都需有审查记录，不能通过排除难处理的 PFS/QKD 原目标来取得无声明的窄化通过。人工解释若超出 H 明示内容，必须单独标为附加假设或参考模型解释，并明确不能称其已覆盖完整 H；不以勾选批准代替来源或等价论证。

**本轮结论：M4 未准入。** 提案只给出可审查的语义下限，未补造完整模型。

# 4. Still requires human decision

沿用既有编号，避免将新表当作已经解决旧问题：

- OI-01：两角色 Complete、key 输出、认证接受的对应；没有来源时继续开放，不凭方便选点。
- OI-02：隐藏位实验细节、Test 预算、历史 key/过期后 Test 与前后 freshness。
- OI-03：Expire 作用域、过期后查询响应、对端未建立 matching 时的腐化资格。
- OI-04：State/Corrupt 后执行控制，主机和外部 QKD/KMS 的边界。
- OI-05：SID 上层唯一性的实际作用域；不自动选择 CK 历史去重或 Boyd 未完成去重。
- OI-06：各时点仍存材料和擦除规则；任何额外假设必须单列，不默认完美 erase。
- 关联审查项：最低性质集与扩展声明的边界、ROM/量子哈希访问，以及组件失效抽象在后续证明中的使用范围。

本轮仅创建本提案、CSV 与 [review summary](model-freeze-review-summary.md)，不修改现有冻结状态，不进入 M4。
