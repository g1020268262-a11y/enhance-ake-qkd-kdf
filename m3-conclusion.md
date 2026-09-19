# M3 conclusion

日期：2026-09-19。**OPEN ISSUE / WAITING FOR HUMAN REVIEW**。本轮审查材料已交付，完整安全模型未冻结，M3.2 不标完成。

## 已确定

- M2 已经用户审查通过 G1，保持 HAKE 特定 context reduction 研究目标，不扩展为一般 Context Elision Framework。
- HAKE context reduction 不是 primitive-level omission 问题，需要 protocol-level proof bridge；不能由 KEM binding 直接推出字段可删。
- 当前四个候选 E01–E04 均没有删除结论，本轮没有重新分析字段安全职责或判定删除安全性。
- H26 是规范来源；CK01 与 Boyd 是独立参考，不能融合以填补原文。

## 未确定

- 每个字段具体贡献。
- 哪些 binding property 可以替代哪些协议职责。
- 是否存在最小 context。
- 完整 Accept/Complete/Return、Test、过期/腐化、泄漏后行为、SID 唯一性域及擦除规则，见 [安全模型](security-model.md) 的 OI-01–OI-06 和 [假设表](model-assumption-table.csv)。

## 下一阶段

人工裁决并通过语义冻结审查后，M4 才执行：

`field → security property → required assumption → possible redundancy`

这是职责与假设映射，不是预先批准删除。source/KDF/RO 等既有证明义务保留，模型冻结也不等于安全证明。

# M3.2 Completion Report

## 1. 冻结后的安全模型

仅来源与明示规则已锁定。规范目标为 H26，R-CK 与 R-Boyd 分开记录。**没有已经批准的完整可执行游戏**；不自行选择 CK 替代、历史 key 留存或融合模型。

## 2. 修改文件列表

| 文件 | 变更 |
|---|---|
| [security-model.md](security-model.md) | 三来源映射、六项 OPEN ISSUE；修正事件顺序及优势绝对值；撤回未经支持的补全 |
| [model-assumption-table.csv](model-assumption-table.csv) | 新建指定 5 列、16 项来源及采用状态记录 |
| [security-contract.csv](security-contract.csv) | 保留 33 单元；义务列改名 proof_obligation；PFS 不再假装已选择 CK 时序 |
| [hybrid-branch-compatibility.csv](hybrid-branch-compatibility.csv) | 保留四候选；统一标识 candidate hypothesis、proof obligation、requires validation，无删除或准入结论 |
| [m3-conclusion.md](m3-conclusion.md) | 本结论与报告 |
| [m2-m3-status.md](m2-m3-status.md) | 追加本轮状态，保留历史记录 |
| [路线图.md](路线图.md) | 记录 G1 通过与 M3.2 OPEN ISSUE；保持未勾选 |
| [scripts/validate-m2-m3.ps1](scripts/validate-m2-m3.ps1) | 增加假设表 schema、标签与开放问题检查 |

未修改原论文、协议或 M2 核心结论。页面渲染仅用于阅读核验，保留在 tmp/pdfs/m3-closure/，不是新增论文证据。

## 3. 已解决的语义问题

已查明 H matching 的相反角色条件及 Alice 的 F／拆分／验证顺序；已区分 CK 的 Return/Expire、单侧过期后腐化、State reveal 后不再输出；已识别 Test 时机与随机回答分布差异。解决的是来源定位，不是自动采用参考规则。

## 4. 仍是假设的内容

OI-01–OI-06 均未裁决：接受/完成、历史 Test、过期/腐化操作、泄漏后控制、SID 域、临时状态擦除。验证成功才 Complete、challenger 保存历史 key、继承 CK 停止规则或历史去重等均只是可能解释，尚未采用。RO/source/binding 提升仍是既有待验证义务。

## 5. 是否可以进入 M4

**不可以。** 等待人工确认 OI-01–OI-06 的规则、来源和偏离 H 的范围，再审查冻结。没有构造 reduced HAKE、运行攻击搜索或 Tamarin、编写 theorem，也未 commit/push。本轮停止。

## 文档核验结果

`scripts/validate-m2-m3.ps1` 与 `git diff --check` 通过：假设表 16×5、合同 33×11、候选表 4×17；合同引用、假设标签和开放问题一致；10 个来源哈希、9 个 BibTeX 条目及本地链接通过检查。这里只验证文档结构和证据文件一致性，不验证安全游戏或协议安全性。
