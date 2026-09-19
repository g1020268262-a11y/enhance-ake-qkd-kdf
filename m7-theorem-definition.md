# M7：C1 Security Preservation Theorem Specification

状态：**待审定理规格，非已证明定理；模型参数与界尚未全部实例化。** 本轮用户授权进入规格细化，取代此前“不得进入M7”的阶段停止条件，但不自动关闭OI-01–OI-06、B1–B7。只处理C1，不证明pk_e候选。

## 1. 协议对象与唯一差分

Original Π：固定[H26](2026-1231.pdf) Figure 3与§3.1 pp13–15的HAKE。对角色P的本地记录，定义输入记号：

```text
c_KEM^P = A^P || pk_a^P || B^P || pk_b^P || pk_e^P || u1^P || u2^P || z^P
c_QKD^P = A^P || B^P || qkdKeyId^P
σ_KEM^P = z^P                  σ_QKD^P = k_qkd^P

Alice: (u1^A,u2^A,z^A) = (k1,k2′,k_A*)
Bob:   (u1^B,u2^B,z^B) = (k1′,k2,k_B*)
```

符号仅明确原图的角色本地值，不预设跨角色相等。P上的原派生为：

```text
F(((σ_KEM^P,c_KEM^P),(σ_QKD^P,c_QKD^P)),lbl,512)
lbl = "KEM-QKD-Hybrid KEX"
```

Reduced specification Π′：仅在两角色原有本地F调用中，将c_KEM^P替换成：

```text
c'_KEM^P = A^P || pk_a^P || B^P || pk_b^P || pk_e^P || u1^P || u2^P
```

σ_KEM^P=z^P完整保留。这个单位置投影定义研究对象，不修改任何实际代码或源文件。两协议使用相同KDF算法与参数，不以新KDF或重新划分secret/context适配外部结果。

固定不变：setup、KEM算法/调用、消息结构和方向、所有MAC算法及message表达式、MAC key来源规则、QKD接口及原一次性/⊥行为、另一个context、label、source次序、512-bit输出及256+256拆分。最终key为k_h^2，确认key为k_h^1。

“仅context不同”是程序差分，不是执行轨迹等价：F输出、τ3字节、验证结果和后续自适应行为可能不同。不为制造相同tag复用原key；不假定Π与Π′最终key数值相等。

## 2. 共同安全实验参数

使用记号M表示**将由人工审查固定的一份HAKE模型解释**。M不是任意新模型，也不是对所有可能补全的全称量化。H explicit > H referenced > external interpretation；不自动继承CK01的Test/擦除或Boyd的matching。

M必须在陈述最终定理之前填实以下项目，否则实验只是未实例化的规格：

| 参数 | 已有约束 | 未冻结部分 |
|---|---|---|
| setup/对手 | 原诚实预置长期key与网络控制；QPT，协议oracle为经典查询 | 哈希oracle能力、具体资源接口B6 |
| Session/Match | H Def.3：反向身份、相同s、相反角色；图中s=ct1∥ct2 | SID唯一性的上层作用域OI-05 |
| Complete/输出 | 保留原图顺序，不把Derive和确认验证合并 | 逐角色正式完成/返回点OI-01 |
| 查询 | State限未完成会话；Reveal为完成key；Corrupt当前内部状态；Expire删除派生key | 泄漏后控制、外部QKD设备边界、历史key、预算OI-02–04 |
| Fresh/Test | H Def.4的目标/匹配会话资格；Test真实最终key或等长均匀值 | 全时序拒绝规则、过期后Test与腐化顺序OI-02/03 |
| 状态生命周期 | 不加入原图未定义的擦除操作 | k1/k2/k*/sk_e/QKD材料擦除OI-06 |

E表示经审查的原组件/故障环境。BG、KO、QS、QB、QT、FF是既有审查标签，不当作新oracle，也不以事后条件化某个失败事件来获得新的安全分布。若使用条件实验或失败概率，必须明示其原模型依据。

R表示运行时间、会话和已有查询预算的资源记账，不据此擅自限制原对手。当前Π输出固定为256-bit最终key；不凭空引入随λ变化的HAKE实现来宣称negligible。若未来采用渐近命题，协议族与参数化也需审查。

## 3. Security targets

### 3.1 Key secrecy：核心待证条款T-SK

在M和E确定后，记

