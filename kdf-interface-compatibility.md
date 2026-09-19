# M7.5：KDF Interface Compatibility

状态：接口对照完成；现有 KDF theorem 对 HAKE/C1 的直接适用性未建立。主要参考固定历史版 [K25](sources/2025-657-kdf-20250410.pdf) Def.1–6、Fig.3/Table1 pp8–13；修订版 K26 仅用于核对既有 B2/B6，不将版本差异融合成新定理。

## 1. 现有 KDF 模型要求的输入结构

K25 将每个 key-material source 建模为产生 `(σ,c,α)` 向量的分布。Def.1 明确要求 c 包含在 α 中，即可以从 α 高效提取 c；预测游戏把 α 给对手。Def.2 的 source collection 要求不同 source 可独立采样，source 内部可相关，并以 `Σ-map` 将 KDF 输入位置映射到 source。

KDF security game允许：

- `NewKey` 登记 honest `(σ,c,α)` 并向对手返回 α；同一采样项只分配一次，但登记后的 key material 可用于多次派生。
- `SetKey` 登记攻击者选择的 dishonest input。
- `Ro$-KDF` 返回真实或随机输出，`KDF` 返回真实输出；查询通过输入索引选择各 source 的 `(σ,c)`。
- `reqN/reqX` 至少约束 challenge freshness、至少一个 honest key、dishonest input不重复碰撞、honest input位置合法；`reqHybrid(S)` 另要求指定good source的honesty/一次使用条件。
- label与输出长度是显式参数；固定label/长度时有相应简化游戏。

这些是外部定理的游戏条件，不是HAKE天然满足的事实。

## 2. HAKE实际输入结构

HAKE使用两个 `(secret,context)` 输入：

```text
(σ_KEM,c_KEM) = (k*, A||pk_a||B||pk_b||pk_e||k1||k2||k*)
(σ_QKD,c_QKD) = (k_qkd, A||B||qkdKeyId)
```

C1仅将第一项改为 `(k*, A||pk_a||B||pk_b||pk_e||k1||k2)`。因此C1去掉了secret/context overlap中的一个位置，却没有消除 k1/k2 仍是秘密context这一事实。

协议层还有以下结构：τ2把公开qkdKeyId纳入以k2为key的MAC；Bob检索失败则中止；F输出一分为二，τ3公开使用前半段产生的tag，Test目标是后半段。匹配双方、本地重复/非匹配会话、Reveal/State/Corrupt和失败分支尚未映射到KDF索引/query requirement。

## 3. Compatibility matrix

| Requirement | KDF theorem | HAKE / C1 | Status |
|---|---|---|---|
| secret source | 每个输入位置来自已定义source的σ；honest/dishonest及unpredictability/pseudorandomness有游戏含义 | σ_KEM=k*、σ_QKD=k_qkd；具体协议执行到source样本/索引及合法泄漏的映射未给出 | partially aligned / requires source bridge |
| public context | c可从返回给对手的α高效提取；source安全在该辅助泄漏下定义 | 原c_KEM含k1/k2/k*；C1后仍含k1/k2，不能作为公开α而不改变对手能力 | incompatible as a direct instantiation / blocked |
| independent randomness | 不同source可独立采样；source内部允许相关；安全界依赖指定good source及req | H Lemma2声称两个子协议独立，但τ2携带qkdKeyId且协议中有认证/选择/中止；secret采样独立不自动给出条件执行分布独立 | requires protocol-to-source conditioning bridge |
| domain separation | KDF接收source positions、context、label、输出长度；证明通常要求适当输入编码 | HAKE固定label和source顺序；拼接的长度/类型编码及original/reduced query-domain关系未正式指定 | label present; encoding/domain proof open |
| adaptive queries | NewKey/SetKey/Ro$-KDF/KDF及req显式管理challenge/real queries、重复项与位置 | HAKE允许并发会话和协议泄漏查询；尚未映射到索引、reqN/reqHybrid、raw RO能力及τ3后的自适应视图 | incompatible until query simulation is defined |

### 补充：输出与确认接口

KDF theorem给整个请求长度的real-or-random输出。HAKE先请求512 bits，用前256 bits生成公开τ3，后256 bits作为Test key。需要证明“公开依赖前半段的tag后，后半段仍满足目标”的联合视图；不能由输出长度或拆分语法直接推出。

## 4. Existing theorem 还是 new lemma？

### 直接结论

**当前不能直接使用 existing KDF theorem 完成 C1。** 至少 public-context、protocol/query mapping、输出确认接口三项不兼容或未建立。C1本身只处理 k* 尾项，没有修复 k1/k2 对公开α条件的冲突。

### 仍可保留的两条研究路线

1. **Faithful-instantiation route。** 若能在不公开任何HAKE秘密、不重分类σ/c、不改变F或对手能力的前提下，构造完全满足K25 source/α/req的实例，并证明协议查询映射，则可使用existing theorem。当前没有这样的构造；它是待证接口，不是可用结论。
2. **HAKE-specific new lemma route。** 给出仅服务C1的 `Secret-Context Elision Lemma`：允许secret-bearing context，并在严格well-formed记录、编码lift、source泄漏、adaptive-query/oracle mapping和确认视图条件下比较 original/reduced。该lemma不能扩大成general KDF framework，也不能把C1安全作为前提。

基于现有证据，**主工作路线需要 new HAKE-specific KDF/interface lemma；existing theorem只能在其合法子接口上作为组件使用。** 这不是要求立刻发明新安全模型；若lemma必须改变原攻击者、公开秘密或重写KDF，路线应判定失败而不是采用它。

## 5. 新lemma的最低接口

| Interface | Required condition | Current status |
|---|---|---|
| well-formed records | 原合法记录尾项等于σ_KEM；候选保留同一σ | structural fact only |
| encoding lift | canonical、injective、保留必要查询相等关系 | unknown；HAKE拼接编码未正式化 |
| auxiliary leakage | α反映真实可见信息，不能包含k1/k2/k*除非原模型合法泄漏 | blocked by K25 public-context requirement |
| source/query map | honest/dishonest、source position、matching与重复调用映射到req | unknown |
| adaptive/raw RO | 模拟两输入域并界定cross-domain命中事件 | unknown；B6能力也未冻结 |
| output/confirmation | 处理τ3及最终半段Test的联合分布 | unknown；B7 |
| failure branches | BG/KO/QB/QT分别使用实际存活保证 | unknown；不得借X01/X02自动闭合 |

## 6. 结论

接口分析没有证明C1失败，也没有给出直接可用的定理实例。它确定了G1→G2和G2→G3为何阻塞：现有KDF结果不能跨过secret-bearing context和HAKE adaptive protocol view。下一步只有在上述lemma/实例化接口获得审查认可并可形式化时，才有资格进入证明执行阶段。

