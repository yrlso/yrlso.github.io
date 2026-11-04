---
layout: page
title: FocusCLIPv2
description: A deployed tool for stain-conditioned focus quality assessment of fluorescence microscope images.
permalink: /projects/focusclipv2/
importance: 1
category: engineering
status: Public research demo
role: Model deployment and user-facing inference workflow
role_short: Deployment · Inference interface · Result export
stack: Python · CLIP · Gradio · Hugging Face Spaces
summary: Making a fluorescence image quality model accessible through a complete workflow—from stain selection and image upload to predictions and downloadable results.
card_result: Live application with image upload, inference, and CSV export
tags: [Live demo, Medical imaging, Model deployment]
highlights:
  - value: Live
    label: Public Hugging Face Spaces application
  - value: 3 classes
    label: Good · Moderate · Bad focus quality
  - value: CSV
    label: Exportable per-image results
links:
  - label: Try the live demo
    url: https://huggingface.co/spaces/ewha-cvl/focusclipv2
  - label: Application source
    url: https://huggingface.co/spaces/ewha-cvl/focusclipv2/tree/main
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

Fluorescence microscope images can differ substantially in focus quality. A model that assesses image quality is more useful when researchers can evaluate their own images without setting up a Python environment, preparing command-line arguments, or interpreting raw model outputs.

FocusCLIPv2 exposes a CLIP-based focus assessment model through a browser interface. The model uses both an image and **stain information expressed as text**. The stain input matters because images from different fluorescence channels have different visual characteristics; the application therefore makes this part of the input explicit.

The public demo describes a model trained on images captured at **10× magnification**. Its supported stain choices are predefined. Those conditions are part of the tool's intended use and should be visible to a user before inference.

## My contribution

My contribution was **deploying the model on Hugging Face Spaces and providing an image upload, inference, and CSV export workflow using Gradio**.

I connected model inference to an interface that lets users specify stain information, submit microscope images, inspect quality labels, and retain the results for later analysis. The public application also provides usage instructions and representative images so that the output categories have a concrete interpretation.

## Approach

1. **Select a stain** Provide the fluorescence channel information.
2. **Upload images** Submit supported image files through the browser.
3. **Run inference** Assess each image with the CLIP-based model.
4. **Review & export** Inspect quality labels and download a CSV.

### Make the model's input assumptions explicit

The interface supports four stain groups:

| Stain group      | Excitation wavelength shown in the application |
| ---------------- | ---------------------------------------------- |
| DAPI / Hoechst   | 405 nm                                         |
| Alexa 488 / FITC | 488 nm                                         |
| Alexa 546 / Cy3  | 546 nm                                         |
| Alexa 647 / Cy5  | 647 nm                                         |

Users select a stain from a dropdown and upload images sharing that stain. The instructions recommend single-stain images because overlay images may reduce performance. They also explain how to select the closest supported wavelength when a stain is not listed.

### Connect image handling, model execution, and readable output

The Gradio application accepts multiple images and advertises JPG, JPEG, PNG, and TIF support. The public inference implementation loads each image, converts it to RGB, prepares the inputs, executes prediction, and maps the model output to a quality label.

The user sees **Good, Moderate, or Bad** rather than an unexplained numeric class index. Example images for each quality class and stain group help users understand the expected meaning of those labels.

### Preserve results beyond the browser session

A downloadable CSV records the **original image filename, selected stain, and predicted quality label**. Keeping those fields together lets users associate a result with its source image and carry the output into their own analysis or record keeping.

The application provides English and Korean interface options. Instructions explain the upload, inference, and download sequence, as well as the shared GPU allocation limitation of the hosted environment.

### Communicate data handling before upload

The public interface asks users to acknowledge that uploaded images may be stored and used for research. The consent control is presented before the upload workflow is enabled. This makes the application's data-handling conditions part of the user-facing experience.

## Experiments and results

The outcome presented here is a **publicly accessible research inference application** with a complete input-to-output workflow:

- Browser-based image submission with stain selection.
- Model predictions displayed as three interpretable quality categories.
- Per-image CSV export.
- Stain-specific reference examples and bilingual guidance.

This case study documents the deployed inference workflow. Model-accuracy benchmarking is separate from the deployment outcome presented here. Inference availability can depend on the shared GPU allocation of the hosting platform.

## What I learned

Deploying a model involves translating its assumptions into an interface: what information users must supply, what inputs are supported, what the outputs mean, and how a user can reuse the result. A working demo needs a coherent path through all of those steps.

This experience complements my model research by connecting inference code with an accessible tool and an external deployment environment.

## Resources

- [Live demo on Hugging Face Spaces](https://huggingface.co/spaces/ewha-cvl/focusclipv2)
- [Public application source and dependencies](https://huggingface.co/spaces/ewha-cvl/focusclipv2/tree/main)

[← Explore all projects]({{ '/projects/' | relative_url }})
