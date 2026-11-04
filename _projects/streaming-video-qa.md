---
layout: page
title: Streaming video question answering
description: Learning what to preserve when future questions are unknown and visual memory is bounded.
permalink: /projects/streaming-video-qa/
importance: 5
category: research
status: Ongoing research · Evaluation in progress
period: July 2026–present
role: Problem formulation, frame/token selection policy design, and memory-based QA research
role_short: Policy design · Reinforcement learning · Memory management
stack: Python · PyTorch · Qwen-VL · KV cache eviction
summary: Investigating how an online video system can retain useful visual evidence before knowing the question, then answer using only its bounded memory.
card_result: Joint evaluation of answer accuracy, memory capacity, and latency
tags: [Ongoing research, Video QA, Reinforcement learning]
highlights:
  - value: Online
    label: Frames arrive before the future question is known
  - value: Bounded
    label: Visual memory capacity is constrained
  - value: Memory-only
    label: QA uses the retained evidence
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

In streaming video, frames arrive continuously. A question may arrive much later, and the system cannot assume that it knows in advance which visual details the question will require.

Keeping every frame makes storage and question-time processing grow with the video. Removing information indiscriminately can discard precisely the evidence needed for a future answer. The central challenge is therefore **deciding what to remember before the question is known**.

I study a setting in which question answering uses **only the stored visual memory**. The system cannot revisit the complete original video to recover evidence that its write policy discarded.

## My contribution

I formulated the information-retention problem and designed a policy for choosing both **which frames** and **which visual tokens within those frames** to preserve. My implementation work centers on a Qwen-VL-based pipeline, bounded visual memory, and KV cache eviction.

The research also investigates reinforcement learning for sequential memory updates. The current evaluation examines whether the retained information is useful for later QA and how answer quality changes with memory capacity and response latency.

## Approach

### Separate memory writing from future-question answering

At write time, the system observes the incoming visual information and the current memory. It must make a retention decision without conditioning that decision on an unseen future question.

At question time, the QA model receives the question and the retained memory. This separation makes information selection an explicit part of the task rather than allowing question-conditioned access to the full video.

1. **Incoming frame** New visual information arrives online.
2. **Selection policy** Choose frames/tokens to preserve or remove.
3. **Bounded memory** Update the retained visual evidence.
4. **Future question** Answer using the stored memory.

### Select at both the frame and token levels

A frame may contain useful information without every patch being equally useful. Selecting frames and tokens jointly allows the memory to preserve evidence more selectively than retaining all tokens from every sampled frame.

The policy considers the new frame together with the memory contents. Its actions determine what to write and what to evict when the capacity constraint requires a trade-off.

### Manage the model's cached visual information

The pipeline uses **KV cache eviction** to control which cached visual information is retained. The intent is to keep the amount of visual context processed at question time within a bounded range as the stream grows.

Bounding that context is a system-design constraint. Whether it produces stable measured latency depends on the implementation and hardware, so latency is being evaluated rather than presented here as an established result.

### Study an information-based reward

The reinforcement-learning formulation treats memory updates as sequential decisions. The state includes current memory and incoming visual information; actions select the information to retain or remove.

The current design uses the **information added to memory by an arriving frame** as a reward signal. It seeks to encourage useful accumulation without requiring the future question at write time. A key experimental question is whether this information-based signal correlates with actual future question-answering utility.

## Experiments and results

**Evaluation is in progress. No completed numerical improvement is claimed on this page.**

The evaluation questions are:

| Question                                  | What is examined                                                                   |
| ----------------------------------------- | ---------------------------------------------------------------------------------- |
| Does the memory retain useful evidence?   | Accuracy on questions answered from the retained memory                            |
| How sensitive is performance to capacity? | Answer quality across visual-memory budgets                                        |
| Does question-time cost stay controlled?  | Response latency as stream duration and memory capacity vary                       |
| Is learned selection useful?              | Comparison with simple retention policies such as fixed-stride or random selection |

The first priority is to establish a reliable comparison between evidence retention and downstream QA quality. Subsequent analysis can separate the effect of frame selection, token selection, and eviction choices.

## What I am investigating

The project connects representation learning with a system-level constraint: memory decisions made now affect what a model can answer later. The most informative failure cases are questions whose required evidence existed in the stream but was not retained.

My aim is to use those failures to assess the selection policy and reward design, while measuring the accuracy–memory–latency trade-off explicitly.

## Resources

This research is ongoing. A paper, code release, and final benchmark results are not publicly linked yet.

[← Explore all projects]({{ '/projects/' | relative_url }})
