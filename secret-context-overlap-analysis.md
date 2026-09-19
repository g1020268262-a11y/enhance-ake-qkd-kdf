# M7.5：Secret–Context Overlap Analysis

状态：证明接口分析完成，接口条件尚未证明。只分析 C1，不修改 HAKE，不把“同一字节串出现两次”当作可删除结论。

## 1. 对象与角色本地读法

对任一角色 P，记其临时 KEM contribution 为 `z^P`：Alice 为 `k_A*`，Bob 为 `k_B*`。原输入与 C1 候选分别是：

```text
Original Π:
σ_KEM^P = z^P
c_KEM^P = A^P || pk_a^P || B^P || pk_b^P || pk_e^P || u1^P || u2^P || z^P

Reduced Π′:
σ_KEM^P = z^P
c'_KEM^P = A^P || pk_a^P || B^P || pk_b^P || pk_e^P || u1^P || u2^P
```

其中 Alice 的 `(u1^A,u2^A)=(k1,k2′)`，Bob 的 `(u1^B,u2^B)=(k1′,k2)`。这是 [H26](2026-1231.pdf) Fig.3、§3.1 pp13–15 的本地值展开，不预设两端 contribution 相等。σ_QKD、c_QKD、label、source order 和输出拆分均不变。

## 2. k* 作为 secret input 的作用

`σ_KEM=z` 在 multi-input KDF 的语法中占据 KEM source 的秘密位置。其候选安全作用是：

1. **秘密贡献。** 在相应分支与泄漏条件下，z 的 unpredictability/pseudorandomness 可作为 KDF 输出保密性的一个来源。是否满足具体 source 定义仍需证明。
2. **source 身份。** KDF 游戏把 `(σ,c,α)` 登记为某一 source 的输入；σ 的 honest/dishonest 状态和 source position 会影响 `req` 是否成立。
3. **hybrid 存活路径。** 当 KEM source 是被依赖的存活 source 时，σ_KEM 是候选 entropy-bearing input；当该 source 失效时，不得靠其存在恢复安全。
4. **完整输入的一部分。** 即便 context 不含 z，实际 F 输入仍含 z；因此 C1 不是从整个 KDF 输入中删除 k*。

这些作用不提供：跨角色 `k_A*=k_B*`、会话 matching、身份认证、状态擦除，或任意 failure branch 中的 KEM 保密。secret input 的存在也不自动满足 K25 的 source/α 前提。

## 3. k* 作为 context occurrence 的作用

原 `c_KEM[8]=z` 不是独立随机源，因此不能据此声称增加独立熵。它在原输入中的候选作用不同：

1. **输入域/查询身份。** context 是 F 调用编码的一部分；重复 z 会改变原始 hash/RO 查询点以及查询相等关系。
2. **显式 secret–record equality。** 在合法同侧记录中，context 尾项声明“该记录的 context contribution 与 σ_KEM 是同一值”。这可能参与 source/query 记账。
3. **session/contribution separation 的候选辅助。** 若两个记录的其他字段相同而 z 不同，原 context 和 secret 两处都会变化；候选只在 secret 位置变化。是否影响安全取决于完整编码与查询模型，而不是字符串计数。
4. **协议到 KDF 模型的接口。** 外部 KDF 定理如何解释该 secret-bearing context，是 B1 的核心问题。原 context 位置存在并不证明这种解释合法。

context occurrence 本身不认证身份、不证明 contribution 来源、不提供 K-PK/C2PRI，也不保证两次不同调用永不产生相同输出。

## 4. 两种作用是否相同？

**在语义角色上不同，在合法原记录的取值上相等。**

