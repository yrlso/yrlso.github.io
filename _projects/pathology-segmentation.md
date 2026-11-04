---
layout: "page"
title: "Context-aware pathology segmentation"
description: "Helping a tissue segmentation model interpret both local detail and the surrounding disease context."
importance: 2
category: "research"
status: "Ongoing research"
period: "September 2025–present"
role_short: "Data construction · Model design · Training & evaluation"
stack: "Python · PyTorch · Virchow2 / UNI · OpenCV"
summary: "Pancreatic tissue segmentation developed with biomedical researchers, from expert annotations to model evaluation."
card_result: "Three-class mean IoU: 54.91% → 73.41% (+18.50 percentage points)."
img: "assets/img/pathology-architecture.png"
image_alt: "Frozen pathology encoder with global and local tissue segmentation decoders"
permalink: "/projects/pathology-segmentation/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

A **whole-slide image (WSI)** is a digitized tissue slide that can exceed 20,000 × 20,000 pixels. It is too large to process as one ordinary model input, so analysis relies on smaller image tiles. This preserves local detail but can remove the surroundings needed to interpret a region correctly.

The project distinguishes three types of mouse pancreatic tissue:

| Tissue label | Meaning                                                       |
| ------------ | ------------------------------------------------------------- |
| Acinar       | Normal pancreatic acinar tissue                               |
| PanIN        | Pancreatic intraepithelial neoplasia, a precancerous lesion   |
| PDAC         | Pancreatic ductal adenocarcinoma, a form of pancreatic cancer |

Context changes the label under our experts' annotation protocol: a region that locally resembles PanIN is labeled **PDAC when it lies inside a cancer region**. A small isolated tile can therefore lack the information required for the correct prediction.

The research goal is to combine **fine tissue detail with wider disease context**, supporting segmentation and the collaborators' analysis of tissue composition.

---

## My role & timeline

- **Period:** {{ page.period }} · Ongoing collaborative research.
- **Ownership:** Built the dataset with biomedical researchers; handled preprocessing, model design, training, evaluation, and error analysis.
- **Data constraint:** 18 whole-slide images, making effective use of pretrained representations important.

I translated domain-specific labeling rules into modeling requirements and used recurring errors to guide architectural changes. The Virchow2 / UNI pathology encoder stays **frozen**: its pretrained weights are retained while the downstream prediction model is adapted.

---

## Approach

The architecture separates a shared tissue representation from two complementary prediction paths. The names below match the diagram's **Pathology Foundation Encoder**, **Global Context Decoder**, and **Fine-grained Local Decoder**.

<figure class="figure">
  <img src="{{ '/assets/img/pathology-architecture.png' | relative_url }}" alt="Whole-slide input passes through a frozen Pathology Foundation Encoder to a Global Context Decoder and Fine-grained Local Decoder." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">A shared frozen encoder supplies the two decoders: one interprets wider tissue context, while the other preserves local morphology and boundaries.</figcaption>
</figure>

### 1. WSI Input & Tile Preparation

A whole-slide image is divided into image tiles that the model can process. The pipeline must retain how a local tile relates to its surrounding tissue, because a small crop alone can be insufficient under the expert labeling rules.

This input organization is important for the two decoding paths: both fine local evidence and a wider tissue view need to remain available to the prediction pipeline.

### 2. Pathology Foundation Encoder

Virchow2 / UNI extracts pretrained tissue features. The encoder is **frozen**, so its weights are not updated on the 18-slide dataset; adaptation is concentrated on the downstream model and how contextual information reaches it.

The purpose is to use the foundation model's pretrained representation while working within the limited-data setting. The baseline uses these features with an existing UPerNet single decoder.

### 3. Global Context Decoder

This path interprets wider tissue organization to resolve local–global semantic ambiguity. For example, a PanIN-like region needs information about surrounding cancer to receive the PDAC label required by our annotation protocol.

The global decoder's role is therefore contextual interpretation: it supplies evidence that cannot be recovered reliably from the appearance of one isolated tile.

### 4. Fine-grained Local Decoder

This path preserves local tissue morphology and fine boundaries. Wider context helps determine what a region means, but the segmentation still needs to locate small structures and distinguish neighboring tissue regions precisely.

The local and global paths provide complementary features that are combined for the final segmentation. Their separation makes the need for both contextual interpretation and fine localization explicit.

### 5. Context Expansion Within the Frozen Encoder — Ongoing Extension

Beyond the high-level diagram, I am investigating wider spatial sampling for attention so a fixed number of tokens can represent a larger tissue region. This examines how context can influence the features before decoding, while retaining the pretrained encoder weights.

The motivation comes from persistent failures such as a large PanIN lesion's white interior being predicted as background. Its boundary and surroundings may identify it as part of a lesion even when the local appearance is ambiguous. The complete model's reported gain below does not isolate the contribution of this ongoing encoder extension.

---

## Experiments & results

The metric is **mean intersection over union (mIoU)** across Acinar, PanIN, and PDAC. For each class, IoU measures the overlap between the predicted and annotated regions relative to their combined area; mIoU averages the three class scores.

| Segmentation model                      | Three-class mIoU ↑ |
| --------------------------------------- | -----------------: |
| Foundation encoder + UPerNet (Baseline) |             54.91% |
| Context-aware model (Ours)              |         **73.41%** |
| Absolute gain                           |      **+18.50 pp** |

**How to read the table:** higher overlap is better. The gain is 18.50 percentage points and compares the complete proposed model with the baseline. It does not isolate the contribution of attention sampling, which needs its own controlled comparison.

The broader goal includes **preserving tissue area proportions**. The relative amounts of normal, precancerous, and cancerous tissue matter for the collaborators' workflow, so future evaluation also examines composition rather than only individual pixel labels.

---

## Resources

- **Status:** Ongoing collaborative research; public paper and code are not yet available.
- **Tools:** {{ page.stack }}.
