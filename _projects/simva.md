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

The module names below match the overall architecture. The main path runs from CLIP features through the **Similarity Volume**, spatial and temporal aggregation, and action prediction. **Action Class Sampling** is a training-time branch that chooses the candidate descriptions used to construct the volume.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/simva.jpeg' | relative_url }}" alt="SimVA architecture with CLIP encoders, Action Class Sampling, Similarity Volume, Spatial Aggregation, Motion-aware Modulation, and Temporal Aggregation." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">The numbered explanations follow the named blocks in this architecture. Action Class Sampling operates during training; the main path scores the candidate actions at inference.</figcaption>
</figure>

### 1. CLIP Vision Encoder & CLIP Text Encoder

The vision encoder produces a feature for each image patch in each video frame, while the text encoder represents the candidate action descriptions. Their shared image–text representation makes it possible to compare a local visual region with an action's meaning. Global video features also provide the coarse similarity signal used by the class sampler.

### 2. Action Class Sampling

This module selects **which action classes the model compares during a training step**. It ranks candidate text descriptions using global video–text similarity, adds noise to support exploration, and selects a subset while retaining the ground-truth class. The reported setting uses 100 candidate classes; it does not restrict training to 100 videos.

The purpose is to learn from plausible alternative actions while maintaining diversity in the comparisons. A deterministic top-k variant performed poorly, motivating the exploration term rather than repeatedly presenting the same high-scoring alternatives. This sampling is used for training; inference evaluates the target candidate descriptions.

### 3. Similarity Volume

For each video patch, the model computes similarity to each candidate action text. The resulting volume has four axes: **time × image height × image width × candidate class**. Each candidate therefore has its own map of supporting evidence across the video.

This is the core **align-then-aggregate** choice: the following modules refine action-specific evidence, rather than compressing all video features into one candidate-independent vector first.

### 4. Spatial Aggregation

Swin-style window attention and shifted windows connect nearby responses within the similarity volume. The output retains the candidate and spatial structure while allowing a patch response to use neighboring evidence.

This helps turn fragmented local matches into a more coherent action-related pattern. It addresses spatial context without discarding the distinction between what supports one candidate action and what supports another.

### 5. Motion-aware Modulation

This branch compares patch features from consecutive frames to produce a motion-related modulation signal. The signal is applied to the spatially aggregated responses, as indicated by the multiplication in the figure.

Its role is to make changes over time available to the action-conditioned representation. Similar objects or poses alone can be ambiguous; the way those features change can distinguish actions such as sitting down and standing up.

### 6. Temporal Aggregation & Prediction

The temporal module uses **Mamba** to aggregate time-ordered responses for each candidate and spatial location. It combines evidence across frames while preserving which action is being evaluated, so a movement can be interpreted as a sequence.

The diagram's **Linear Projection** and **Avg Pooling** produce the final candidate action scores. **Cross-Entropy Loss** supplies the training objective; it is not an additional input required at inference.

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
