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

- **Start from a reproducible comparison.** The baseline combines a pathology foundation encoder with an existing UPerNet single decoder. The encoder extracts tissue features; the decoder converts those features into a label for each image location.
- **Give context and detail complementary paths.** A global decoder interprets wider tissue organization, while a local decoder preserves fine morphology and boundaries. Their features are combined so a local prediction can use its surroundings.
- **Use failures to identify missing information.** Large PanIN interiors can look white in a small tile and be mistaken for background. Their lesion boundary and surrounding tissue provide evidence that is absent locally, motivating a wider view.
- **Investigate context within the encoder.** Wider spatial sampling explores whether a fixed number of visual tokens can represent a larger region while the foundation model remains frozen. This is part of the ongoing investigation of how context reaches the decoders.

<figure class="figure">
  <img src="{{ '/assets/img/pathology-architecture.png' | relative_url }}" alt="A shared frozen pathology encoder supplies global context and fine-grained local decoders." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">The two decoding paths address different needs: understanding the surrounding tissue and preserving local structures.</figcaption>
</figure>

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
