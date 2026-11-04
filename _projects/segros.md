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

The overall framework has two connected parts: the right-hand **Semantically-Grounded Supervision Map** chooses relevant regions, and the left-hand generation framework uses that map to construct training inputs. The module names below follow those labels.

<figure class="figure">
  <img src="{{ '/assets/img/publication_preview/segros.jpeg' | relative_url }}" alt="SeGroS overall framework and supervision map, including text token filtering, visual grounding, visual hints, corrupted input, and the unified transformer." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Right: identify semantically relevant image regions. Left: use the resulting SeGroS Map to form Visual Hint and Corrupted Input for post-training.</figcaption>
</figure>

### 1. Text Tokenizer & Vision Encoder

The text tokenizer provides representations of the prompt's words, while the vision encoder provides representations of image regions. These are the inputs used to estimate relationships within the text and correspondence between text and image.

The image representation supplies visual grounding: it helps identify which regions support the objects, attributes, and relationships described by the prompt.

### 2. Discriminative Text Token Filtering

This module chooses the text tokens that will guide supervision. **Text–text intra-modal affinity** provides a language-context signal, and **image–text inter-modal affinity** connects words to visual evidence. The scores are normalized and combined before token selection.

The purpose is to avoid relying only on visually prominent objects when deciding which parts of the prompt matter. Combining these two affinity signals was my contribution to the selection design; the ablation below compares the signals separately and together.

### 3. Visual Grounding Map

Affinities between the selected text tokens and image patches are aggregated into a spatial map. Each patch receives a relevance score indicating how strongly it corresponds to the selected semantic content.

This converts the text-selection result into a decision about **where in the image supervision should focus**. The resulting SeGroS Map is shared by the two training-input branches, keeping their notion of relevance consistent.

### 4. Visual Hint & Corrupted Input

The **Visual Hint** branch supplies highly relevant image patches as conditioning information. The **Corrupted Input** branch masks semantically important regions for reconstruction while retaining less relevant regions as context.

These inputs have complementary roles: the hints provide targeted visual evidence, and the corrupted image defines content the model must learn to reconstruct. Both are selected using semantic relevance rather than spending the training signal uniformly on every image region.

### 5. Unified Auto-Regressive Transformer

The unified model receives the prompt and the map-guided image inputs during post-training. Reconstruction supervision emphasizes the masked content, connecting the generation objective to the prompt's meaning.

I implemented and ran post-training for a Qwen-based unified multimodal model. **At text-to-image inference, the input is text only**: Visual Hint and Corrupted Input describe the training framework, not extra reference images a user must provide to generate an image.

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
