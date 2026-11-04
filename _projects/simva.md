---
layout: "page"
title: "SimVA"
description: "Recognizing unseen actions by preserving the spatial and motion evidence relevant to each candidate action."
importance: 3
category: "research"
status: "First-author manuscript under review at IEEE TIP"
period: "October 2025–August 2026"
role_short: "Research lead · First author · Design, implementation & evaluation"
stack: "Python · PyTorch · CLIP · Swin · Mamba"
summary: "An open-vocabulary video model that compares visual regions with candidate actions before combining evidence over space and time."
card_result: "HMDB-51 zero-shot accuracy: 58.4% → 62.2% (+3.8 percentage points)."
img: "assets/img/publication_preview/simva.jpeg"
image_alt: "SimVA aligns video patches and candidate text before spatial and temporal aggregation"
links: [{ "label": "Paper", "url": "https://arxiv.org/abs/2605.23288" }]
permalink: "/projects/simva/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

Open-vocabulary action recognition identifies actions that were not included in the training labels. A useful model must connect a new action description with the relevant visual evidence in a video.

Many approaches first compress a video into one representation, then compare it with action descriptions. That can lose the different regions or movements needed to distinguish similar actions. SimVA reverses the order: **align with each candidate action first, then combine its evidence**.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **My work:** Research lead and first author; problem formulation, model design, implementation, training, ablations, and writing.
- **Status:** Manuscript under review at IEEE Transactions on Image Processing.

I led the full experimental cycle, including investigating why a seemingly useful class-sampling strategy failed and designing controlled comparisons for the main modeling decisions.

---

## Approach

- **Keep action-specific evidence:** Compare video patches with candidate action texts before aggregation, retaining where and when each action is supported.
- **Connect space and motion:** Combine nearby visual evidence and changes between frames, then aggregate the temporal sequence.
- **Learn from useful alternatives:** Sample plausible candidate actions while preserving exploration, so training is not restricted to the same high-scoring alternatives.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/simva.jpeg' | relative_url }}" alt="SimVA architecture: align patches and candidate actions, then aggregate spatial and temporal evidence." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">One video can retain different evidence for different candidate actions, instead of sharing a single compressed representation.</figcaption>
</figure>

---

## Experiments & results

Zero-shot evaluation after Kinetics-400 training, compared with a reproduced BDC-CLIP baseline using **16 frames, one view, and no weight-space ensembling**:

| Dataset            | Baseline |     SimVA |
| ------------------ | -------: | --------: |
| HMDB-51 accuracy   |    58.4% | **62.2%** |
| UCF-101 accuracy   |    85.0% | **86.2%** |
| Kinetics-600 Top-1 |    75.9% | **76.5%** |

Controlled HMDB-51 experiments also supported the central idea: **similarity aggregation reached 62.2%, compared with 59.6% for feature aggregation** under the same aggregation structure. Replacing the temporal module with a Transformer reached 60.8%.

The broader study evaluated five datasets across zero-shot, few-shot, and base-to-novel settings. A separate motion-sensitive analysis excluded classes already recognized with at least 60% single-frame CLIP accuracy, making the subset-selection rule explicit.

---

## Resources

- [Paper: Spatio-Temporal Similarity Volume Aggregation for Open-Vocabulary Action Recognition](https://arxiv.org/abs/2605.23288).
- **Authors:** Yerim So, Jiyeong Kim, Jiwon Yoon, Dongbo Min.
- **Tools:** {{ page.stack }}.
