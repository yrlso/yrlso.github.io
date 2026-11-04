---
layout: "page"
title: "FocusCLIPv2"
description: "Making fluorescence image focus assessment accessible through a browser-based research tool."
importance: 1
category: "engineering"
status: "Public research demo"
role_short: "Model deployment · Inference interface · Result export"
stack: "Python · CLIP · Gradio · Hugging Face Spaces"
summary: "A deployed tool that takes microscope images and stain information, predicts focus quality, and exports per-image results."
card_result: "Live demo: image upload → Good / Moderate / Bad prediction → CSV export."
links:
  [
    { "label": "Live demo", "url": "https://huggingface.co/spaces/ewha-cvl/focusclipv2" },
    { "label": "Source", "url": "https://huggingface.co/spaces/ewha-cvl/focusclipv2/tree/main" },
  ]
permalink: "/projects/focusclipv2/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

A microscope image quality model is easier to use when researchers can submit their own images and inspect results without installing a Python environment. FocusCLIPv2 turns model inference into a browser-based workflow.

The tool assesses fluorescence image focus using **both the image and stain information**, returning one of three quality categories: Good, Moderate, or Bad.

---

## My role & timeline

- **My work:** Deployed the model on Hugging Face Spaces and built the Gradio upload, inference, and CSV export workflow.
- **Status:** Public research demo.
- **Contribution scope:** Model deployment and the user-facing inference workflow.

I connected model inputs and outputs with the steps a researcher needs to run an assessment, understand the labels, and keep the results.

---

## Approach

- **Make inputs clear:** Let users select the stain and upload multiple images, with guidance on supported channels and single-stain inputs.
- **Make outputs interpretable:** Present named quality categories with stain-specific reference examples.
- **Make results reusable:** Export the original filename, selected stain, and prediction together in a CSV.

The application provides English and Korean guidance and communicates image-use consent before upload. Its documented model setting uses 10× images and four predefined stain groups.

---

## Experiments & results

The engineering outcome is a **publicly deployed, complete inference workflow**:

| Researcher action                | Application output                              |
| -------------------------------- | ----------------------------------------------- |
| Select a stain and upload images | Inputs prepared for the model                   |
| Run assessment                   | Good / Moderate / Bad for each image            |
| Download results                 | CSV retaining filenames, stain, and predictions |

This page presents the deployment outcome rather than a new model-accuracy benchmark. Live inference availability depends on the hosting platform's shared GPU allocation.

---

## Resources

- [Try the live demo](https://huggingface.co/spaces/ewha-cvl/focusclipv2).
- [Application source](https://huggingface.co/spaces/ewha-cvl/focusclipv2/tree/main).
- **Tools:** {{ page.stack }}.
