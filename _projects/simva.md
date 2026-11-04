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

**Open-vocabulary action recognition** means recognizing actions whose class labels were not included in training. At test time, the model compares a video with text descriptions of candidate actions, rather than relying only on a fixed set of learned labels.

This is difficult because similar-looking videos can contain different actions. For example, sitting down and standing up may involve the same person, chair, and room, while the movement determines the answer. A model needs to preserve **where an action happens and how it unfolds**.

Many methods first combine a video's features into one representation, then compare it with candidate action texts. This can discard details before the model knows which action it needs to evaluate. SimVA reverses that order: **align the video with each candidate first, then aggregate the relevant evidence**.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **Ownership:** Research lead and first author, from problem formulation and model design to PyTorch implementation, training, evaluation, and writing.
- **Status:** Manuscript under review at IEEE Transactions on Image Processing (TIP).

I designed the similarity-based representation and its spatial, motion, and temporal components. I also developed the class-sampling strategy, investigated unsuccessful variants, and ran controlled comparisons to test why each design choice mattered.

---

## Approach

- **Preserve candidate-specific evidence.** CLIP compares small image regions, or patches, with each candidate action description. The resulting similarity volume records how strongly each region supports each action at each moment. The same video can therefore preserve different evidence for different candidates.
- **Connect appearance with movement.** Spatial aggregation connects nearby regions, while motion-aware modulation adds changes between consecutive frames. A temporal module then combines this evidence over time. These components help the model interpret an action as a sequence, rather than as an unordered collection of images.
- **Train against informative alternatives.** Class sampling focuses on plausible candidate actions while retaining the ground-truth class. A deterministic top-k strategy performed poorly; adding exploration diversified the alternatives seen during training. The reported setting samples 100 candidate **classes**, not 100 training videos.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/simva.jpeg' | relative_url }}" alt="SimVA aligns video patches and action descriptions before spatial, motion-aware, and temporal aggregation." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Align first, then aggregate: each action candidate retains its own spatial and temporal evidence throughout the model.</figcaption>
</figure>

---

## Experiments & results

The following **zero-shot** results test recognition of action classes without task-specific training on the target dataset. Both methods use Kinetics-400 training, 16 input frames, single-view evaluation, and no weight-space ensembling. BDC-CLIP is the reproduced reference method; **SimVA (Ours)** is the proposed model.

| Target dataset / metric       | BDC-CLIP (Baseline) | SimVA (Ours) |    Gain |
| ----------------------------- | ------------------: | -----------: | ------: |
| HMDB-51 accuracy ↑            |               58.4% |    **62.2%** | +3.8 pp |
| UCF-101 accuracy ↑            |               85.0% |    **86.2%** | +1.2 pp |
| Kinetics-600 Top-1 accuracy ↑ |               75.9% |    **76.5%** | +0.6 pp |

**How to read the table:** higher accuracy is better. A gain of 3.8 percentage points (pp) means 62.2% minus 58.4%; it is not a 3.8% relative increase. Improvement across all three target datasets supports transfer beyond the training action labels.

Controlled HMDB-51 comparisons examined the representation and temporal design separately:

| Comparison                                                                            | Reference variant | SimVA (Ours) |
| ------------------------------------------------------------------------------------- | ----------------: | -----------: |
| Feature aggregation vs. similarity aggregation, with the aggregation structure fixed  |             59.6% |    **62.2%** |
| Transformer vs. Mamba temporal aggregation, with the remaining configuration retained |             60.8% |    **62.2%** |

The broader study covers five datasets and multiple generalization settings: zero-shot, few-shot (a small amount of labeled target data), and base-to-novel transfer (learning known classes while retaining recognition of new ones).

I also examined motion-sensitive subsets using an explicit selection rule: exclude classes that single-frame CLIP already recognizes with at least 60% accuracy. This reduces reliance on appearance-easy examples when investigating the value of temporal evidence.

---

## Resources

- [Paper: Spatio-Temporal Similarity Volume Aggregation for Open-Vocabulary Action Recognition](https://arxiv.org/abs/2605.23288).
- **Authors:** Yerim So, Jiyeong Kim, Jiwon Yoon, Dongbo Min.
- **Tools:** {{ page.stack }}.
