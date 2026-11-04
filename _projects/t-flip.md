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

Face anti-spoofing distinguishes a live face from attacks such as printed images or replayed video. A compact model must retain subtle spoofing cues and work on capture conditions it did not see during training.

T-FLIP studies whether a smaller model can learn **where the larger model attends**, preserving useful discrimination cues while reducing computation.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **My work:** Visualized and analyzed teacher/student attention, proposed attention-weight alignment, and co-developed the method and experiments.
- **Recognition:** Joint first author; Ewha Computer Science Graduation Project Excellence Award (2024).

My analysis found that a feature-distilled student's deeper layers did not consistently preserve the teacher's attention to spoofing cues. That observation motivated a more targeted distillation objective.

---

## Approach

- **Use a compact student:** Distill the CLIP-based FLIP-MCL teacher into a ViT-Tiny-based model.
- **Transfer attention across layers:** Align corresponding attention patterns, giving the student guidance beyond the final feature vector.
- **Evaluate the trade-off:** Compare recognition quality under domain shift alongside parameter count, computation, and measured throughput.

<figure class="figure">
  <img src="{{ '/assets/img/t-flip-architecture.png' | relative_url }}" alt="T-FLIP teacher and student encoders; dashed connections indicate layer-wise attention supervision using an MSE loss." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Layer-wise attention supervision helps the smaller student preserve how the teacher identifies discriminative cues.</figcaption>
</figure>

---

## Experiments & results

Each cross-domain setting trains on three datasets and tests on the remaining one, across MSU-MFSD, CASIA-MFSD, Idiap Replay Attack, and OULU-NPU. **Lower HTER is better.**

| Student training method      | Mean HTER ↓ |
| ---------------------------- | ----------: |
| No distillation              |      22.29% |
| Feature-based distillation   |      18.64% |
| Relation-based distillation  |      20.63% |
| Attention-based distillation |  **14.77%** |

Compared with the teacher, the compact model uses **69.2% fewer parameters** and **91.8% fewer multiply–accumulate operations (MACs)**, with **2.5× measured throughput**. This demonstrates efficiency gains alongside a direct comparison of the different supervision choices.

---

## Resources

- [T-FLIP source code](https://github.com/jiwonpark0065/T-FLIP).
- **Paper:** T-FLIP: Lightweighting a Face Anti-Spoofing Model via Attention Weight-Based Knowledge Distillation.
- **Tools:** {{ page.stack }}.