| 维度 | secret input z | context occurrence z |
|---|---|---|
| KDF/source角色 | entropy-bearing key material；带source/honesty标签 | KDF输入域与记录/查询context |
| 对手可见性 | 依具体source、泄漏和腐化而定 | K25要求c可从公开α提取；HAKE这里却是秘密值，接口冲突 |
| 相等关系 | 本地生成/解封所得值 | 原规范要求合法记录尾项复制同一值 |
| 安全效果 | 可支撑不可预测性或伪随机性 | 可改变查询点并显式记录secret–context一致性 |
| 可互换性 | 未证明 | 未证明 |

因此不能写“作用相同，所以删除”。正确的问题是：在严格限定的合法输入语言和查询接口下，保留的 secret input 是否足以重建/模拟原 context occurrence 对**目标安全实验**的全部影响。

## 5. 若作用不同，缺少什么 bridge？

缺少的是 **HAKE-specific Secret–Context Elision Bridge**，至少包含六部分：

1. **Well-formedness。** 定义合法 KDF 记录集合 W，且对 W 中每条原记录证明 `c_KEM[8]=σ_KEM`；不能把该关系扩展到任意攻击者注册的字符串。
2. **Canonical encoding。** 明确 original/reduced 编码、长度和边界，使两个编码各自无歧义，并给出从合法 reduced 完整元组到 original 完整元组的高效唯一 lift。
3. **Equality/collision preservation。** 对目标实验真正允许的记录，证明 lift 保持必要的查询相等/不等关系；不得把“context 相同”与“完整 F 输入相同”混为一谈。
4. **Source/auxiliary compatibility。** original 和 reduced 都需有不泄露 k1/k2/z 的真实 α 解释，或由新 lemma 明确允许 secret-bearing context。不能通过公开秘密来满足 K25 Def.1。
5. **Adaptive-query simulation。** 将协议产生、攻击者登记、KDF/Ro$-KDF 以及任何获准 raw-RO 查询映射起来；处理对手同时查询 original/reduced 域或猜中隐藏完整输入的 bad event，并给出非平凡界。
6. **Protocol lifting。** 保持 matching、合法 Reveal/State/Corrupt/Test、QKD 记录、τ3 确认视图及各 failure branch 的适用保证，不用后置 τ3 循环证明其自身 F 输入充分。

其中第 4–5 项目前是最大阻塞。第 1 项的本地结构观察已经存在，但尚未被提升为安全 lemma。

## 6. 若希望形式化为“相同职责已被覆盖”，需要什么条件？

以下是**候选充分条件清单，不是已证明事实**：

- 存在两个明确的编码 `Enc_O`、`Enc_R` 和仅在 W 上定义的高效 injective lift `L`，满足 `Enc_O(w)=L(Enc_R(w))` 的精确定义，并保持所需查询等价类。
- W 的生成和检查不依赖待证的 C1 安全结论；攻击者不能借不同解析得到同一语义或跨协议域混淆。
- 对每个 honest/dishonest input、source position、query index 和允许泄漏，original/reduced 记录可双向对应；不合法记录的处理与原游戏一致。
- 若 F 被建模为 RO-based KDF，则存在可证明的 oracle relabeling/programming 模拟，且对手命中未登记对应点的概率由 source unpredictability 等**已适用**的量界定。两个不同 RO 点的输出不能被声明为数值相同。
- 若使用具体 SHA-3 实现，上述 RO relabeling 只是一项模型论证，不给出 concrete-function 输出等价；不得将两者混同。
- 512-bit输出、τ3对前半段的使用和最终后半段Test的联合视图，在映射后仍符合所用安全实验。
- BG/KO/QB/QT 分别满足其允许的前提；QS若使用只形成额外条件下的窄结论，FF不新增保证。

只有这些条件被实例化并证明后，才能说 retained secret input 在目标实验中 subsumes 该显式 context occurrence 的职责。当前结论是**条件已明确，但未满足**。

## 7. 本轮结论

k* 的两次出现不是同一形式角色；相同取值仅为构造 bridge 的起点。C1仍有一条可研究的条件路径：合法记录 lift + source/查询模拟 + protocol lifting。现有文档未给出该路径的证明或损失界。

