---
layout: "page"
title: "Streaming video question answering"
description: "Choosing what a video system should remember before it knows which question will be asked."
importance: 5
category: "research"
status: "Ongoing research · Evaluation in progress"
period: "September 2026–present"
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

The system is organized as **visual encoding → frame/token selection → bounded memory → question answering**. The selection and memory modules operate as frames arrive; the QA module runs when a later question is provided.

### 1. Visual Encoding — Qwen-VL Pipeline

Incoming frames are represented as visual tokens in a Qwen-VL-based pipeline. A token represents part of the frame, allowing the system to select useful regions within an image rather than treating every frame as an indivisible unit.

This representation is the input to the retention policy. Selecting at the token level provides a finer use of a limited memory budget than keeping all tokens from every retained frame.

### 2. Frame / Token Selection Policy

The policy observes the incoming visual information and current memory, then decides **which frames and which tokens to preserve**. It does not use the future question, which is unknown at write time.

I investigate reinforcement learning for these sequential decisions. The state contains incoming evidence and memory; the actions concern retention and removal; an information-based reward considers what the incoming frame adds to memory. The research question is whether this signal leads to information that supports later QA.

### 3. Bounded Visual Memory & KV Cache Eviction

The memory stores the selected visual evidence under a capacity constraint. As new information arrives, KV cache eviction removes cached information when needed so visual context does not grow indefinitely with stream duration.

The module's role is to implement the selection policy's trade-off: retaining useful new evidence may require giving up old evidence. A fixed capacity controls retained context size; measured latency still needs to be evaluated on the actual implementation.

### 4. Memory-only Question Answering

When a question arrives, the QA model receives the question and retained memory. It cannot revisit the full original video to recover information removed by the selection and eviction modules.

This makes answering an evaluation of the entire retention pipeline. If an event appeared in the stream but the memory discarded its evidence, the QA model may no longer have enough information to answer correctly. Such failures help assess both the selection policy and its reward design.

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
