# M4.5：Binding Layer Separation

日期：2026-09-19。状态：分析完成，等待 M4.5 审查。本文中的 M4.5 是本次用户指定的分层审查，不表示原路线图同编号条目或任何证明 gate 自动通过。

结论：**已有 primitive binding 可以成为协议论证的局部前提，但目前没有建立其覆盖 HAKE protocol binding 的证明桥。** 这不是“任何替代都不可能”的结论，也不评价任何字段的必要性、充分性或冗余性。

## 1. 来源和解释边界

沿用 [M4 字段映射](field-security-mapping.csv)、[binding 分析](binding-property-analysis.md) 和 [M4 证明义务](m4-proof-obligation.md)，不改动协议或模型。本文新增的是职责分类，不是新的安全模型。

| 来源 | 使用范围 | 不能从该来源自动获得 |
|---|---|---|
| [H26](2026-1231.pdf) Def.3–6 pp8–9；Fig.3 p13；§3.1 pp14–15 | matching、最终 Key-IND、完成双方正确性、原 PFS 目标；完整输入及单向确认流程 | 独立 identity/injective agreement 游戏、逐角色 Accept 事件、完美 erase |
| H26 Def.7 pp10–11；Lemma2–3 p16；Thm.1–2 | QKD 配对检索与一次性语义；原组合论证及故障边界 | 任意组件失败后仍可用的 binding 或认证保证 |
| [D24](sources/2023-1933-binding.pdf) Def.4.1、Fig.5–6 pp7–8 | X-BIND-P-Q 的对象关系及 HON/LEAK/MAL 域 | 具体 HAKE 实例已满足某 binding；PPT 自动升级 QPT；逻辑身份与会话对应 |
| [X24](sources/2024-039-xwing.pdf) Def.7 p9 | C2PRI 的诚实 keypair、诚实挑战、固定公钥下密文第二原像限制 | 跨公钥 binding、任意两输入碰撞限制或 HAKE matching |
| [B23](sources/2023-167-boyd.pdf) §4.1/Fig.8 pp20–22 | 原 KEM-AKE 路径及其假设背景 | 对 HAKE 新增 QKD、F、τ3 的直接覆盖；自动继承 Boyd matching |
| [K25](sources/2025-657-kdf-20250410.pdf) Def.1–2 pp8–9 | source、公开辅助信息 α 与 KDF 查询接口 | HAKE 秘密 context 的合法性、协议会话到 source 索引映射已完成 |

版本与哈希见 [来源清单](sources/README.md)。原文事实、原论文声称、本文候选职责、尚待验证的跨层转移分别记录。本文不是重新查新，不改变 M2 的 primitive/combiner 与 authenticated AKE 研究边界。

最低目标仍采用 [model-freeze-review-summary.md](model-freeze-review-summary.md) 的 HAKE 优先部分语义合同。Identity binding、transcript integrity、contribution agreement、key confirmation 在此是解释安全职责的词汇；不能因此向原目标中加入更强 agreement 游戏。Matching 是会话关系定义，其存在不等于已证明任意接受会话都有匹配伙伴。

## 2. 三层分类

| 层 | 分析对象 | 对应字段/接口 | 边界 |
|---|---|---|---|
| L1 Primitive Binding | KEM key 与 public key、ciphertext 的精确游戏关系 | pk_a、pk_b、pk_e 及 k1、k2、k* 对应的 KEM 调用 | 不包含逻辑身份、会话角色、QKD 节点或接受事件 |
| L2 Protocol Binding | 本地身份、凭据、消息、贡献与会话之间的关联 | A/B、全部 KEM context 字段、τ1/τ2/τ3、s=ct1∥ct2 | 需协议级来源、时序、matching、泄漏和目标性质映射 |
| L3 Hybrid Composition Binding | 两组件的本地记录如何共同对应一次 HAKE 执行及其故障分支 | 两组 context、QKD ID/节点/检索、source 顺序与索引、F 输出拆分 | QKD 接口正确性与 KEM binding 均不能单独建立完整组合对应 |

三层不是互斥集合，也不是由低到高自动蕴含的安全等级。公钥作为 KEM 对象属于 L1；同一公钥作为 HAKE context 中的凭据记录承担 L2 候选职责；能否在某混合故障分支使用其保证又是 L3 问题。IND-CPA/CCA 和 MAC EUF-CMA 是相关支撑假设，**不是 binding 的同义词**。

矩阵按 11 个 context 出现位置列行，覆盖用户指定的 9 个字段。A/B 在两个 source 中各出现一次，分别登记。k* 的 σ_KEM 位置另作依赖说明，不与 c_KEM[8] 混为一个对象。完整原输入的顺序、label、输出长度/拆分均保持不变。

