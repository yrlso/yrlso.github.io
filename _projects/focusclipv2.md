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

Microscope image quality affects which images researchers can use for later analysis. A model is easier to incorporate into that workflow when researchers can assess their own images without installing a Python environment or interpreting raw prediction indices.

FocusCLIPv2 exposes a fluorescence image focus-assessment model through a browser. It uses **both the image and stain information**, returning one of three quality categories: **Good, Moderate, or Bad**. The stain identifies the fluorescence channel and is part of the model input, rather than optional metadata.

The engineering goal is a complete path from a researcher's image to an understandable, reusable result.

---

## My role & timeline

- **Ownership:** Deployed the model on Hugging Face Spaces and built the Gradio image-upload, inference, and CSV-export workflow.
- **Status:** Public research demo.
- **Contribution scope:** Deployment and the user-facing inference workflow.

I connected image handling and model execution with the decisions users need to make: which stain to choose, what images to submit, how to interpret a label, and how to keep the result for later use.

---

## Approach

The application connects four components: **Gradio input controls → FocusCLIPv2 inference → result display and CSV export**, hosted on **Hugging Face Spaces**. My work was connecting these components into a usable research workflow.

### 1. Gradio Interface — Image Upload & Stain Selection

Users choose a fluorescence stain and upload images from that channel. The selected stain is passed onward as part of the model input, rather than remaining only a display label.

This interface makes the model's input conditions explicit. Guidance covers the 10× image setting and single-stain inputs; English and Korean instructions, reference examples, and image-use consent support the upload workflow.

### 2. FocusCLIPv2 Inference — Image + Stain Text

The inference pipeline prepares each uploaded image and the selected stain's text information, runs the CLIP-based model, and maps its prediction to **Good, Moderate, or Bad**.

Using both inputs preserves the model's stain-conditioned assessment: different fluorescence channels have different visual characteristics. The supported groups are DAPI / Hoechst (405 nm), Alexa 488 / FITC (488 nm), Alexa 546 / Cy3 (546 nm), and Alexa 647 / Cy5 (647 nm).

### 3. Prediction Display & CSV Export

The result interface presents a quality category for each image. CSV export keeps the original filename, stain, and predicted label together, so the output can be traced back to its source image after the browser session.

This component turns a model prediction into a reusable result. Researchers can review the labels against reference examples and carry the per-image output into their own analysis or records.

### 4. Hugging Face Spaces — Hosted Application

Hugging Face Spaces hosts the Gradio application and its Python inference environment, providing a public browser-accessible demo. Researchers can use the input-to-result workflow without preparing the model environment locally.

The hosting environment is also a practical constraint: inference availability can depend on shared GPU allocation. The application communicates this alongside its usage guidance.

---

## Experiments & results

The engineering outcome is a **publicly deployed inference application**, with a complete researcher-facing workflow:

| Step               | Researcher action                | Result                                                  |
| ------------------ | -------------------------------- | ------------------------------------------------------- |
| 1. Prepare input   | Choose a stain and upload images | Images and channel information are passed to the model  |
| 2. Assess quality  | Run inference                    | A Good / Moderate / Bad label for each image            |
| 3. Keep the output | Download the results             | A CSV linking each prediction to its filename and stain |

This demonstrates deployment of the inference workflow. Model accuracy and user-adoption metrics are not reported as deployment results here. Live inference availability depends on the platform's shared GPU allocation.

The value of the work is connecting a research model with a tool that external users can access, understand, and use to export results.

---

## Resources

- [Try the live demo](https://huggingface.co/spaces/ewha-cvl/focusclipv2).
- [Application source](https://huggingface.co/spaces/ewha-cvl/focusclipv2/tree/main).
- **Tools:** {{ page.stack }}.
