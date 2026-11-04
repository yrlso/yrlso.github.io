---
layout: page
title: T-FLIP
description: Attention-based knowledge distillation for a lightweight face anti-spoofing model.
permalink: /projects/t-flip/
importance: 6
category: research
status: Undergraduate capstone · Joint first author
period: March–December 2024
role: Attention-map visualization and analysis, distillation idea, collaborative method development and experiments
role_short: Joint first author · Failure analysis · Model compression
stack: Python · PyTorch · CLIP · FLIP-MCL · ViT-Tiny
summary: Transferring layer-level attention from a large teacher to a compact student, guided by analysis of which spoofing cues the student failed to preserve.
card_result: 91.8% fewer MACs and 2.5× throughput vs. the teacher
tags: [Knowledge distillation, Cross-domain evaluation, Capstone award]
highlights:
  - value: −69.2%
    label: Parameters vs. the teacher
  - value: −91.8%
    label: MACs vs. the teacher
  - value: 2.5×
    label: Throughput vs. the teacher
  - value: 14.77%
    label: Mean cross-domain HTER
links:
  - label: View project code
    url: https://github.com/jiwonpark0065/T-FLIP
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

Face anti-spoofing distinguishes a real face presentation from an attack, such as a printed image or replayed video. A model must preserve subtle spoofing cues while generalizing to capture conditions and datasets that differ from training.

The CLIP-based **FLIP-MCL** teacher provides a useful starting point, but its image and text Transformer components have substantial parameter and computation requirements. The goal was to train a smaller **ViT-Tiny-based student** that retained the teacher's useful discrimination cues at a lower inference cost.

This required evaluating both recognition quality and resource use. A smaller model would be less useful if it lost the cues needed for cross-domain generalization.

## My contribution

I directly visualized and analyzed layer-wise attention maps from the teacher and student. That analysis motivated my proposal to align the student's attention weights with the teacher's at corresponding layers.

I co-developed the method and experiments with the team. I am a joint first author of the project paper, presented at the Institute of Electronics and Information Engineers autumn conference in 2024. The capstone received the **Ewha Computer Science Graduation Project Excellence Award**.

## Approach

### Inspect why the smaller model fails

The feature-distilled student's early-layer attention resembled the teacher's, but its later-layer attention shifted inconsistently. It did not reliably focus on spoofing cues such as paper texture.

That observation suggested a more specific transfer target than only making the final feature vectors similar: teach the student **where and how the teacher attends across layers**.

### Align attention weights at corresponding layers

The method uses FLIP-MCL as the teacher and a compact ViT-Tiny-based student. Images are processed at **224 × 224 resolution with 16 × 16 patches**.

At corresponding self-attention layers, a mean squared error objective aligns the attention weights. Losses are summed across the paired layers so that the student receives guidance throughout the hierarchy, including the deeper layers where the visual analysis revealed a mismatch.

The intended transfer includes spatial relationships and attention patterns associated with discriminative cues, rather than only a final representation target.

### Compare alternative distillation signals

The experiments compare:

- The student without distillation.
- Feature-based distillation.
- Relation-based distillation.
- The proposed attention-based distillation.

Holding the student setting comparable makes these alternatives useful for evaluating whether the chosen transfer signal addresses the observed failure.

## Experiments and results

### Evaluate cross-domain generalization

The study uses **MSU-MFSD, CASIA-MFSD, Idiap Replay Attack, and OULU-NPU**. Each setting trains on three datasets and evaluates on the remaining dataset, producing four cross-domain settings. HTER and AUC assess performance under that domain shift.

| Student training method      | Mean HTER ↓ |
| ---------------------------- | ----------: |
| No distillation              |      22.29% |
| Feature-based distillation   |      18.64% |
| Relation-based distillation  |      20.63% |
| Attention-based distillation |  **14.77%** |

The mean HTER comparison is across the study's cross-domain settings. It is separate from the individual OCI→M result below.

### Measure efficiency alongside accuracy

| Metric          |            Result | Comparison                            |
| --------------- | ----------------: | ------------------------------------- |
| Parameter count |   69.2% reduction | Teacher model                         |
| MACs            |   91.8% reduction | Teacher model                         |
| Throughput      |              2.5× | Teacher model                         |
| OCI→M HTER      | 10.08% vs. 12.43% | DRDG comparison reported in the study |

The OCI→M comparison corresponds to a **2.35 percentage-point HTER reduction**. Parameter count, MACs, and throughput are different measures and are reported separately.

## What I learned

The attention visualizations connected an observed failure to a concrete training objective. That made the distillation choice explainable and testable.

The project also gave me experience evaluating efficiency as a trade-off. Parameter reduction and theoretical operation count were useful, but measuring actual throughput supplied another view of the compact model's behavior.

## Resources

- [T-FLIP source code](https://github.com/jiwonpark0065/T-FLIP)
- **Paper:** T-FLIP: Lightweighting a Face Anti-Spoofing Model via Attention Weight-Based Knowledge Distillation.
- **Authors:** Ejung Ryoo*, Jiwon Park*, Yerim So*, Jongwon Choi, Jaehyeong Sim (* equal contribution).
- **Recognition:** Ewha Computer Science Graduation Project Excellence Award, 2024.

[← Explore all projects]({{ '/projects/' | relative_url }})