## 3. 字段级分析

完整六项记录及来源、义务编号见 [binding-layer-matrix.csv](binding-layer-matrix.csv)。以下说明分层理由和不能跨越的缺口。

### A、B：协议身份与跨组件端点

A 位于 c_KEM[1]、c_QKD[1]，直接进入 τ1 message；B 位于 c_KEM[3]、c_QKD[2]，直接进入 τ2 message。τ3 含 τ1/τ2 的 tag 字节，不直接重写 A/B。（H Fig.3、p14）

KEM context 中的有序身份是 L2 候选 identity-to-key/session association；QKD context 中的身份涉及 L3 的应用身份到配对节点/source 记录的关联，同时仍依赖 L2 身份解释。已有 setup 和条件性的 MAC 路径可供论证，K-PK 游戏本身没有 A/B 对象。

尚缺凭据到逻辑身份的映射、角色与本地视图对应、编码和会话域说明。另一 context 也含相同字符串不等于这两处已有相同的安全含义。QKD 认证通道也不自动证明上层 A/B 与设备端点一一对应。关联 PO-01、PO-03、OI-01/05。

### pk_a、pk_b：原语公钥与协议凭据

pk_a 位于 c_KEM[2]，是 ct2 的封装目标；pk_b 位于 c_KEM[4]，是 ct1 的封装目标。两者均不是三个 MAC 的直接 message 字段。通过 KEM 输出得到 MAC key 的依赖不能写成“公钥字节已直接被 MAC 覆盖”。

L1 的 K-PK 是候选 key/public-key 对应保证，L2 仍需解释该公钥属于哪一预期对端、哪一局部会话。H 的诚实 setup/预分发背景不是公钥到身份单射的完整定义。K-PK 只能在指定游戏中限制相同组件 key 对应不同 pk，不能先由最终 F 输出相等倒推出组件 key 相等。两条认证路径的泄漏条件和时点分别核查，不能镜像代替。L3 决定故障分支中哪些前提可继续使用。关联 PO-02、PO-04。

### pk_e：临时 KEM 对象与经消息传递的会话记录

pk_e 位于 c_KEM[5]，是 ct* 的封装目标，直接出现在 τ1 和 τ3 message。Bob 的本地 keypair 由他生成；Alice 收到的材料是否可纳入诚实生成域，仍需 τ1 路径及分支论证。

L1 候选 K-PK 可涉及 k*/pk_e 对应；C2PRI 只在固定 pk 下约束挑战密文的第二原像，不比较不同 pk。L2 的来源、角色、transcript 关联及确认时点不在这两个游戏内。pk_e 不是 H 的 SID；它的临时性不能直接证明会话唯一性或 PFS。L3 还要求故障后不把已经失效的认证路径补回。关联 PO-05、OI-05/06。

### k1、k2：组件输出与认证贡献

k1 位于 c_KEM[6]，是 τ1 key 和 τ3 message 成员；k2 位于 c_KEM[7]，是 τ2 key 和 τ3 message 成员。按本地值读取：Alice 为 k1、k2′，Bob 为 k1′、k2。本文不预设任意执行中这些值相等。

L1 的 K-PK/K-CT 或特定 C2PRI 可约束组件 key 与相应 pk/ct 的关系。L2 需要的是这些结果属于预期会话的哪次贡献、是否支持消息来源和角色对应。保密、两端一致、跨会话唯一性是不同问题；普通 EUF-CMA 不自动提供不同 MAC key 间的 key commitment。

L3 存在两个额外接口：秘密 context 如何进入 K25 的公开 α 模型（B1）；τ2 message 含 qkdKeyId，因而原组件独立性声明不能读成消息完全无跨组件依赖（B3）。这不否定原独立性声明，只阻止不加区分地搬用它。关联 PO-06/07。

### k*：临时组件 key 与组合 source 记录

k* 位于 c_KEM[8]，同一角色中也作为 σ_KEM。Alice 的 k_A* 来自 Encaps，Bob 的 k_B* 来自 Decaps。k* 不直接进入 τ3 message，而是经 F 影响确认 key。

L1 讨论 key/pk/ct 关系；L2 讨论贡献对应哪个本地会话；L3 讨论 σ/context 的关联、source 索引、查询一致性以及 F 拆分后最终半段的安全目标。C2PRI 不涉及最终 hybrid key 或两个 source 的配对。σ/context 数值重复只是原输入的语法事实，不承担安全评价。

已有 KEM IND、候选 binding 和 KDF/source 结果分别覆盖各自接口。将其用于 HAKE 仍受秘密 context、查询映射、确认半段暴露及失效分支限制。关联 PO-08/10、B1/B4/B7。

