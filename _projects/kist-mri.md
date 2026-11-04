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

Motion during an MRI scan can blur anatomical structures and create artifacts. The project investigated whether a generative image-translation method could improve images affected by that degradation.

The task differs from generating a visually plausible image from scratch: the output needs to remain connected to the input anatomy while reducing motion-related degradation. Evaluating the corrected images in the context of the task is therefore part of adapting the method.

---

## My role & timeline

- **Period:** {{ page.period }}.
- **Organization:** Medical AI Lab, Bionics Research Center, Korea Institute of Science and Technology (KIST).
- **Ownership:** Model implementation and adaptation, experiment execution, and result analysis.

I worked with **SynDiff**, a framework combining CycleGAN-style image translation and diffusion modeling, and applied it to the MRI motion-artifact correction setting. This gave me early experience moving from an existing research method to a new medical-imaging task.

---

## Approach

The figure below presents correction results rather than an architecture diagram. The implementation can be understood through three components: **motion-corrupted MRI input → SynDiff correction pipeline → corrected output and comparison**.

### 1. Motion-corrupted MRI Input

The pipeline receives an MRI image affected by motion artifacts. This is the image to be corrected, and it remains the reference for inspecting how the generated output changes visible anatomy and degradation.

Defining this input–output relationship matters: the goal is correction of a particular image, so a visually plausible output alone does not explain whether the original problem has been addressed.

### 2. SynDiff — Image Translation & Diffusion Modeling

SynDiff is the existing generative framework I adapted to this task. It combines CycleGAN-style image translation with diffusion modeling to study the mapping from motion-degraded images to corrected images.

My contribution was model implementation, task adaptation, and running the experimental pipeline. The method's role is to produce the corrected image; my work applied and evaluated that existing framework in the MRI project setting.

### 3. Corrected Output & Visual Comparison

The output is compared with its corresponding motion-corrupted input. The four examples in the results section preserve this pairing, with the input on the left and corrected output on the right.

Direct comparison makes changes in visible artifacts and anatomical structures easier to interpret. These examples document qualitative correction behavior; quantitative image-quality scores are not reported on this page.

---

## Experiments & results

The figure contains **four examples**, separated by vertical lines. **Within every pair, the left image is the motion-corrupted input and the right image is the corrected output.**

<figure class="figure">
  <img src="{{ '/assets/img/kist-mri-results.png' | relative_url }}" alt="Four MRI comparison pairs, each ordered as motion-corrupted input on the left and corrected output on the right." class="img-fluid rounded" loading="lazy">
  <figcaption class="caption">Four qualitative correction examples. Each pair: before correction (left) → after correction (right).</figcaption>
</figure>

The examples show reduced visible motion artifacts and clearer structures after correction. They document **qualitative results**; this page does not report a numerical image-quality benchmark.

My contribution was implementation, task adaptation, and experimental analysis of the existing method. The experience later informed how I work with medical data and inspect failure cases in pathology segmentation.

---

## Resources

- **Research setting:** KIST Medical AI Lab, Bionics Research Center.
- **Tools:** {{ page.stack }}.
