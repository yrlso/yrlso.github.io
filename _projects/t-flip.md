---
layout: "page"
title: "T-FLIP"
description: "Transferring a large model’s attention patterns to a compact face anti-spoofing model."
importance: 6
category: "research"
status: "Undergraduate capstone · Joint first author"
period: "March–December 2024"
role_short: "Joint first author · Attention analysis · Model compression"
stack: "Python · PyTorch · CLIP · FLIP-MCL · ViT-Tiny"
summary: "Attention-based knowledge distillation that reduces inference cost while improving a small model’s cross-domain spoof detection."
card_result: "69.2% fewer parameters · 91.8% fewer MACs · 2.5× throughput vs. the teacher."
img: "assets/img/t-flip-architecture.png"
image_alt: "Teacher and student image and text encoders with layer-wise attention alignment"
links: [{ "label": "Code", "url": "https://github.com/jiwonpark0065/T-FLIP" }]
permalink: "/projects/t-flip/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

**Face anti-spoofing** distinguishes a live face from an attack, such as a printed photograph or replayed video. A useful model should recognize spoofing cues even when test images come from cameras or conditions different from those used for training.

Large models can provide strong representations but require more computation. T-FLIP investigates whether a compact model can retain useful cues by learning **where the larger model attends**, reducing inference cost without relying only on a smaller architecture.

This is **knowledge distillation**: a larger teacher guides a smaller student during training. The research question is which information should be transferred for the student's task.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **Ownership:** Visualized and analyzed teacher/student attention, proposed attention-weight alignment, and co-developed the method and experiments.
- **Recognition:** Joint first author; Ewha Computer Science Graduation Project Excellence Award (2024).

I found that a feature-distilled student's early attention resembled the teacher's, while deeper layers did not consistently preserve attention to spoofing cues such as paper texture. That analysis motivated supervision across the attention hierarchy, beyond matching a final feature vector.

---

## Approach

- **Use a compact student.** The CLIP-based FLIP-MCL model acts as the teacher, and a ViT-Tiny-based model acts as the student. The teacher supplies training guidance; the compact student is the model whose inference cost is measured.
- **Transfer attention across layers.** Align corresponding attention weights with a mean squared error objective. This encourages the student to preserve how the teacher distributes attention over the image, including deeper layers where the analysis found a mismatch.
- **Compare alternative transfer signals.** Evaluate no distillation, feature-based distillation, relation-based distillation, and the proposed attention-based method under the same student setting. This tests the supervision choice rather than attributing every change to model size.

<figure class="figure">
  <img src="{{ '/assets/img/t-flip-architecture.png' | relative_url }}" alt="T-FLIP transfers layer-wise attention from teacher to student using an MSE loss." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Dashed connections indicate attention supervision between corresponding teacher and student layers during training.</figcaption>
</figure>

---

## Experiments & results

The study evaluates **cross-domain generalization**: train on three datasets and test on the remaining one, repeated across MSU-MFSD, CASIA-MFSD, Idiap Replay Attack, and OULU-NPU. This asks whether the model transfers beyond its training data source.

| Student training method              | Mean HTER ↓ |
| ------------------------------------ | ----------: |
| No distillation (Baseline)           |      22.29% |
| Feature-based distillation           |      18.64% |
| Relation-based distillation          |      20.63% |
| T-FLIP attention distillation (Ours) |  **14.77%** |

**How to read the table:** HTER is an error measure combining false acceptance and false rejection; lower is better. The mean is across the four cross-domain settings. T-FLIP reduces mean HTER by **7.52 percentage points** relative to the student without distillation.

Efficiency is a separate comparison **against the larger teacher**:

| Resource / performance measure          | T-FLIP student vs. teacher |
| --------------------------------------- | -------------------------: |
| Parameter count ↓                       |            **69.2% fewer** |
| Multiply–accumulate operations (MACs) ↓ |            **91.8% fewer** |
| Measured inference throughput ↑         |                   **2.5×** |

Parameters describe model size, MACs describe computational work, and throughput measures processing speed. Reporting all three separates theoretical reduction from measured inference behavior.

---

## Resources

- [T-FLIP source code](https://github.com/jiwonpark0065/T-FLIP).
- **Paper:** T-FLIP: Lightweighting a Face Anti-Spoofing Model via Attention Weight-Based Knowledge Distillation.
- **Tools:** {{ page.stack }}.