`Adv_SK(P,M,E,A) := |Pr[Exp_SK(P,M,E,A) outputs win] − 1/2|`。

P只取Π或Π′；win表示对手猜对H的隐藏Test位。实验概率涵盖setup、协议/对手随机性和实验已授权的oracle随机性。没有合法Test时如何处理，必须由M给出，不能在此默认为0或重试。Test回答Π′本身的k_h^2，不是原Π的key。

**拟达到的定理规格（尚不成立）：** 对每个获准环境E及资源R内的每个合法对手A，存在面向原Π的有效归约对手B，使

`Adv_SK(Π′,M,E,A) ≤ Adv_SK(Π,M,E,B) + ε_C1(M,E,R)`。

要求B遵守原oracle和freshness约束，其资源开销R′(R)必须显式给出；ε_C1必须由独立验证的接口和事件界导出，不能定义成实际差值、假定为可忽略、设为0，或使用平凡1/2上界伪称安全保持。当前ε_C1与R′均unknown，因此本式是目标关系，不是定理结论。

若原Π的安全界本身尚未核验，不能用原论文声明直接消去右侧。直接分析Π′到适用原语界是另一可能证明策略，但不免除M、source和分支审查；本轮不执行任何归约。

### 3.2 Matching / authentication：T-MATCH

保留H Def.3的Match关系，以及Def.6对matching、完成且未受损双方的key一致性要求。待审事件记号BadMatch(P)仅指**同一个P实验内**符合原条件的两个已完成匹配会话输出不一致；不是Π与Π′之间key相等。

目标是Π′满足原正确性要求；若所用KEM正确性存在允许错误，必须沿原实例/定义给出其依据，不能自设容差。当前正式完成点与资格判定仍open，不给未经来源的错误概率界。

Authentication按H的SK/PFS口径保留，不新增“每个Accept都有唯一匹配伙伴”、injective agreement或独立UKS游戏。单向确认作为实验/视图模拟的一部分，不增设Bob收到确认事件。

### 3.3 Forward secrecy：T-PFS

目标是T-SK覆盖M中原H允许的expire/corrupt历史，而不是排除这些历史后另外声称PFS。实际状态残留和时间顺序必须在M里明确；Expire删除最终key不蕴含中间秘密完美擦除。T-PFS当前open，不扩成PCS、任意临时泄漏恢复或实现级内存擦除结论。

### 3.4 Hybrid robustness：T-HYB

拟保持的是原合同的各存活路径，不能只选择证明容易的环境。计算性路径与原无界ROM/QKD声称分开，不用一个ε符号掩盖不同能力/前提。

| 环境标签 | 拟纳入范围与当前状态 |
|---|---|
| BG / KO | 原计算KEM路径及适用组合目标；source、查询、确认桥未成立 |
| QB | QKD路径且不假设KEM secrecy/binding；不得补入C2PRI/K-PK；open |
| QS | 仅既有额外binding存活候选环境，不默认为主定理前提；若启用须另报较窄结果 |
| QT | 原无界ROM/QKD声称单独核查；B2/B6未闭合，不复制纯失败概率界或引入隐藏查询上限 |
| FF | 原合同没有相应非平凡保证时，不新增安全结论 |

当前没有任何分支的C1保持已证明。完整原合同保持要求所有被声称覆盖的路径都有依据；较窄结果须明确标注范围变化并另审。

## 4. 假设与证明义务分离

逐项见[m7-assumption-table.csv](m7-assumption-table.csv)。existing assumption仅表示原文/所引结果的条件，不表示HAKE满足全部外部定理前提；additional assumption均为已登记但**未采用**的附加条件；open issue必须解决或明确裁决。

source合法性、查询映射、确认视图和C1保持关系本身是待证义务，不能把它们直接当作安全假设来“证明”本规格。没有自动采用K-PK/C2PRI、完美erase、完美identity binding或更强SID规则。

## 5. 规格完成与定理完成的区别

本轮明确了对象、差分、目标关系、量词方向、归约资源/损失槽位、独立正确性条款和失败范围。**这是一份带显式未解接口的严格目标规格，不是语义完全闭合的最终定理陈述。** 填实M/E、外部source适用性、资源和界后才能宣告最终statement冻结；证明完成还需要另行验证所有hop。

固定来源见[sources/README.md](sources/README.md)；模型定位见[security-model.md](security-model.md)。停止于本轮规格审查。
