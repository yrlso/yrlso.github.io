---
layout: page
title: MRI motion artifact correction
description: Applying generative models to motion-corrupted MRI during a research internship at KIST.
permalink: /projects/kist-mri/
importance: 7
category: internship
status: Research internship
period: September–December 2023
role: Model implementation and adaptation, experiment execution, and analysis
role_short: KIST research intern · Implementation & experimental analysis
stack: Python · Generative modeling · CycleGAN · Diffusion models
summary: Adapting a generative image-translation pipeline to study correction of motion artifacts in MRI images.
card_result: Research experience adapting CycleGAN–diffusion modeling to medical images
tags: [KIST, MRI, Generative models]
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

Motion during an MRI scan can introduce artifacts that degrade image quality. The research task was to investigate whether generative modeling could improve motion-corrupted MRI images.

I worked on this problem as a research intern in the **Medical AI Lab, Bionics Research Center, Korea Institute of Science and Technology (KIST)**, from September to December 2023.

## My contribution

I participated in model implementation and adaptation, experiment execution, and analysis. The work involved applying **SynDiff**, which combines CycleGAN-style image translation with diffusion modeling, to MRI motion artifact correction.

This internship was an early opportunity to move from an existing generative method to the practical details of a new medical imaging task.

## Approach

### Understand the adaptation target

The input contains motion-related degradation, while the desired output should have improved image quality. Applying a general generative image-translation framework required considering the characteristics of MRI data and the intended correction task.

### Implement and apply a combined generative pipeline

I worked with the SynDiff framework, combining adversarial image translation and a diffusion-based component. My responsibilities centered on making the method applicable to the project setting and running the corresponding experiments.

The value of this experience was in the complete implementation-and-analysis loop: understanding an existing method, adapting its use, executing experiments, and inspecting the resulting images.

## Experiments and results

The project provided hands-on research experience with a **CycleGAN–diffusion pipeline for medical imaging**. My documented contribution includes model implementation, task adaptation, and experiment analysis.

The outcome described here is my implementation and experimental analysis work during the internship.

## What I learned

Working on medical images made task-specific interpretation essential. An image-generation method needs to be considered in the context of the information the target domain requires, and experiments need to be inspected with that purpose in mind.

This experience helped establish the implementation and analysis skills I later used in pathology segmentation and multimodal model research.

## Resources

- **Organization:** Korea Institute of Science and Technology (KIST), Medical AI Lab, Bionics Research Center.
- **Period:** September–December 2023.
- **Research direction:** MRI motion artifact correction using a CycleGAN–diffusion framework.

[← Explore all projects]({{ '/projects/' | relative_url }})
