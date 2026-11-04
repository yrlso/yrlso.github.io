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

A streaming video system sees frames as they arrive, while a user may ask a question much later. The system cannot assume in advance which event or detail the question will concern.

Keeping the full stream makes storage and later processing grow with video duration. Keeping too little can remove the only evidence needed for an answer. For example, a brief event may matter to a future question even if it never appears again.

I study **how to select useful visual evidence before the question is known**. At question time, the model must answer using only its retained memory; it cannot replay the full video to recover discarded evidence.

---

## My role & timeline

- **Period:** {{ page.period }} · Ongoing research.
- **Ownership:** Problem formulation, frame/token selection policy design, a Qwen-VL-based memory pipeline, and evaluation design.
- **Research focus:** The trade-off between answer quality, retained visual information, and response latency.

I investigate both which frames to keep and which visual tokens within a frame deserve memory space. A visual token represents part of the frame in the model, allowing more selective retention than storing every token from each chosen image.

---

## Approach

- **Write without a future question.** The selection policy observes the incoming visual information and current memory. It decides what to add or remove without using the unseen future question.
- **Maintain a fixed memory budget.** When new information arrives, older or less useful cached information may need to be evicted. KV cache eviction controls the visual context retained by the model as the stream grows.
- **Investigate a learning signal for useful retention.** The reinforcement-learning formulation treats writing and eviction as sequential decisions. An information-based reward considers what the incoming frame adds to memory; evaluation then asks whether that information helps actual future questions.
- **Answer from retained evidence.** When a question arrives, the QA model reads the question and stored memory. This separates successful answering from the selection policy's ability to preserve the necessary evidence.

The central challenge is that information that looks unremarkable now may become important later. Memory errors are therefore evaluated through their consequences for future answers, not only how much information is stored.

---

## Experiments & results

**Evaluation is in progress; final numerical results are not yet reported.** The evaluation is designed to make the system-level trade-off explicit:

| Comparison or question                                | What it measures                                      |
| ----------------------------------------------------- | ----------------------------------------------------- |
| QA using only the retained memory                     | Whether useful evidence survives selection            |
| Different memory budgets                              | How answer accuracy changes as storage is constrained |
| Longer streams at a fixed memory budget               | Whether question-time latency remains controlled      |
| Learned selection vs. fixed-stride / random retention | Whether the policy improves over simple alternatives  |

A fixed-stride baseline keeps frames at regular intervals; a random baseline selects without learned relevance. Comparisons need matched memory budgets so a method does not appear better simply because it stores more evidence.

Particularly informative failures are questions whose supporting evidence appeared in the stream but was later discarded. These cases help diagnose the retention policy and the relationship between its reward and downstream QA quality.

---

## Resources

- **Status:** Ongoing research; final benchmark results, paper, and code are not yet available.
- **Tools:** {{ page.stack }}.
