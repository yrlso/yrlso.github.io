---
layout: page
title: SimVA
description: Aligning video patches with candidate action texts before aggregating spatial and temporal evidence.
permalink: /projects/simva/
img: assets/img/publication_preview/simva.jpeg
importance: 3
category: research
status: First-author manuscript under review at IEEE TIP
period: October 2025–August 2026
role: Research lead, from problem definition through design, implementation, training, and evaluation
role_short: Research lead · First author · End-to-end experimentation
stack: Python · PyTorch · CLIP · Swin · Mamba
summary: A class-conditioned video understanding model that preserves the spatial and temporal evidence relevant to each candidate action, instead of compressing the video into one shared representation first.
card_result: HMDB-51 zero-shot accuracy 58.4% → 62.2%
tags: [Open-vocabulary recognition, Error analysis, Controlled ablations]
highlights:
  - value: +3.8 pp
    label: HMDB-51 zero-shot accuracy vs. reproduced baseline
  - value: 5
    label: Action recognition datasets used in evaluation
  - value: First author
    label: Research design and implementation lead
links:
  - label: Read the preprint
    url: https://arxiv.org/abs/2605.23288
---

[← All projects]({{ '/projects/' | relative_url }})

- **My role:** {{ page.role }}
  {% if page.period %}- **Period:** {{ page.period }}
  {% endif %}- **Status:** {{ page.status }}
- **Tools:** {{ page.stack }}

{{ page.summary }}

{% if page.highlights %}{% for metric in page.highlights %}- **{{ metric.value }}** — {{ metric.label }}
{% endfor %}{% endif %}

{% if page.links %}{% for link in page.links %}[{{ link.label }}]({{ link.url }}){% unless forloop.last %} · {% endunless %}{% endfor %}{% endif %}

---

