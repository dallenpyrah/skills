---
name: learning-style-discovery
description: Diagnose how a person learns by asking structured questions about examples, abstraction, feedback, memory, failure modes, and teaching preferences, then produce a practical teaching profile.
---

# Learning Style Discovery Skill

## Purpose

Use this skill to discover how someone learns best.

The goal is not to label them with a generic category like "visual learner" or "auditory learner."

The goal is to identify:

1. How they enter a hard subject
2. What makes them feel lost
3. What makes something click
4. What kind of examples help
5. What kind of feedback works
6. How they retain knowledge
7. What teaching sequence fits them best

## Important principle

Do not ask:

> Are you a visual learner?

Instead ask behavior-based questions:

> When you finally understand something, what does it feel like?

Or:

> When you get stuck, what do you actually do next?

Learning style should be inferred from patterns, not self-declared identity.

## Discovery process

Use three rounds.

## Round 1: Learning entry point

Goal: discover how the person first grabs a new idea.

Ask questions like:

```md
1. When learning something complex, what helps most at the beginning?

A. A concrete example
B. A diagram
C. A plain-English explanation
D. The formal definition
E. Trying it yourself and failing

2. Which opening would hook you most?

A. "Here is the real-world problem this solves."
B. "Here is the simplest toy version."
C. "Here is a visual metaphor."
D. "Here is the rigorous definition."
E. "Here is broken code; fix it."

3. What annoys you most when someone teaches?

A. Too abstract too early
B. Too slow
C. No examples
D. No structure
E. No explanation of why it matters
F. They hide the hard parts

4. When you finally understand something, it usually feels like:

A. I can picture it now.
B. I can explain it simply now.
C. I can use it now.
D. I see where it fits in the system now.
E. I know the rule now.
F. I know what mistakes not to make now.
```

After Round 1, infer the person's likely learning entry point:

- example-first
- story-first
- definition-first
- visual-first
- build-first
- failure-first
- system-first
- question-first

Do not finalize the profile yet.

## Round 2: Understanding mechanism

Goal: discover what actually makes the concept click.

Ask:

```md
1. When an analogy helps, why does it help?

A. It makes the idea less scary.
B. It maps part-for-part to the real concept.
C. It gives me a picture in my head.
D. It lets me predict what happens next.
E. It makes the vocabulary easier.
F. It shows why the concept exists.

2. Which feedback helps most?

A. Tell me the correct answer.
B. Show me where my mental model broke.
C. Give me a hint and let me retry.
D. Show me another example.
E. Explain the principle I missed.
F. Watch me do it and correct me.

3. What kind of question helps you most?

A. Explain this back to me.
B. What happens if we change X?
C. Why does this work?
D. Where would this fail?
E. Which example matches this principle?
F. What is the simplest version of this?

4. When learning code or technical systems, what helps most?

A. Build from scratch.
B. Read a finished implementation.
C. Modify a working example.
D. Debug a broken example.
E. Watch someone build it.
F. Compare two implementations.
```

Infer the person's understanding mechanism:

- analogy-driven
- prediction-driven
- comparison-driven
- principle-driven
- implementation-driven
- correction-driven
- explanation-driven
- visual-spatial

## Round 3: Failure modes and retention

Goal: discover what blocks learning and what makes knowledge stick.

Ask:

```md
1. When you procrastinate learning something hard, what is usually the real reason?

A. It feels too abstract.
B. I do not know where to start.
C. I cannot see why it matters.
D. I am afraid I will be bad at it.
E. It feels like too much at once.
F. I need someone to show me the first move.

2. What kind of complexity overwhelms you most?

A. Too many terms.
B. Too many steps.
C. Too many options.
D. Too many abstractions.
E. Too many edge cases.
F. Too much hidden context.

3. Which sentence feels most true?

A. I understand when I can explain it simply.
B. I understand when I can use it correctly.
C. I understand when I know why it works.
D. I understand when I know where it fails.
E. I understand when I can compare it to alternatives.
F. I understand when I can teach it.

4. What makes something stick?

A. A story.
B. A visual image.
C. Repetition.
D. Emotional stakes.
E. Using it in a project.
F. Teaching it to someone else.
G. Getting it wrong first.

5. What kind of mistake bothers you most?

A. I memorized but did not understand.
B. I misunderstood the core idea.
C. I missed an edge case.
D. I picked the wrong abstraction.
E. I could not explain it simply.
F. I used it in the wrong situation.
```

Infer:

- primary blockers
- preferred correction style
- retention loop
- mastery signal

## Output format

After the three rounds, produce a profile like this:

```md
# Learning Style Profile

## Summary

You are a [archetype name].

One-line description:
> ___

## You learn best through

1. ___
2. ___
3. ___

## Your ideal learning sequence

1. ___
2. ___
3. ___
4. ___
5. ___
6. ___

## What makes you feel lost

1. ___
2. ___
3. ___

## What makes something click

1. ___
2. ___
3. ___

## Best teacher archetype

You need a teacher who:
- ___
- ___
- ___

## Bad teaching pattern for you

Avoid:
- ___
- ___
- ___

## Best explanation template for you

Use:

Context -> Problem -> Simple version -> Examples -> Principle -> Precision -> Failure modes -> Teach-back

## Retention loop

Your best retention loop is:

___ -> ___ -> ___ -> ___

## Prompt to use in the future

Teach this to me by:
___
```

## Archetype naming guide

Create a custom archetype based on the person's answers.

Examples:

- The Architectural Reverse-Engineer
- The Example-First Builder
- The Visual Systems Mapper
- The Socratic Debugger
- The Story-First Simplifier
- The Definition-First Formalist
- The Failure-Mode Learner
- The Comparison-Driven Engineer
- The Big-Picture Integrator
- The Hands-On Experimenter

Avoid generic labels like:

- visual learner
- auditory learner
- kinesthetic learner

Those are usually too shallow to be useful.

## Interpretation guide

### If they prefer examples first

Teach using:

> examples -> pattern -> principle -> definition

### If they prefer definitions first

Teach using:

> definition -> implication -> example -> edge case

### If they prefer building

Teach using:

> working artifact -> modification -> failure -> principle

### If they prefer stories

Teach using:

> context -> pain -> invention -> principle -> modern use

### If they prefer questions

Teach using:

> claim -> question -> contradiction -> refined model

### If they prefer comparison

Teach using:

> naive version -> better version -> tradeoff -> principle

### If they prefer precision after simplicity

Teach using:

> simple model -> exact model -> boundary conditions

## Rules for the interviewer

1. Ask short, concrete questions.
2. Do not over-explain during diagnosis.
3. Let the person answer in their own words.
4. Look for repeated patterns, not single answers.
5. Reflect the pattern back after each round.
6. Do not force a category too early.
7. Separate entry preference from mastery preference.
8. Identify both learning accelerators and blockers.
9. End with a reusable teaching prompt.
10. Make the profile practical enough that another teacher could use it.

## Final goal

The final profile should answer:

> "How should someone teach this person so complex ideas become understandable, usable, and memorable?"
