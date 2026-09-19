# M7：Theorem Boundary and Review Gate

## 1. 本阶段完成了什么

仅完成C1的待审定理规格：对象、唯一context差分、Key-IND目标关系和量词、matching正确性、PFS与hybrid范围，及G0–G3的未知差分。没有实施Π′、证明安全、解决所有模型缺口或建立一般KDF框架。

本轮用户授权的是规格细化，因此此前文档的“未进入M7”保留为历史。此授权不表示之前列出的证明前提已满足。

## 2. 定理边界

| 边界 | 本轮采用的限制 |
|---|---|
| 对象 | HAKE-specific C1，只考虑c_KEM[8]的出现位置；σ_KEM=k*保留 |
| 其他输入 | pk_e、pk_a、pk_b、A/B、k1/k2、qkdKeyId及QKD context不改；无联合投影 |
| 协议操作 | 消息结构、KEM、QKD、MAC及key来源规则、失败检查、label/source顺序/输出拆分不改 |
| 输出与轨迹 | 不要求Π和Π′相同key/tag，不预设接收/中止集合或自适应视图相同 |
| 模型 | H原文优先；不融合CK01/Boyd；OI-01–06保持open |
| 性质 | 原最终Key-IND、matching完成正确性、原PFS和分支目标；无新增强agreement/PCS |
| 外部结果 | K25/K26、KEM binding等只能在其前提和实际接口已验证时使用 |
| 额外假设 | X01/X02登记但未采用；未加入完美erase、identity binding或强SID机制 |
| 失败语义 | 不在QB/QT恢复已失效binding/MAC，不把QS当完整robustness；不删预测/碰撞余项 |
| 工具与实现 | 不编写/运行Tamarin、攻击搜索或协议代码；本轮仅Markdown与假设CSV |

## 3. 禁止的循环或空洞定理

不能假设“候选context已足够绑定”来推出候选安全；不能假设“理想化合法”来跳过source接口；不能从原总体安全直接获得单位置保持；不能用τ3安全反向建立其自身F输入的充分性。

ε_C1和归约资源不是任意选择的上界装饰。不能取平凡界、将结论差值改名为假设，或不说明损失便称安全等级不降低。原基线接口问题也不能通过把原安全当未经审查的黑盒假设而隐藏。

## 4. 尚待人工审查的规格接口

1. M：完成/输出、历史Test、Expire/Corrupt、泄漏后控制、SID域及擦除。若原文没有定义，明确记录not explicitly specified，不自行补造。
2. source：B1、B3、B4及实际编码/查询域。C1的结构恢复观察不解决k1/k2秘密context。
3. 目标界：资源预算、归约开销、ε_C1来源、原正确性容差（如存在）和优势归一化。当前均未给可用界。
4. 确认：τ3可见时最终key及允许泄漏的联合视图，避免后置确认循环。
5. 分支：原计算路径与QT独立陈述，哪些结论是原保持、哪些只能是更窄条件结果。

**最终定理尚不能冻结。** 当前可以审查规格是否准确划定问题，不能批准字段安全删除。若必须新增假设才能继续，应单列提案和范围变化，等待用户决定，而非默认采用。

## 5. 交付与停止

- [m7-theorem-definition.md](m7-theorem-definition.md)：两个对象、共同实验接口、四类目标与待证关系。
- [m7-assumption-table.csv](m7-assumption-table.csv)：existing assumption / additional assumption / open issue分列登记。
- [m7-game-hops.md](m7-game-hops.md)：G0–G3的difference、assumption、status与损失槽位。
- 本文件：范围、禁用推论及审查入口。

此前来源、模型、路线图、假设表和实现不因本轮交付改写。停止，等待M7审查；不开始证明、不证明pk_e、不运行Tamarin。

## 6. 文档验证记录

已有M2–M4文档校验和10份来源哈希检查通过。新假设表为21行×7列：7项existing assumption、2项未采用的additional assumption、12项open issue；经独立读取及表格工具导入检查，无空单元或意外公式。按科研记录规范显式保留分类、来源、适用范围和采用状态，不以表格外观表示证明通过。新增Markdown链接与代码块围栏检查通过；工作区仅新增指定四份文件。未commit/push。以上为文档结构检查，不是密码学验证。
