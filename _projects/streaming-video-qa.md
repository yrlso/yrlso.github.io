---
layout: "page"
title: "Streaming video question answering"
description: "Choosing what a video system should remember before it knows which question will be asked."
importance: 5
category: "research"
status: "Ongoing research · Evaluation in progress"
period: "July 2026–present"
role_short: "Problem formulation · Selection policy design · Memory-based evaluation"
stack: "Python · PyTorch · Qwen-VL · Reinforcement learning"
summary: "Question-agnostic frame and token selection for answering future questions from a limited visual memory."
card_result: "Ongoing: evaluating answer quality, memory use, and response latency together."
permalink: "/projects/streaming-video-qa/"
---

[← All projects]({{ '/projects/' | relative_url }})

**At a glance:** {{ page.card_result }}

---

## Goal & significance

A streaming video system receives frames continuously, but a question may arrive much later. Storing everything makes memory and later processing grow with the stream; discarding the wrong details can make a future question impossible to answer.

I study **how to preserve useful evidence before the question is known**. At question time, the model must answer using only its retained memory, without revisiting the full video.

---

## My role & timeline

- **Period:** {{ page.period }} · Ongoing research.
- **My work:** Problem formulation, frame/token selection policy design, implementation of a Qwen-VL memory pipeline, and evaluation design.
- **Focus:** The accuracy–memory–latency trade-off as video duration grows.

---

## Approach

- **Select evidence at two levels:** Decide which frames and which visual tokens within those frames deserve memory space.
- **Maintain a bounded memory:** Write new evidence and evict cached information as the stream arrives.
- **Learn useful retention:** Investigate reinforcement learning with a reward based on the information an incoming frame adds to memory, then test whether that retained information helps future QA.

The write policy sees the incoming frame and current memory. The future question is introduced only when the system answers, making evidence retention an explicit part of the problem.

---

## Experiments & results

**Evaluation is in progress; no numerical improvement is reported yet.**

| Evaluation question                    | Measure                                           |
| -------------------------------------- | ------------------------------------------------- |
| Is useful evidence retained?           | QA accuracy from memory alone                     |
| How much memory is needed?             | Accuracy across memory budgets                    |
| Does later answering remain efficient? | Response latency as the stream grows              |
| Does learned selection help?           | Comparison with fixed-stride and random retention |

The aim is to establish when a learned retention policy offers a useful trade-off over simple baselines. Questions whose evidence appeared in the stream but was discarded are especially informative failure cases.

---

## Resources

- **Status:** Ongoing research; final benchmark results, paper, and code are not yet available.
- **Tools:** {{ page.stack }}.
