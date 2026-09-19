# M6.5：Reduction Target Selection — 候选比较

状态：研究对象选择文档，等待 M6.5 审查。没有开始 theorem proof、形式模型或工具运行。比较基于已完成的 [M5–M6 报告](m5-m6-summary.md)、[候选假设](reduction-hypothesis.md)、[证明路线](game-transition-outline.md) 和 [M4.5 分层](binding-layer-analysis.md)，不把文档完成等同安全模型或保持证明完成。

## 1. 比较对象和判断尺度

原输入固定为 H26 Fig.3、§3.1 pp13–15：

```text
c_KEM = A || pk_a || B || pk_b || pk_e || k1 || k2 || k*
c_QKD = A || B || qkdKeyId
σ_KEM = k*       σ_QKD = k_qkd
```

- **C1**：仅研究 c_KEM[8] 的 k* 出现位置；候选 context 为 `A||pk_a||B||pk_b||pk_e||k1||k2`，σ_KEM=k* 保持。
- **C2**：仅研究 c_KEM[5] 的 pk_e 出现位置；候选 context 为 `A||pk_a||B||pk_b||k1||k2||k*`，pk_e 的 KEM、报文、τ1/τ3 用途保持。

这两项只是既有假设差分，不改原协议或实现，不联合投影。两侧处理各自本地值，不预设 k_A*=k_B*、k1=k1′、k2=k2′。

选择依据依次是：研究问题可定位性、额外证明接口数量、原目标与故障分支的覆盖潜力、可审计的验证方法、可能的贡献边界。没有实验数据支持工时、成功率或性能估计，因此不使用加权分数或数值排名。“较简单”仅指相对义务结构，不表示已有证明。

## 2. Security property impact

下表记录**可能受影响的接口**而非已发生的性质损失。最低目标仍是 H26 Def.3–6 的 matching 完成正确性、最终 Key-IND 和原 PFS 范围。Identity binding、transcript integrity 是辅助分析概念，不能默认为新增独立 agreement 定理。

### C1

| 性质 | 保留的结构 | 仍须处理的影响 | 选择意义 |
|---|---|---|---|
| Key Secrecy | σ_KEM 保留同侧 k*，QKD secret 不变 | F 的输入编码改变，原/候选 source、查询记录和最终半段的不可区分接口需重审 | 可将问题集中在完整输入与source/query映射，而非新凭据链 |
| Authentication | A/B、公钥、τ1/τ2 规则及 τ3 message 均不变 | F 改变可影响确认 key、tag 和后续验证；流程相同不等于接受集合相同 | 原认证路径保留，但仍需非循环的确认/会话论证 |
| Forward Secrecy | 临时 KEM、secret 输入和原腐化接口不变 | k* 仍在本地状态中；少一个context出现位置不构成擦除。历史 Test、Expire、残留状态仍开放 | 不把此候选包装为新PFS或PCS机制 |
| Hybrid robustness | 两组件、source 顺序、label、输出拆分及QKD失败检查不变 | BG/KO/QB/QT 各自的source/查询证明仍缺；不能以结构重复消除预测/碰撞余项 | 相较C2，候选动机不首先依赖额外K-PK存活；但全分支覆盖仍未知 |

### C2

| 性质 | 保留的结构 | 仍须处理的影响 | 选择意义 |
|---|---|---|---|
| Key Secrecy | k* 的secret/context位置均保留 | 临时公钥不再是候选F的直接context项；需判断贡献与凭据关系能否支撑原source/会话映射 | 共同B1/B4障碍之外增加跨公钥关系义务 |
| Identity Binding | A/B和预置凭据背景保留 | pk_e→组件key不等于pk_e→预期对端/角色/session；不得由setup补造完美映射 | C2更直接体现primitive→protocol研究问题，但接口更多 |
| Transcript Integrity | pk_e仍在τ1/τ3 message，原MAC规则不变 | 认证路径在何时、何分支可用需论证；τ3后于F，不能反向作为免费前提 | 保留字节覆盖不等于所有transcript语义被覆盖 |
| Authentication | 原KEM-AKE调用和验证位置不变 | Alice收到的pk_e生成域、τ1来源、matching和泄漏后的认证含义均需桥接 | 普通K-PK/C2PRI不能直接填补这些语义 |
| Forward Secrecy / Hybrid robustness（补充） | 临时secret及QKD接口未改 | 临时凭据对应还要适配历史暴露；QB/QT不能使用计算binding/MAC前提 | 比较不能因用户重点不同而忽略C2的这两类义务 |

