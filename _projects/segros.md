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

A generated image should follow more than the main object in a prompt: it should also respect attributes, object counts, and spatial relationships. A unified multimodal model, which handles both image understanding and generation, needs supervision that makes these details matter during training.

SeGroS focuses on **the relevance of visual supervision**. Instead of providing all image patches or choosing reconstruction regions at random, it selects visual hints and learning targets that correspond to the prompt's meaning.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **My work:** Proposed combining text–text and image–text affinity, co-designed and implemented the framework, directly post-trained a Qwen-based model, and ran analysis experiments.
- **Outcome:** ECCV 2026 accepted paper; second author.

My contribution connected a token-selection idea to PyTorch training code and controlled evaluation of its effect on image–text alignment.

---

## Approach

- **Identify meaningful text:** Combine relationships within the prompt with visual grounding, so selection reflects language context as well as prominent objects.
- **Focus visual supervision:** Use the selected semantics to choose relevant image hints and reconstruction targets.
- **Keep generation text-driven:** Visual hints guide training; text-to-image inference still uses a text prompt alone.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/segros.jpeg' | relative_url }}" alt="SeGroS identifies semantically relevant image regions for visual hints and reconstruction supervision." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">The framework aligns what the model sees during training with the prompt details it should learn to generate.</figcaption>
</figure>

---

## Experiments & results

Final reported comparison on **Harmon-1.5B with BLIP3o-60k**, using scores on a 0–100 scale:

| Benchmark |  Reca |    SeGroS |
| --------- | ----: | --------: |
| GenEval   | 85.20 | **88.66** |
| DPGBench  | 86.50 | **86.58** |
| CompBench | 87.20 | **88.08** |

The GenEval gain is **3.46 percentage points**. In a separate 0.5B ablation, combining the two affinity signals improved DPGBench from 84.0 without filtering to 85.4.

An initial top-30% visual-hint experiment used approximately **3.3× fewer training hint tokens** and improved GenEval from 78.7 to 79.2. This is a separate experiment, rather than an inference-speed claim or the setting of the final table.

---

## Resources

- [Paper: Enhancing Alignment for Unified Multimodal Models via Semantically-Grounded Supervision](https://arxiv.org/abs/2603.19807).
- **Authors:** Jiyeong Kim, Yerim So, Hyesong Choi, Uiwon Hwang, Dongbo Min.
- **Tools:** {{ page.stack }}.
