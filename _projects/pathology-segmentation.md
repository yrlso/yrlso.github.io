---
layout: page
title: Context-aware pathology segmentation
description: Combining local tissue detail with wider context under limited-data and high-resolution constraints.
permalink: /projects/pathology-segmentation/
img: assets/img/pathology-architecture.png
importance: 2
category: research
status: Ongoing research
period: September 2025–present
role: Expert collaboration, data preparation, model design, training, and evaluation
role_short: Data construction · Architecture · Training & evaluation
stack: Python · PyTorch · Virchow2 / UNI · OpenCV
summary: Developing a multi-scale pancreatic tissue segmentation pipeline that accounts for the surrounding tissue context lost when very large slides are divided into small tiles.
card_result: Mean IoU 54.91% → 73.41% on three tissue classes
tags: [Foundation models, Limited data, Multi-scale context]
highlights:
  - value: 18
    label: Whole-slide tissue images in the dataset
  - value: 73.41%
    label: Current three-class mean IoU
  - value: +18.50 pp
    label: Improvement over the 54.91% baseline
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

A whole-slide image (WSI) is a digitized tissue slide that can exceed **20,000 × 20,000 pixels**. These images contain far more spatial information than can be processed as a single ordinary model input, so the slide must be divided into smaller tiles.

That practical requirement creates a modeling problem: **a tile can preserve local appearance while losing the surrounding tissue needed to interpret it**.

The task is to segment three tissue categories in mouse pancreatic images:

| Class  | Meaning in this project                                     |
| ------ | ----------------------------------------------------------- |
| Acinar | Normal acinar tissue                                        |
| PanIN  | Pancreatic intraepithelial neoplasia, a precancerous lesion |
| PDAC   | Pancreatic ductal adenocarcinoma                            |

The expert annotation rules made context especially important. Under this project's labeling protocol, a region that locally resembles PanIN is labeled **PDAC when it lies inside a cancer region**. The correct decision therefore depends on the tissue's spatial relationship to the surrounding cancer, not only on the appearance of the small patch itself.

A second constraint was data availability: the dataset contains **18 whole-slide images**. I kept the large pathology foundation encoder frozen and concentrated adaptation on the downstream architecture and use of context.

## My contribution

I collaborated with biomedical researchers to construct the dataset from their tissue annotations and handled image preprocessing and patch extraction. I translated the domain-specific annotation requirements into an architectural question: **how can a prediction use both local morphology and wider tissue context?**

I designed and trained the dual-decoder model, implemented the pipeline from data preparation through evaluation, and investigated how to expand the spatial context encoded by a frozen foundation model.

## Approach

### Establish a foundation-model baseline

The baseline uses a pathology foundation encoder, such as **Virchow2 or UNI**, followed by an existing **UPerNet single decoder**. This gives a concrete comparison for determining whether changes to context handling improve tissue segmentation.

The encoder remains frozen. This preserves the pretrained tissue representation while reducing the amount of model adaptation required from a small slide collection.

### Give global context and local detail separate decoding paths

A single scale must balance broad tissue organization against fine boundaries. I instead used two decoding paths:

- A **global/context decoder** to interpret wider tissue organization.
- A **local/high-resolution decoder** to preserve morphology and boundaries.

The paths share the frozen encoder and combine their features so that local predictions can use contextual information. The design makes the two needs explicit rather than expecting a small isolated tile to resolve them simultaneously.

<figure class="figure">
<img src="{{ '/assets/img/pathology-architecture.png' | relative_url }}" alt="The pancreatic tissue segmentation architecture with a frozen pathology encoder and separate global and local decoders." loading="lazy" class="img-fluid rounded">
<figcaption class="caption">Architecture illustration from my project materials: a shared frozen pathology encoder supplies global and local decoding paths.</figcaption>
</figure>

### Expand the context available during encoding

Multi-scale decoding still depends on what the encoder features contain. I therefore investigated **dilated spatial sampling for attention** so that a fixed number of tokens could represent a wider tissue region while the pretrained encoder weights stayed frozen.

The goal is to enlarge the sampled field of view without increasing the number of tokens entering attention. This constrains the attention sequence size; it should not be interpreted as a measured guarantee that the entire pipeline has identical runtime or memory use.

This change addresses the representation stage: the wider context can influence the features that the decoders receive, in addition to combining scales later in the pipeline.

### Use failure analysis to guide the next change

One persistent error is the interior of a large PanIN lesion being predicted as background. Such interiors can appear white locally even when their surrounding boundary identifies them as part of a lesion. That failure provides a specific reason to examine larger context instead of treating every wrong pixel as the same type of error.

Earlier experiments with wider views showed a strong improvement in PanIN segmentation, motivating further investigation of context within the frozen encoder. The current design is part of that continuing experimental process.

## Experiments and results

The principal comparison is **mean intersection over union across Acinar, PanIN, and PDAC**.

| Configuration                                        |        Three-class mean IoU |
| ---------------------------------------------------- | --------------------------: |
| Foundation encoder + existing UPerNet single decoder |                      54.91% |
| Current proposed model                               |                  **73.41%** |
| Absolute improvement                                 | **18.50 percentage points** |

These are the current reported results of an ongoing study. The improvement compares the complete proposed configuration against the baseline; it does not isolate the independent contribution of dilated attention. That attribution requires separate controlled ablations.

The broader research objective also includes preserving tissue area proportions. In this application, the relative amounts of normal tissue, precancerous lesions, and cancer can matter alongside boundary-level segmentation quality. Evaluating those proportions and comparing H&E predictions with biomarker-based evidence are continuing research directions.

## What I learned

The annotation protocol is part of the modeling problem. Understanding why an expert assigns a label can reveal an information requirement that is invisible in the local image. Here, discussion with domain experts and inspection of failure cases both pointed to the same limitation: insufficient spatial context.

The project also required working within a concrete data constraint. Keeping a foundation encoder frozen while changing the way context reaches the downstream prediction was a way to use pretrained knowledge without relying on large-scale fine-tuning.

## Resources

This is ongoing collaborative research. The methods and current metrics above are drawn from my project materials; a public paper and code release are not linked here yet.

[← Explore all projects]({{ '/projects/' | relative_url }})