## 3. Required proof bridge：三层逐项比较

| 层 | C1 需要什么 | C2 需要什么 |
|---|---|---|
| Primitive guarantee | 原分支所需KEM/QKD源保证、适用KDF安全接口；σ保留可支撑合法同侧记录的结构恢复观察。当前没有依据认定必须新增K-PK，也不能认定不需要任何primitive义务 | 原有保证之外，若采用绑定路线，需实际实例在适域HON/LEAK/MAL及PPT/QPT条件下的K-PK或明确替代结果；C2PRI固定pk，不满足跨pk需求 |
| Protocol guarantee | 合法记录到session/匹配双方/重复派生及Test/Reveal的映射；确认半段可见下最终Key-IND；不以σ存在预设跨会话一致 | 所有共同接口，外加组件key/pk_e到预期身份、角色、s和临时会话记录的独立桥；τ1来源不可先假定，τ3不可循环使用 |
| Hybrid guarantee | 两source、秘密context/公开α、查询索引、QKD一次性与⊥行为；每分支采用其实际存活保证 | 同样的组合接口，加上绑定路线能否在每分支成立；QS中binding存活不自动保留MAC，QB/QT中该计算路线不可直接使用 |

共同最大阻塞项仍是 **B1/B4**：K25 Def.1 要求 context 可从公开 α 提取，而 HAKE context 含秘密。C1 不自动解决 k1/k2；C2 保留 k* overlap。不能通过公开秘密、重划 σ、改 KDF 或禁止原本合法泄漏来适配定理。

OI-01–OI-06（完成/接受、Test、Expire/Corrupt、泄漏后控制、SID域、擦除）保持开放。选定候选不替代人工语义裁决。

### 原失败分支的选择约束

| 分支 | 对主路线选择的约束 |
|---|---|
| BG / KO | 两候选均需共同接口；KO不得借理想QKD同步补缺，QKD fail不缩成仅泄密 |
| QS | 仅表示指定binding存活的较窄候选环境，不能作为完整原合同的替代 |
| QB | 不假设KEM secrecy/binding；C2的K-PK路线在此缺少前提。C1只有较少的额外绑定依赖动机，并非已有此分支证明 |
| QT | 原无界ROM/QKD声称单列；两候选都不能借计算性保证，也未解决原预测/碰撞余项和oracle能力问题 |
| FF | 不增加原合同未承诺的非平凡保证，不以“都缺保证”声称安全等价 |

## 4. Attack surface：失败条件而非攻击构造

以下是防御性研究审查中的抽象失效路径，只描述“哪段关联若不成立，什么目标可能受影响”。没有消息注入步骤、可执行轨迹、攻击搜索或漏洞判断。每个类别都须在原 H 能力/freshness 内成立并关联原目标，才可能成为有效分离证据。

