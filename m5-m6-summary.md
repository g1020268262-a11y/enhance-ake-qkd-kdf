# M5-M6 Completion Report

状态：候选构造与安全保持**分析文档完成，等待审查**。没有实现候选协议、没有证明安全保持、没有进入 M7。

## 1. 新增文件

1. [candidate-reduction-analysis.md](candidate-reduction-analysis.md)：固定原输入、可见性分类与两个单位置候选差分。
2. [context-reduction-candidates.csv](context-reduction-candidates.csv)：11 个位置、8 列；只使用许可的候选状态。
3. [reduction-hypothesis.md](reduction-hypothesis.md)：C1/C2 前提、缺口及禁止的循环论据。
4. [security-preservation-framework.md](security-preservation-framework.md)：原/候选对象、原目标、分支、SP-01–05 和 M7 门槛。
5. [proof-obligation-matrix.csv](proof-obligation-matrix.csv)：17 项义务、6 列；5 项共同义务及两个候选各 6 类分支。
6. [game-transition-outline.md](game-transition-outline.md)：直接转换的未知差分及双路径理想化接口，未执行证明。
7. 本报告。

本轮只新增上述七个文件，不修改旧路线图、基线、来源、协议代码、MAC/KDF 实现或原合同结论。旧文件的阶段停止文字保留为历史记录，本报告记录此次仅文档阶段授权。

## 2. Candidate 列表与 reduction potential

评分只表示**当前研究切口的清晰度/优先级**，不是安全概率、必要性或删改建议。表中 potential 只使用 high / medium / low。

| 字段 | potential | 候选/初步分析范围 | 主要理由 |
|---|---|---|---|
| k* | high | C1：仅 c_KEM[8]；σ_KEM不变 | 同侧重复使位置级问题最窄，仍有共同KDF接口阻塞 |
| pk_e | medium | C2：仅 c_KEM[5]；其他用途不变 | 可明确区分K-PK到组件与认证到会话的两段义务 |
| pk_a | medium | C3初步登记，无投影 | 可调查凭据路径，但身份和失败域未覆盖 |
| pk_b | medium | C3初步登记，无投影 | 同上，且需单独处理τ1方向 |
| A | low | 两context位置分别登记，无投影 | 逻辑身份/节点/会话不在primitive游戏内 |
| B | low | 两context位置分别登记，无投影 | 有序身份及方向相关对应缺口 |
| k1 | low | C3初步登记，无投影 | 认证贡献、秘密context和确认共同依赖 |
| k2 | low | C3初步登记，无投影 | 另有含QKD ID的认证消息接口 |
| qkdKeyId | low | C3初步登记，无投影 | 检索一次性不等于应用会话绑定 |

C1 与 C2 独立，未研究联合投影。C3 不是组合候选。没有任何字段被判定可删除。

## 3. 每个候选的 proof obligation

- **C1：** 同侧 σ/context 关系到完整查询记录的桥；secret/context overlap 与真实辅助信息；matching/重复调用及合法泄漏；确认半段可见下最终 Key-IND；六类故障分支与原 PFS。见 C1-BG–FF、SP-01–05。
- **C2：** 精确 K-PK/生成/泄漏/攻击者域到贡献关系，再到 identity/role/SID/ephemeral session；与 QKD/source 的组合；τ3 非循环处理；全部共同义务。QB/QT 中不能借用计算性 binding。见 C2-BG–FF、SP-01–05。
- **C3：** 仅继承 M4 的 PO-01–04、PO-06/07/09 初步缺口，没有可执行 reduction 或新证明结论。

## 4. Security preservation framework 是否成立？

框架的对象、范围和待证接口已建立；**安全保持关系尚未证明成立**。仍没有完整游戏、有效完整 game-hop chain 或归约损失上界。

“协议行为相同”仅落实为除 context 参数外原操作/接口/消息结构不变。F 输出、τ3 tag、验证结果和自适应轨迹不能预设相同。原单向确认不升级为双向确认。

## 5. 当前最大 proof gap 与现有工作边界

首先是 **B1/B4：原与候选共同的合法 source/辅助信息/查询映射**。K25 的 c 可由公开 α 提取，HAKE context 含秘密；C1 的结构重复观察不能解决 k1/k2，C2 仍保留 k* overlap。缺少这一步，不能合法套用 KDF 安全结果。

其次是 **primitive binding → protocol binding → hybrid composition**。C2 尤其需要 key/pk 到会话身份/角色的独立桥，且不能在 QB/QT 恢复失效假设。OI-01–OI-06、B2/B6/B7 也仍阻塞完整安全声明。

| 已有工作 | 为什么不能直接覆盖本任务 |
|---|---|
| X-Wing / C2PRI | 固定pk挑战的原语/combiner结果，不给HAKE身份、会话或QKD对应 |
| Starfighters / hybrid KEM input omission | 针对具体KEM/combiner及其条件；不自动覆盖HAKE认证、泄漏、确认与source接口 |
| D24 K-PK/K-CT | 精确原语对象关系，非HAKE计算SK/PFS及全故障分支证明 |
| Boyd KEM-AKE | 原路径不含HAKE的QKD、F、秘密context及τ3新增接口 |
| K25/K26 multi-input KDF | source、α、req和oracle域有前提，非任意context投影不变性结果 |

定位依据沿用 [M2差异审查](novelty-gap.md) 与 [固定来源](sources/README.md)，不是重新宣称文献穷尽或首次贡献。

## 6. 最小未来 theorem 范围与 M7 判断

建议先审查 **HAKE-specific、C1 单位置、原目标及明确原故障范围的安全保持问题**，而不是 general context elimination theorem。这里只给范围，不写定理；若只能给较窄分支或额外binding条件，必须明确降格为条件结果，不能称完整原合同保持。

**当前不满足进入 M7 的条件。** 需要人工批准候选/分支范围并处理所用模型语义，闭合 source/查询接口、非循环协议桥与损失账本。不能以文档已完成代替这些条件。

## 7. 文档验证记录

- 原 M2–M4 文档验证通过，10 份固定来源哈希匹配，既有合同与阶段记录未改。
- 两份 CSV 经独立读取和表格工具导入检查：分别为 11×8、17×6（不含表头），无空单元或意外公式，候选状态均在许可集合中。
- 新增 Markdown 的本地链接及代码块围栏检查通过。工作区仅新增指定七份文件；未 commit/push。
- 按科研记录规范保留平面文本表、来源定位、未知项和状态，不生成额外 XLSX 或预览。这些检查验证文档结构与一致性，不验证密码学结论。

本轮未删除字段、未修改HAKE KDF、未构造最终reduced协议、未声称证明完成、未运行Tamarin/攻击搜索、未扩展一般框架或增加攻击者能力。到此停止，等待审查。
