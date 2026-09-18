# M2/M3 原始资料与版本锁定

获取/核验日期：2026-09-18。所有 PDF 已用 `pdftotext` 成功解析并核对首页标题；关键游戏/公式另经页面渲染核对。本目录保留研究来源，**不是中途文件**。正文页码按印刷页；CK01 转换 PDF 的文件页码 = 印刷页码 + 2。固定版本优先于在线落地页的最新状态。

| ID / BibTeX key | 本地来源 | 来源地址与本次版本 | 重点核查位置 |
|---|---|---|---|
| H26 / ClermontHenrich2026 | [2026-1231.pdf](../2026-1231.pdf) | [ePrint 2026/1231](https://eprint.iacr.org/2026/1231)；沿用原仓库 PDF，不覆盖下载 | §2.4–2.6；Fig.3；§3.1；Lemma1–3；Thm.1–2 |
| C01 / CanettiKrawczyk2001 | [PS 原件](2001-040-ck01.ps)、[阅读副本 PDF](2001-040-ck01.pdf) | [ePrint 2001/040 PS](https://eprint.iacr.org/2001/040.ps)；用系统 TeXLive `ps2pdf` 转换。PDF 是阅读副本，非作者原始 PDF；EUROCRYPT 2001 的全文入口 | §3.2–3.4；§4.1–4.2；印刷 pp11–15 的完成/暴露/Test |
| B23 / BoydKockMillerjord2023 | [PDF](2023-167-boyd.pdf) | [ePrint 2023/167](https://eprint.iacr.org/2023/167)；首页声明 ACISP 2023 full version；落地页修订日期 2023-04-22 | §2.4 pp10–12；Thm.2–4；§4.1/Fig.8 pp20–22 |
| K25 / BackendalEtAl2025 | [2025-04-10 PDF](2025-657-kdf-20250410.pdf) | [固定历史 PDF](https://eprint.iacr.org/archive/2025/657/1744275041.pdf)；首页日期 2025-04-10，EUROCRYPT 2025 full version | Def.1 p8；Thm.9 p16；Lemma23 p37；与 K26 同名结果逐项对照 |
| K26 / BackendalEtAl2026revision | [2026-06-16 PDF](2025-657-kdf.pdf) | [ePrint 2025/657](https://eprint.iacr.org/2025/657)；首页 2026-06-16；落地页称会议版的 major revision | Def.1–4 pp8–10；Fig.3/Table1 pp11–12；Thm.9 p17；§7.2/Thm.17 pp30–31；§8；Lemma23 p38 |
| D24 / CremersDaxMedinger2024 | [PDF](2023-1933-binding.pdf) | [ePrint 2023/1933](https://eprint.iacr.org/2023/1933) 下载正文首页为 **v1.1.3 / 2024-11-25**，声明短版 ACM CCS 2024；落地页另显示 2025-11-13 修订和 Preprint。版本元数据不一致，以本地哈希及正文版本为准，不称它是 2025 最新正文 | Def.4.1/Fig.5–6 pp7–8；§4.5–4.8；§5–6/Table2；Appendix C 的 HON/LEAK 抽象限制 |
| X24 / BarbosaEtAl2024 | [PDF](2024-039-xwing.pdf) | [ePrint 2024/039](https://eprint.iacr.org/2024/039)；正文为 IACR Communications in Cryptology 1(1)，22页；[DOI](https://doi.org/10.62056/a3qj89n4e)；落地页末次修订 2025-03-19 | §3；Def.7及Thm.1 p9；Thm.2/§6.2 |
| S26 / ConnollyEtAl2025Starfighters | [PDF](2025-1397-starfighters.pdf) | [ePrint 2025/1397](https://eprint.iacr.org/2025/1397)；正文未标可识别日期；落地页末次修订 2026-07-10，标注 IEEE S&P 2026 major revision；[DOI](https://doi.org/10.1109/SP63933.2026.00143) | Def.8/Fig.3 pp9–10；Fig.7 p14；Thm.14 p16；Thm.16–22及附录 binding 定义 |
| I11 / ConnollyBarnesGrubbs2026draft11 | [draft-11 TXT](draft-irtf-cfrg-hybrid-kems-11.txt) | [IETF 固定版本](https://www.ietf.org/archive/id/draft-irtf-cfrg-hybrid-kems-11.txt)，2026-05-07，失效日 2026-11-08；按路线图锁定版本11，**不称最新版或 RFC** | §5.3–5.6；§6.1.2/6.1.4；§6.2–6.4；§8 |

K25 和 K26 是同一工作的两个版本，不算两篇独立查新成果。正文关于公开 context 和预测余项的发现已在两版复核。未把它们的整篇内容判为等价，也未断言 HAKE 作者实际使用了哪个下载时刻的版本。

## SHA-256 清单

```text
E1F894E1F2C0973F230DE343B2133AE6C399621487EF6596C15FBF2507E58A62  ../2026-1231.pdf
8FFCB773DC7C4B0DB3C9DE1D58394E0AE6E5DA32BF41E908DFAFE795A0561D3B  2001-040-ck01.ps
D694E9D6B08B4FD01FE795E7A079D79748C0F2E3264260D68AECB5EF3E816C9C  2001-040-ck01.pdf
8AB0503735B2394D905264371A822F4F76781846EB3F3724291A4D726B749A13  2023-167-boyd.pdf
D8A4D2B4C9E7306D24F07AD77CA265241F22985D54FB2F5B1A1AA01EF3213A0C  2023-1933-binding.pdf
773D00ABEFD9E88552C8D5F4F04AE95597FF4844B56964D99BE76BE45632280D  2024-039-xwing.pdf
0AC612FD76FC7860C4A5C759B204892414F055803298492CA6B1AC2A3DC9F007  2025-1397-starfighters.pdf
C46AB15E7C311348F10F67D37CD5991681F3877D369BB92282F224D95F1CBBC6  2025-657-kdf-20250410.pdf
8C70734C01F11E54F7617F55D4FFE0C2DF9D9F12586230D0B2E2CEEAE01EAF07  2025-657-kdf.pdf
84D46CF5C557994BCC3EB2E7CB0171D02C9BE7436DEBF934D7742C2914BF0328  draft-irtf-cfrg-hybrid-kems-11.txt
```

核查局限：本次为路线图指定近邻文献的定向查新，不是穷尽文献综述；不复制第三方论文的攻击代码，不执行协议攻击或自动漏洞工作流。来源版权归作者/出版方；分发时遵守各来源许可。作者信息不确定之处不补猜卷页或 DOI，BibTeX 使用可核验的 ePrint 条目并另注正式发表关系。