### qkdKeyId：检索标识与混合会话同步

qkdKeyId 位于 c_QKD[3]、τ2/τ3 message，是 Bob 的 GetKeyById 参数。τ2 验证先于 Bob 检索；返回 ⊥ 则中止。（H Def.7、Fig.3）

主要属于 L3：它连接两端 QKD 检索记录与本次组合输入；同时涉及 L2 的消息/应用会话关联。没有直接的 KEM L1 对应物。已有保证是配对节点检索、每 key 至多输出一次、重复 ID 返回 ⊥ 及理想 QKD 黑盒背景。ID 唯一性、随机 key 值碰撞概率、应用会话唯一性不可互换。

缺口在应用身份/节点/会话映射与故障边界。τ2 的条件性保护不能在 KEM 认证路径失效时继续当作无条件保证，τ3 也不能倒用于证明 F 前已有同步。关联 PO-09、B3/B4、OI-04/05。

## 4. Primitive-level binding 能否覆盖 protocol-level binding？

目前能确认的是**保证范围不相同，不能直接代换**。未来若使用某原语结果，至少需要逐项验证以下桥接条件；这里只登记缺口，不给定理或构造。

| 桥接点 | 原语保证可提供的局部信息 | 仍需协议/组合依据 |
|---|---|---|
| 对象与量词 | 某游戏中 key、pk、ct 的碰撞/第二原像限制 | 哪两次 HAKE 调用对应这些对象；不能把最终 key 相等当成组件 key 相等 |
| 生成与泄漏域 | HON/LEAK/MAL 或固定诚实挑战的特定域 | 收到的公钥来源、实际实例、合法状态泄漏及腐化；不得自动增加恶意注册能力 |
| 身份与会话 | K-PK 可限制特定跨 pk 关系 | pk 到 A/B、角色、s、matching 的关系及 SID 域 |
| 认证与时序 | KEM/MAC 各自游戏的安全结果 | τ1/τ2 路径在使用时点是否可用；Accept/Complete 未定点不能补造 |
| 确认与最终 key | F 输出可用于原单向确认流程 | 确认成功的目标解释、确认半段暴露与最终半段 Key-IND；避免用 τ3 循环支持 F 前提 |
| 混合配对 | 某组件的局部 key 关系 | QKD ID/节点同步、source/α/索引合法性、同一次 HAKE 执行中的组合关系 |
| 失效分支 | 在适用假设下成立的保证 | 是否在当前分支仍存活；不能从一个分支推广到全部分支 |

尤其，C2PRI 即使给出 sk 仍可有意义，也不等于被泄漏的组件可以继续承担 MAC 认证。K-CT 若适用，也不直接给出 s=ct1∥ct2 的完整匹配和唯一性。跨层论证缺失不表示原协议存在漏洞，不是不可替代性证明。

## 5. Hybrid Composition 层的分支约束

沿用 [security-contract.csv](security-contract.csv) 的分类，不新增失败模型：

| 分支 | 允许保留的分析边界 |
|---|---|
| BG：组件正常 | 各保证仍须满足本身假设及桥接条件；正常并不自动完成字段级论证 |
| KO：QKD 失败、KEM-AKE 路径正常 | 可审查 KEM 路径，不使用理想 QKD 同步结论；原检索失败中止行为不变 |
| QS：QKD 正常、KEM secrecy 失败但指定 binding 假定存活 | 仅是较窄 candidate hypothesis，非已采用的通用保证；MAC 认证不随 binding 自动保留 |
| QB：QKD 正常、不假设 KEM secrecy/binding | 不以任何 KEM binding 补足 L2/L3 |
| QT：原无界 ROM/QKD 声称 | 不借用计算性 binding/MAC 安全；原界和哈希接口问题继续开放 |
| FF：两侧无所需安全保证 | 不补造原协议未承诺的非平凡安全结论 |

OI-01–OI-06（事件、Test、Expire/Corrupt、泄漏后控制、SID、擦除）及 B1–B7 保持开放。分层登记不冻结这些问题，不选择最强模型，不证明强 PFS/PCS。整个项目仍研究特定 HAKE 的协议级证明桥，不扩成一般 Context Elision Framework。

## 6. 审查出口

本轮只交付三层分类、9 个字段/11 个位置的职责与保证缺口。矩阵中 required security property 是待对应的辅助性质，existing guarantee 是来源受限的结果或候选前提；均不代表覆盖成功。

需人工审查：层归属是否准确、游戏域是否足够精确、各 L1→L2→L3 缺口是否完整、混合失败语义是否保持、是否仍有隐含模型增强。审查通过也不会自动关闭模型开放项或启动 M5。完成本文件、矩阵和摘要后停止。
