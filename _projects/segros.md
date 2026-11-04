---
layout: page
title: SeGroS
description: Semantically grounded supervision for image–text alignment in unified multimodal models.
permalink: /projects/segros/
img: assets/img/publication_preview/segros.jpeg
importance: 4
category: research
status: ECCV 2026 · Second author
period: September 2025–March 2026
role: Affinity-combination idea, framework co-design and implementation, direct model post-training, and analysis experiments
role_short: Second author · Method co-design · Model post-training
stack: Python · PyTorch · Qwen-based unified multimodal models
summary: Selecting text-relevant visual hints and reconstruction targets to improve how a unified multimodal model follows object, attribute, and spatial details in a prompt.
card_result: GenEval 85.20% → 88.66% in the reported 1.5B-model setting
tags: [ECCV 2026, Unified multimodal models, Image–text alignment]
highlights:
  - value: +3.46 pp
    label: GenEval vs. Reca in the reported final comparison
  - value: ~3.3× fewer
    label: Visual hint tokens in the initial top-30% experiment
  - value: ECCV 2026
    label: Accepted paper · Second author
links:
  - label: Read the paper
    url: https://arxiv.org/abs/2603.19807
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

A unified multimodal model learns both image understanding and image generation. For text-to-image generation, recognizing the main object in a prompt is only part of the task: the generated image should also follow attributes, object counts, and spatial relationships.

We studied the supervision used during post-training. **Text-only conditioning can leave visual details underspecified**, while providing the entire image as a visual hint introduces information unrelated to the prompt. Randomly masking image regions can also spend reconstruction effort on background details rather than the content that carries the prompt's meaning.

The design question was therefore twofold: **which visual information should be provided as a hint, and which regions should the model be trained to reconstruct?**

## My contribution

I proposed combining **text–text affinity and image–text affinity** to select relevant text tokens, and co-designed and implemented the framework. I wrote PyTorch training code, directly post-trained a Qwen-based unified multimodal model, and performed evaluation and ablation analysis.

My analysis included GenEval, DPGBench, and CompBench, as well as controlled comparisons of token-selection criteria. I am the second author of the ECCV 2026 paper.

## Approach

### Start with a selective visual-hint experiment

An initial experiment provided only the top **30% of image patches** as hints, selected by their relevance to the text. It used approximately **3.3 times fewer hint tokens** than the full-image condition and improved GenEval from **78.7 to 79.2**.

This was evidence that more visual conditioning was not automatically better. However, selecting visually prominent objects alone did not fully capture the prompt's counts or relationships. We therefore refined how text relevance was computed.

The token reduction above concerns **training-time visual hints** in this initial experiment. It is a different comparison from the final 1.5B-model benchmark below.

### Combine language relevance with visual grounding

I proposed using two complementary signals:

1. **Text intra-modal affinity:** relationships among normalized text embeddings provide a language-side importance signal.
2. **Image–text inter-modal affinity:** correspondence between text and image patches provides a visual grounding signal.

We normalize the scores with Min-Max normalization and combine them before selecting text tokens. This lets the selection reflect language context as well as visually salient content.

### Construct a grounding map

Affinities from the selected text tokens to image patches are aggregated into a grounding map. The map identifies image regions that correspond to the selected semantic content.

This is the shared basis for deciding which patches become visual hints and which regions become reconstruction targets. The objective is to make conditioning and supervision agree about what matters in the prompt.

<figure class="figure">
<img src="{{ '/assets/img/publication_preview/segros.jpeg' | relative_url }}" alt="Overview of SeGroS and its semantically grounded supervision for unified multimodal models." loading="lazy" class="img-fluid rounded">
<figcaption class="caption">SeGroS uses semantic relevance to structure visual hints and reconstruction supervision during post-training.</figcaption>
</figure>

### Align the reconstruction objective with the prompt

Highly relevant patches provide explicit visual hints. For reconstruction, semantically important regions are masked while less relevant regions remain available as context. The model learns to reconstruct the important content using the text and hints.

Training uses the reconstruction loss at masked positions, with an image-to-text objective also considered to retain understanding ability. The collaborative study used MidjourneyV6 and BLIP3o-60k generation data and LLaVA-Instruct-150K understanding data.

**At text-to-image inference, the input is text only.** Visual hints belong to the training framework rather than an additional required user input at generation time.

## Experiments and results

### Isolate the token-selection criteria

On Harmon-0.5B, I analyzed the individual and combined affinity criteria:

| Text filtering                       |  GenEval | DPGBench |
| ------------------------------------ | -------: | -------: |
| No filtering                         |     79.2 |     84.0 |
| Text intra-modal affinity only       |     79.8 |     84.8 |
| Image–text inter-modal affinity only |     81.5 |     84.8 |
| Combined affinities                  | **81.5** | **85.4** |

The combined criterion retained the GenEval result of image–text filtering while improving DPGBench. This comparison helps distinguish the effect of the proposed affinity combination from other framework changes.

For the complete framework on Harmon-0.5B, GenEval count accuracy improved from **59.4% to 65.3%**, and position accuracy from **58.5% to 66.0%**, relative to Reca.

### Evaluate the final reported configuration

The following comparison uses **Harmon-1.5B with BLIP3o-60k**:

| Metric    |  Reca |    SeGroS | Change |
| --------- | ----: | --------: | -----: |
| GenEval   | 85.20 | **88.66** |  +3.46 |
| DPGBench  | 86.50 | **86.58** |  +0.08 |
| CompBench | 87.20 | **88.08** |  +0.88 |

Scores are on the reported 0–100 scale. The GenEval improvement is **3.46 percentage points**, not a relative percentage increase. These final-model results should be read separately from the smaller-model ablations and the initial token-reduction experiment.

## What I learned

The amount of supervision and the relevance of supervision are different design choices. A smaller set of semantically useful hints can be more effective than a larger set containing unrelated information.

I also gained direct experience connecting a method idea to training code and then separating its effects through multiple evaluation views: overall benchmark scores, individual semantic categories, and component ablations.

## Resources

- [Enhancing Alignment for Unified Multimodal Models via Semantically-Grounded Supervision](https://arxiv.org/abs/2603.19807)
- **Authors:** Jiyeong Kim, Yerim So, Hyesong Choi, Uiwon Hwang, Dongbo Min.
- **Venue:** European Conference on Computer Vision (ECCV), 2026.

[← Explore all projects]({{ '/projects/' | relative_url }})
