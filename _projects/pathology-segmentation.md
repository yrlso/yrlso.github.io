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

A digitized tissue slide can exceed **20,000 × 20,000 pixels**, so it must be divided into small tiles for analysis. A tile preserves fine tissue detail but can lose the surroundings needed to interpret it.

This matters for distinguishing normal tissue (Acinar), precancerous lesions (PanIN), and pancreatic cancer (PDAC). Under our expert annotation protocol, tissue that locally resembles PanIN is labeled PDAC when it lies within a cancer region. The model therefore needs **both local appearance and wider tissue context**.

---

## My role & timeline

- **Period:** {{ page.period }} · Ongoing collaborative research.
- **My work:** Dataset construction with biomedical researchers, preprocessing, architecture design, training, and evaluation.
- **Technical setting:** 18 whole-slide images; a frozen Virchow2 / UNI pathology encoder.

I translated the experts' annotation requirements and recurring model errors into a concrete design goal: let each local prediction use information from a wider tissue region.

---

## Approach

- **Establish a baseline:** Use a pretrained pathology encoder with a UPerNet single decoder.
- **Combine two views:** A global decoder interprets tissue context, while a local decoder preserves fine morphology and boundaries.
- **Investigate missing context:** Explore wider spatial sampling within the frozen encoder, guided by errors such as large lesion interiors being mistaken for background.

<figure class="figure">
  <img src="{{ '/assets/img/pathology-architecture.png' | relative_url }}" alt="A frozen pathology encoder supplies complementary global and local decoders." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Separate global and local paths help a small tissue region be interpreted in its wider context.</figcaption>
</figure>

---

## Experiments & results

| Model                                 | Three-class mean IoU ↑ |
| ------------------------------------- | ---------------------: |
| Foundation encoder + UPerNet baseline |                 54.91% |
| Current proposed model                |             **73.41%** |

The **18.50 percentage-point improvement** compares the complete proposed model with the baseline. It is not an isolated measurement of the attention-sampling change.

The next evaluation priority is whether the model also preserves the relative areas of normal, precancerous, and cancerous tissue—an important part of the collaborators' analysis workflow.

---

## Resources

- **Status:** Ongoing collaborative research; public paper and code are not yet available.
- **Tools:** {{ page.stack }}.
