---
layout: "page"
title: "MRI motion artifact correction"
description: "Adapting generative image translation to improve motion-degraded MRI images."
importance: 7
category: "internship"
status: "KIST research internship"
period: "September–December 2023"
role_short: "KIST research intern · Model adaptation & experimental analysis"
stack: "Python · SynDiff · CycleGAN · Diffusion models"
summary: "Implementation and evaluation of a CycleGAN–diffusion pipeline for MRI motion artifact correction at KIST."
card_result: "Qualitative correction results from four motion-degraded MRI examples."
img: "assets/img/kist-mri-results.png"
image_alt: "Four MRI examples, each showing a motion-corrupted image followed by its corrected output"
permalink: "/projects/kist-mri/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

Motion during an MRI scan can blur anatomy and introduce image artifacts. This project investigated whether generative image translation could improve the quality of motion-corrupted MRI images.

It was my first experience adapting an existing generative method to a medical imaging problem and inspecting the outputs in relation to the task's needs.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **Organization:** Medical AI Lab, Bionics Research Center, Korea Institute of Science and Technology (KIST).
- **My work:** Model implementation and adaptation, experiment execution, and result analysis.

---

## Approach

- **Adapt an existing method:** Apply SynDiff, combining CycleGAN-style image translation with diffusion modeling, to the MRI correction task.
- **Run the complete experiment pipeline:** Prepare the method for the project setting, execute experiments, and compare the corrected images with their inputs.
- **Inspect task-specific changes:** Examine whether motion-related degradation is reduced and anatomical structures become easier to distinguish.

---

## Experiments & results

The figure shows **four examples**, separated by vertical lines. **Within each pair, the left image is before correction and the right image is after correction.**

<figure class="figure">
  <img src="{{ '/assets/img/kist-mri-results.png' | relative_url }}" alt="Four pairs of MRI images. In each pair, the left image has motion artifacts and the right image is the corrected output." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Four qualitative results. Left within each pair: motion-corrupted input. Right: corrected output.</figcaption>
</figure>

The examples illustrate reduced visible motion artifacts and clearer structures after correction. They are **qualitative results**, rather than a numerical image-quality benchmark or evidence of clinical validation.

The internship gave me hands-on experience moving from an existing model to task adaptation, execution, and analysis—a workflow I later applied to pathology and multimodal research.

---

## Resources

- **Research setting:** KIST Medical AI Lab, Bionics Research Center.
- **Tools:** {{ page.stack }}.
