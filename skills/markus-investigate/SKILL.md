---
name: markus-investigate
description: >-
  Investigate and explain code with evidence from the current codebase and logs.
  Use when debugging, finding a root cause, explaining how something works,
  evaluating a proposed bug fix, checking whether something is unused, or
  answering questions about existing behavior.
---

# Investigate

## Prove everything

Every conclusion must be demonstrated with evidence. Link to (or quote) exact code locations, logs, or other sources. Don't trust my assertions, code comments, commit messages, or documentation blindly - verify against the code. If you use words like "likely", "maybe", or "could", you don't have enough information; pivot to improving observability instead of guessing.

**Evidence hierarchy**: Take only logs and code as hard evidence. Commit messages, PRs, comments, and documentation are circumstantial only - they describe intent or a past state, not what is actually true now.

**Root causes need proof**: When looking for a root cause, a plausible, self-consistent story isn't good enough. Find hard proof.

When I make an assertion like "this argument is unused", check for yourself and report. Proceed with changes only if you agree. Assume documentation is outdated unless you can find proof to the contrary.

Before proposing a bug fix, investigate git blame/history to understand the original intent. What looks like a bug might be dead code that should be deleted, or intentional behavior with non-obvious reasons.

**Verify current state, not just history**: Git history shows what *was* true, not what *is* true. When referencing mechanisms, configs, or patterns from git history, verify they still exist in the current codebase before presenting them as solutions.

When investigating, think aloud. Present your reasoning step by step. Don't just present conclusions.

## Problem solving

First, explain the affected code's role in the big picture as if addressing a new engineer who knows software but not this codebase.

Then present detailed analysis: link to exact locations (with line numbers), explain all circumstances (e.g., why a flaky test doesn't fail every time).

**Code links must be clickable**: Cite code as inline single-backtick `path:LINE` or `path:START-END`, using the full workspace-relative path so the link resolves unambiguously.

**Terminology precision**: When documenting findings about domain entities, verify the relationships in code before writing. Don't conflate entities or use casual language that obscures the actual data model.

When evaluating fixes:
- Consider impact on all callers
- Prioritize long-term maintainability; simpler is better; untangled is better than entangled
- Remove code for unused use cases; keep necessary ones
- Mention alternatives considered and why they didn't make the cut
- Don't settle for a locally-correct fix; weigh whole-system costs (maintenance burden, storage, ongoing upkeep of new artifacts like indexes) and prefer an existing path that avoids adding a new one. For example, a different table may already expose the values you need with the index already in place.

Explain the fix in detail, then explain how the problematic scenario behaves differently with the fix in place. Summarize the code changes and explain every thought that led to them.

**Verify theories incrementally**: When building explanatory theories for failures, explicitly verify each step before building on it. Present uncertainty: "I believe X because Y, let me verify Z before continuing." Don't construct elaborate multi-step theories without checkpoints.

**Stop on scope expansion**: When discovering unexpected callers, dependencies, or complexity during implementation, stop and report findings before continuing. Re-evaluate the plan together rather than charging ahead with an approach that may not work given the full picture.

**Gate plans on complexity**: When I don't give specific instructions and you devise a plan yourself, weigh its complexity. The more complex the plan, the more you should let me review it first to confirm it aligns with my wishes. For simple plans, go ahead directly.
