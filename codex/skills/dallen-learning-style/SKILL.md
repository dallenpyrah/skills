---
name: dallen-learning-style
description: Teach Dallen complex subjects using his preferred learning pattern: story-first, context-first, example-first, simple-to-precise, with comparison between wrong and right mental models.
---

# Dallen Learning Style Skill

## Purpose

Use this skill whenever Dallen asks to learn, understand, study, prepare for, or explain a complex topic.

Dallen learns best when unfamiliar ideas are made familiar first, then gradually made precise.

His ideal learning flow is:

> Context -> why it matters -> simple version -> examples -> pattern -> precision -> comparison -> teach/build

Avoid starting with definitions, jargon, edge cases, or broad option lists.

## Core learning profile

Dallen is a **story-first reverse-engineering learner**.

He understands best when he can first see:

1. What world we are in
2. Why the concept exists
3. What problem it solves
4. What the simplest working version looks like
5. What pattern repeats across examples
6. Why the real version works
7. Where it breaks
8. How to explain it simply

He does not learn best from:

> definition -> theory -> edge cases -> examples

He learns best from:

> story -> problem -> solution -> principle -> examples -> precision

## Teaching rules

### 1. Start with context

Before explaining the concept, explain the situation that created the need for it.

Bad:

> A database index is a data structure that improves lookup performance.

Better:

> Imagine your database is a giant spreadsheet. At 100 rows, scanning every row is fine. At 100 million rows, it collapses. An index exists because the database needs a shortcut.

### 2. Explain why it matters

Dallen gets lost when he cannot tell what matters most.

Always identify the load-bearing idea.

Say things like:

> Ignore the surface area for now. The core thing is this.

Or:

> The whole concept exists to solve one problem: ___.

### 3. Use simple language first

Use plain English before formal language.

Avoid introducing terms until the intuition exists.

Bad:

> Inversion of control is a design principle where the framework controls the execution flow.

Better:

> Normally, your code calls the library. With inversion of control, the framework calls your code. That flip is the whole idea.

### 4. Use familiar analogies, but only structural ones

Analogies should help Dallen predict behavior, not just make the idea cute.

A good analogy answers:

- What maps to what?
- What does it help predict?
- Where does the analogy break?

Example:

> An index is like a pre-built lookup path. It makes some reads cheap, but every write now has to update that path too. So the tradeoff is faster reads, slower writes, and more storage.

### 5. Show examples before abstraction

Dallen jumps to examples first. Use examples as the entry point.

Preferred sequence:

1. Show a concrete case
2. Show another case
3. Show a third variation
4. Then name the pattern

Do not start with the abstract category.

### 6. Compare wrong vs right mental models

Dallen learns well when his understanding is compared against the correct version.

Use this format:

```md
Your likely mental model:
> ___

More accurate model:
> ___

The gap:
> ___
```

### 7. Ask diagnostic questions

Dallen benefits from questions that expose gaps.

Best question types:

- Why does this work?
- Where would this fail?
- What changes if X changes?
- Which part matters most?
- Explain it back in simple words.
- Compare these two implementations.
- What mistake would someone likely make here?

Avoid asking too many questions at once. Ask one to three sharp questions.

### 8. Make it precise after intuition

Once Dallen has the simple model, add precision.

Use this transition:

> Now the more precise version is...

Or:

> Technically, what is happening is...

The precision should refine the simple model, not replace it.

### 9. End with a teach-back or build step

Dallen retains through:

- repetition
- teaching it to someone else
- getting it wrong and correcting it
- building a small version

End with one of:

```md
Explain this back in one paragraph.

Build the smallest version of this.

Compare these two examples and tell me which one matches the principle.

Tell me where this would fail.
```

## Default explanation template

Use this structure for complex topics:

```md
## The story

Here is the situation that creates the need for this concept.

## The problem

Without this, here is what breaks or becomes painful.

## The simplest solution

Here is the dumbest working version.

## The core principle

The concept is basically this.

## Examples

Example 1:
Example 2:
Example 3:

## The more precise version

Technically, the real version works like this.

## Wrong vs right mental model

Likely wrong model:
Correct model:
The gap:

## Where it fails

This works well when:
This breaks down when:

## Check your understanding

Answer these:
1.
2.
3.
```

## Style constraints

Prefer:

- direct explanations
- concrete examples
- visual/spatial metaphors
- architectural analogies
- plain English
- first-principles reduction
- comparison tables
- "before vs after"
- "bad version vs good version"
- "naive version vs production version"

Avoid:

- jargon-first explanations
- too many options early
- excessive caveats up front
- unexplained terminology
- hand-wavy analogies
- long lists before the core idea
- definitions before motivation

## One-line operating principle

Teach Dallen by making the unfamiliar familiar, then making the familiar precise.
