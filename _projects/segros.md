---
layout: "page"
title: "SeGroS"
description: "Improving text-to-image alignment through semantically relevant supervision during multimodal model post-training."
importance: 4
category: "research"
status: "ECCV 2026 · Second author"
period: "September 2025–March 2026"
role_short: "Second author · Method co-design · Model post-training & analysis"
stack: "Python · PyTorch · Qwen-based unified multimodal models"
summary: "Post-training a unified multimodal model to follow object, attribute, count, and spatial details in a text prompt."
card_result: "ECCV 2026 · GenEval: 85.20 → 88.66 in the reported 1.5B-model comparison."
img: "assets/img/publication_preview/segros.jpeg"
image_alt: "SeGroS semantic grounding and image generation supervision framework"
links: [{ "label": "Paper", "url": "https://arxiv.org/abs/2603.19807" }]
permalink: "/projects/segros/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

A **unified multimodal model** handles both image understanding and image generation. For generation, recognizing a prompt's main object is only part of the task: an image should also follow its attributes, object counts, and spatial relationships.

Consider a prompt describing two red cups beside one blue plate. Generating recognizable cups and a plate is insufficient if the colors, counts, or placement are wrong. The training signal needs to emphasize the details that carry the prompt's meaning.

SeGroS addresses this through **semantically grounded supervision during post-training**—additional training of an existing model. Instead of supplying every image patch as a hint or selecting reconstruction regions randomly, it focuses hints and learning targets on prompt-relevant content.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **Ownership:** Proposed combining text–text and image–text affinity; co-designed and implemented the framework; directly post-trained a Qwen-based unified multimodal model.
- **Evaluation:** Ran benchmark comparisons and analysis experiments to assess the effect of the supervision design.
- **Outcome:** ECCV 2026 accepted paper; second author.

My contribution connected a method idea to training code and then to controlled experiments, including comparisons of the two affinity signals alone and in combination.

---

## Approach

- **Identify which words matter.** Relationships among the text tokens help capture the prompt's language context. Image–text correspondence adds a grounding signal: which words connect to visible image regions? Combining the two makes selection consider both language and visual evidence.
- **Turn meaning into spatial supervision.** The selected text guides a map of relevant image regions. This map determines which visual hints the model receives and which important regions it learns to reconstruct, keeping conditioning and supervision focused on the same content.
- **Preserve a simple generation interface.** Visual hints are part of training. At text-to-image inference, the user still provides a text prompt alone; no reference image is required by this training framework.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/segros.jpeg' | relative_url }}" alt="SeGroS combines language relevance and visual grounding to select hints and reconstruction targets." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">The supervision map links prompt meaning to the image regions used for hints and reconstruction during post-training.</figcaption>
</figure>

---

## Experiments & results

The main comparison uses **Harmon-1.5B with BLIP3o-60k**. Reca is the reference supervision method; **SeGroS (Ours)** is the proposed framework. The benchmarks evaluate how faithfully generated images follow text requirements.

| Benchmark ↑ | Reca (Baseline) | SeGroS (Ours) |  Gain |
| ----------- | --------------: | ------------: | ----: |
| GenEval     |           85.20 |     **88.66** | +3.46 |
| DPGBench    |           86.50 |     **86.58** | +0.08 |
| CompBench   |           87.20 |     **88.08** | +0.88 |

**How to read the table:** higher is better; scores and gains are on the reported 0–100 scale. The strongest gain in this comparison is on GenEval, rather than an equally large improvement on every benchmark.

A separate **Harmon-0.5B ablation** tests the text-selection signals:

| Text-selection criterion   | GenEval ↑ | DPGBench ↑ |
| -------------------------- | --------: | ---------: |
| No filtering (Baseline)    |      79.2 |       84.0 |
| Text–text affinity only    |      79.8 |       84.8 |
| Image–text affinity only   |      81.5 |       84.8 |
| Combined affinities (Ours) |  **81.5** |   **85.4** |

The combined criterion preserves the GenEval score of image–text filtering and further improves DPGBench, helping explain the value of combining the signals.

An initial top-30% visual-hint experiment used approximately **3.3× fewer training hint tokens** while improving GenEval from 78.7 to 79.2. This smaller-model experiment concerns training supervision; it is separate from the final 1.5B-model table and does not measure inference speed.

---

## Resources

- [Paper: Enhancing Alignment for Unified Multimodal Models via Semantically-Grounded Supervision](https://arxiv.org/abs/2603.19807).
- **Authors:** Jiyeong Kim, Yerim So, Hyesong Choi, Uiwon Hwang, Dongbo Min.
- **Tools:** {{ page.stack }}.