[Problem](#problem-and-constraints) · [My contribution](#my-contribution) · [Approach](#approach) · [Results](#experiments-and-results) · [Resources](#resources)

## Problem and constraints

**Open-vocabulary action recognition** identifies actions that may not have appeared in the training labels by comparing a video with text descriptions of candidate actions. A pretrained image–text model such as CLIP provides a useful starting representation, but action recognition also requires information about where a cue appears and how it changes over time.

Many approaches first aggregate video features into a shared representation and then compare that representation with candidate action texts. I questioned whether this **aggregate-then-align** order loses useful evidence. Two actions can contain similar objects while depending on different spatial regions or motion patterns. A candidate-independent representation has to compress those differences before it knows which action is being evaluated.

The research question was: **can preserving candidate-specific evidence throughout spatial and temporal aggregation improve recognition of unseen actions?**

## My contribution

I led the project from problem formulation through model design, implementation, training, comparative experiments, and result analysis. I implemented the similarity-volume formulation, spatial and temporal aggregation, motion-aware modulation, and training-time class sampling.

I also designed controlled comparisons to test the rationale for the representation and aggregation choices, examined a failure of deterministic candidate sampling, and evaluated the model across multiple generalization protocols. I am the first author of the manuscript.

## Approach

### Align first, then aggregate

CLIP extracts patch embeddings from each video frame and text embeddings for the candidate actions. I compute the cosine similarity between every patch and every candidate description before aggregation.

This produces a **spatio-temporal similarity volume** with dimensions corresponding to time, image height, image width, and candidate class. Keeping the class dimension allows the same video to retain different patterns of evidence for different candidate actions.

<figure class="figure">
<img src="{{ '/assets/img/publication_preview/simva.jpeg' | relative_url }}" alt="Overview of SimVA, from CLIP patch and text embeddings through the similarity volume and spatial and temporal aggregation." loading="lazy" class="img-fluid rounded">
<figcaption class="caption">SimVA aligns video patches with candidate texts before aggregating the resulting spatial and temporal similarity patterns.</figcaption>
</figure>

### Aggregate spatially related evidence

Patch-level responses can be fragmented. The spatial aggregation module uses **Swin-style window attention and shifted windows** to connect neighboring responses while preserving candidate conditioning. This lets a local similarity response be interpreted in relation to nearby patches.

### Supply explicit motion information

Appearance similarity alone can be insufficient for actions involving similar objects. The motion-aware module uses consecutive-frame patch features to estimate changes and modulate the spatially aggregated representation. It supplies dynamic information to the similarity-space representation rather than assuming that static alignment already explains the action.

### Model the temporal sequence

The temporal module processes candidate- and location-specific responses as time-ordered sequences using **Mamba**. Its selective state updates provide a mechanism for accumulating useful evidence over time. The temporal outputs are then used to produce candidate action scores.

### Train with informative but diverse candidates

Training against every class is not necessarily the most useful way to form each comparison. The class sampler scores candidates using global video–text similarity and selects a subset, always retaining the ground-truth class.

A deterministic top-k version performed poorly. I investigated the possibility that repeatedly choosing the same high-scoring candidates restricts the comparisons seen during training, and introduced noise into the scores to support **exploration**. The resulting sampler combines attention to plausible alternatives with diversity in which candidates are selected.

I compared 50, 100, and 200 sampled classes and used 100 in the reported setup. This number is the count of candidate action classes sampled during training, not the number of training images or videos.

## Experiments and results

### Generalization across datasets and protocols

After Kinetics-400 training, evaluation covered **HMDB-51, UCF-101, Kinetics-600, Something-Something V2, and Kinetics-400**, using the applicable zero-shot, few-shot, and base-to-novel protocols. These settings test different kinds of transfer rather than treating a single in-distribution score as sufficient evidence.

The following zero-shot comparison uses a reproduced BDC-CLIP baseline with **16 frames, single-view evaluation, and no weight-space ensembling**.

| Dataset / metric   | BDC-CLIP reproduced |     SimVA |  Change |
| ------------------ | ------------------: | --------: | ------: |
| HMDB-51 accuracy   |               58.4% | **62.2%** | +3.8 pp |
| UCF-101 accuracy   |               85.0% | **86.2%** | +1.2 pp |
| Kinetics-600 Top-1 |               75.9% | **76.5%** | +0.6 pp |

### Test the representation, not only the final model

I kept the aggregation structure fixed and changed the input representation. On HMDB-51, **feature aggregation reached 59.6%**, while **similarity aggregation reached 62.2%**. This isolates the value of the alignment order more directly than comparing unrelated model architectures.

I also replaced the temporal module with a Transformer while retaining the rest of the configuration. That variant reached **60.8%**, compared with 62.2% for the Mamba configuration. These comparisons supported the representation and temporal-modeling choices separately.

### Examine appearance-confusable actions

To probe motion-sensitive behavior, I constructed subsets after excluding classes with at least 60% single-frame CLIP accuracy. This operational criterion reduces reliance on appearance-easy classes; it is not a guarantee that every remaining class requires only motion.

- **HMDB-51:** catch, throw, sit, stand, run, walk, clap, wave, flic flac, somersault.
- **UCF-101:** Boxing Punching Bag, Boxing Speed Bag, Breast Stroke, Front Crawl, Cricket Bowling, Cricket Shot, Handstand Pushups, Handstand Walking.

The purpose of this analysis was to examine actions with less decisive single-frame appearance evidence and make the selection rule explicit.

## What I learned

Changing the order of operations can be as important as adding a larger model. Aligning before aggregation made the information required by each candidate available to the aggregation process.

The sampler experiment also reinforced the value of diagnosing a failed design. Selecting apparently relevant candidates was not enough; the diversity of training comparisons mattered. Controlled alternatives and explicit evaluation settings made those conclusions more defensible.

## Resources

- [Spatio-Temporal Similarity Volume Aggregation for Open-Vocabulary Action Recognition](https://arxiv.org/abs/2605.23288)
- **Authors:** Yerim So, Jiyeong Kim, Jiwon Yoon, Dongbo Min.
- **Status:** arXiv preprint; manuscript under review at IEEE Transactions on Image Processing.

[← Explore all projects]({{ '/projects/' | relative_url }})
