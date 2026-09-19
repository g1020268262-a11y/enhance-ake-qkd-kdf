# M7.5：Security Target Selection

状态：安全目标比较完成，未开始证明。目标选择必须服从 H26 已有定义；不能为了降低成本而悄悄创造一个更弱、未定义的 HAKE 游戏。

## 1. 三个选项

| Option | 表面目标 | 证明成本 | 安全价值 | 所需条件 |
|---|---|---|---|---|
| A | Key secrecy only | 最低，但仍需source/query、Test、确认半段和分支接口 | 可回答最终key保密；不覆盖Def.6的matching正确性 | 完整Key-IND实验、freshness、KDF/确认映射；若排除PFS历史则需另定义弱化模型 |
| B | Key secrecy + matching | 在A上增加matching完成双方的正确性和事件接口 | 对AKE最低完整性更好，避免只证明随机性而忽略匹配双方输出一致 | A的全部条件；Def.3关系、正式完成点和组件正确性 |
| C | Key secrecy + matching + PFS | 最高；增加Expire/Corrupt时序、状态残留与历史Test模拟 | 最接近H声明的secure AKE目标，保留后期长期key失陷下的原安全价值 | B的全部条件；OI-02/03/04/06及历史状态的完整模拟 |

Hybrid robustness不是与A/B/C并列的第四性质，而是所选保密/正确性目标在哪些组件故障环境中成立的**范围维度**。不能用只覆盖BG的Option C冒充原hybrid范围，也不能把QT与计算性路径混合。

## 2. 关键语义：三个选项并非完全独立

H26 §2.5明确把 secure authenticated key exchange 定义为SK-secure且提供PFS；Def.4称其freshness包含forward secrecy，Def.6的SK-security又同时包含matching完成双方key一致和Key-IND。

因此：

- 若Option A/B仍使用H原freshness，那么PFS资格已经嵌入Key-IND，A/B并未真正排除PFS成本。
- 若A/B排除expire后corrupt的fresh历史，则必须定义一个新的弱化实验；原文没有给出该独立baseline，当前阶段无权补造。
- matching正确性是Def.6的一部分；将其从主结论拿掉会把目标从原SK-security降成一个自定义子性质。

这意味着单按标题选择A或B不能合法绕过PFS/完成语义。它们可作为未来证明中的中间lemma或审查分解，但不能在不新增模型的情况下替代原主目标。

## 3. Primary theorem target

**选择 Option C：Key secrecy + matching + PFS，按H原安全目标解释。**

选择理由：

1. 它与H26 Def.3–6及“freshness includes forward secrecy”的原口径一致，不需要发明一个去掉历史腐化的弱模型。
2. matching correctness是原SK-security的组成部分，保留它不会暗中升级为injective agreement或独立身份认证游戏。
3. C1若只在排除原PFS历史后可证，应被明确报告为范围缩减，而不是安全保持。
4. 该选择提高证明成本，但真实暴露当前OI-01–06，而不是用目标命名规避它们。

Primary target不包含PCS、双向显式key confirmation、strong identity agreement、key independence或一般context elimination。Authentication只沿H的SK/PFS口径使用；UKS/KCI文字讨论不升格为独立定理。

## 4. 分阶段使用A/B的方式

可将以下内容作为未来证明组织方式，而不是新主定理：

- A-like lemma：在已冻结H实验的某个固定挑战历史内，建立候选最终key的real-or-random接口。
- B-like lemma：另证matching且满足原完成/未受损条件的双方使用一致候选输入并获得同一key。
- PFS lifting：证明上述模拟覆盖M允许的expire/corrupt历史和状态残留。

这些分解不能改变同一个最终Option C的量词、freshness或failure范围。任何中间结果的成功都不能单独宣称C1安全保持。

## 5. 当前可证明性判断

Option C是正确主目标，但尚不可进入完整证明：OI-01–06使PFS/完成实验未闭合；KDF interface lemma和确认映射也未建立。目标选择完成不等于证明接口已满足。若后续只能支持A/B式弱化目标，需要人工批准新的研究口径后另立声明；本轮不选择该降格。