| 候选/类别 | 可能出问题的关联 | 必须区分的边界 |
|---|---|---|
| C1：cross-session key confusion | 本地派生记录到会话/匹配关系的映射若不保留，合法非目标泄漏或重复调用可能被错误关联到目标记录 | 仅有不同SID或相同context不构成安全失败；还需合法freshness与目标优势/正确性影响 |
| C1：KDF input collision / alias | 编码或查询登记若混同原本需要区分的完整输入，可能破坏所用KDF接口 | 必须区分context相同、完整编码输入相同、不同输入的输出碰撞。合法同侧记录仍含σ，原重复项可从中识别，不能仅凭少一项就断言出现新完整输入碰撞 |
| C1：抽象遗漏 | source/α或RO查询模拟若只覆盖诚实元组，可能漏掉合法查询和泄漏行为 | 这首先是证明/模型缺口，不是线上泄密或协议攻击 |
| C2：ephemeral substitution 类失败 | 原语key/pk关系与接收方预期临时会话关联断开，可能损害认证或匹配解释 | pk_e仍受τ1/τ3原流程处理；必须解释保留机制为何不足，不能把候选等同无认证公钥交换 |
| C2：unknown key share 类失败 | key、凭据与双方有序身份视图之间的映射不成立，可能出现错误伙伴解释 | 原文UKS讨论不是独立已冻结游戏；不能以新增强agreement失败直接宣布原SK失败 |
| C2：transcript ambiguity | 对应贡献相同或有关联，但pk_e/会话视图的差异未被候选证明记录捕获 | K-PK不提供完整transcript；τ3的后置覆盖需联合分析，不能预设结果 |

风险类别用于选择证明问题，不构成已发现的攻击。两候选都应避免把模型伪差异、规格未定义行为、附加性质失败与原协议漏洞混为一谈。

## 5. Formal verification feasibility

方法边界：Tamarin 基于符号密码学、消息项和等式理论；其结果依赖建模时选择的算子性质。[Tamarin 官方消息模型说明](https://tamarin-prover.com/manual/master/book/004_cryptographic-messages.html)。它可检查给定模型中的轨迹性质；这不直接提供本项目所需的计算归约损失。[Tamarin 官方简介](https://tamarin-prover.com/manual/master/book/001_introduction.html)。下表是据此及本项目义务作出的可行性判断，不是运行结果。

| 方法 | C1 | C2 | 判断 |
|---|---|---|---|
| Tamarin modelling | 可辅助审查状态生命周期、会话关联、QKD一次性和确认方向；但秘密重复与source/α/KDF概率界可能在理想项中完全不可见 | 身份/临时凭据/消息对应更贴近符号轨迹问题；同时较容易在KEM构造子里预置本应研究的绑定 | C2的协议对应问题更适合符号表达；这不意味着它更容易得到可信的计算安全结论 |
| Game-based proof | 单位置及同侧σ保留给出更集中的输入/查询问题；共同source及确认接口仍艰难 | 除共同接口外还需跨pk原语游戏到会话的归约和分支适用性 | C1更适合作为首个计算分析对象；目前两者均不能直接开始有效证明链 |
| Symbolic abstraction | 风险是把KDF视为理想自由构造子后，过早得到不反映B1/B2的结论 | 风险是让key项显式包含pk，自动获得过强K-PK；或用公开泄露近似任意组件失败 | 两者都需先说明哪些关系由抽象假定，哪些关系才是待验证结论 |

不能用“没有找到符号反例”替代 Key-IND、RO/QROM、C2PRI 概率界或无界ITS分析。若未来要比较原/候选的符号等价，须另审等价目标是否强于实际保持目标；本轮不选等式、事件、规则或查询，也不写模型。

## 6. 综合选择

选择 **C1 为 Primary Candidate，C2 为 Secondary Candidate / future work**。

理由是C1能先把原输入保留的信息、KDF接口与HAKE会话语义的关系集中到一个同侧重复位置，而C2同时要求额外凭据来源和跨层绑定链。选择没有规避共同难点：B1/B4、确认、PFS语义与QB/QT仍是主路线明确的失败/停止条件。

C2更直接呈现primitive→protocol的潜在新颖性，但不能因此跳过基线接口。C1也可能最终只得到已有方法的实例化或基线接口澄清；不能把选型自动称为创新成果。正式决策见 [primary-reduction-selection.md](primary-reduction-selection.md)，贡献边界见 [contribution-refinement.md](contribution-refinement.md)。

证据来源：H26 Def.3–7、Fig.3、§3.1；K25 Def.1–3；D24 Def.4.1；X24 Def.7；B23 Fig.8。锁定版本与哈希见 [sources/README.md](sources/README.md)。本轮未重新开展穷尽性查新。
