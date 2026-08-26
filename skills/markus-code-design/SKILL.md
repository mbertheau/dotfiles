---
name: markus-code-design
description: >-
  Apply Markus's code design values when writing, editing, refactoring, or
  designing application code. Use when implementing features, changing existing
  code, choosing abstractions, naming, writing comments or docstrings, adding
  metrics or alerts, or making type-narrowing assertions.
---

# Code Design

## Guiding principle

Optimize for the person reading the code six months from now—including yourself. That reader doesn't remember what abstractions you created or why. They have to reconstruct the data flow by reading the code. They will be frustrated by indirection that serves no purpose and helped by code that says what it does directly.

This implies a distrust of "architecture astronautics"—elaborate structures built in anticipation of needs that may never materialize. Prefer straightforward code now over "flexible" code that imagines future requirements.

## Core values

**Explicitness over implicitness**: Make dependencies and data flow visible in the code structure. Prefer passing state explicitly over hiding it in object internals. A reader should understand what a piece of code depends on by looking at it, not by tracing through class hierarchies.

  *Examples*: Functions that take state as arguments rather than methods accessing `self`. Direct field access rather than properties that hide what's happening. Pass only what's used: `foo(user.email)` over `foo(user)` if only email is needed—the signature documents the dependency.

**Abstractions must earn their place**: Every abstraction—class, method, named constant—adds cognitive load. Apply a cost-benefit test: does this name or structure add understanding, or just indirection? Delete what doesn't pay for itself.

  *Examples*: Inline trivial helpers whose names don't add clarity. Delete wrapper classes that only delegate. Remove docstrings that restate obvious code.

**Data and functions over objects with methods**: Prefer simple data containers (dataclasses) for state, with standalone functions that operate on them. This keeps data inspectable and behavior composable. Use classes when they genuinely help (polymorphism, resource management), not as the default unit of organization.

**Simplest mechanism that works**: Reach for sophisticated tools (regex, generics, metaprogramming) only when simpler alternatives fall short. A substring check is clearer than a regex when both work. Direct field access is clearer than a property when there's no logic.

**I/O at the boundaries**: Keep core logic pure—operating on data passed in, returning results. Push I/O (files, network, database) to entry points and edges. This makes the core testable via simple function calls with test data, without mocking.

## Simplicity

Question each piece of complexity: Why does this need a wrapper function? Why compute a default when the caller can pass it? Why return a value if no one uses it? If the answer isn't compelling, remove the complexity.

**Variable lifetime as extraction signal**: If a variable is created, used in 2-3 lines, then sits unused for the rest of the function, that's a candidate for extraction. The extracted function contains the short-lived variables, returning only what the caller needs.

When creating multiple similar functions or methods, consider if they can be unified. A single function with an optional return value or parameter is often simpler than two near-duplicate functions.

## Naming

When naming things, build up the terminology in a structured way: From root to leaf, identify entities the code is dealing with, what they are and what they should be called.

For metrics and alerts, prefer names that describe *what* is measured, not *when*. Avoid embedding context like "renewal" or "completion" unless the metric truly only applies there. General names allow reuse across similar scenarios.

## Return values

Prefer richer types (intervals, counts, timestamps) over booleans when the underlying data is richer. This gives callers flexibility.

## Additional design considerations

- **Readability over cleverness**: optimize for straightforward, linear logic that a new engineer can follow quickly.
- **Robustness to messy inputs**: tolerate malformed or partial external input without cascading failures; degrade gracefully rather than failing hard.
- **Maintainability through clear boundaries**: prefer code organization that localizes change and keeps responsibilities distinct.
- Keep control flow linear and explicit; avoid indirection when a direct branch is clearer.
- Name important constants rather than scattering literals.

## Observability

Before adding new metrics or alerts, check if existing ones can be generalized to cover the new use case. Fewer, more general metrics are easier to maintain. Only add observability for known problems or likely failure modes - no speculative "just in case" metrics.

## Comments

Don't add comments that narrate what the code does, restate obvious code, or reference instructions or decisions from our chat. Don't add comments explaining the change itself—the commit message and git history cover that. Reserve comments for non-obvious intent, trade-offs, or constraints the code can't convey.

**Document contracts, not callers**: A function's docstring and comments describe its own behavior, parameters, and invariants—never who calls it or why a particular caller uses it a certain way. Naming callers inside the callee rots the moment a caller changes, is renamed, or disappears, and nobody thinks to update it. Caller-specific rationale belongs at that caller's call site, where it stays accurate and where the reader is actually asking "why here?". Don't enumerate callers or spell out per-caller/per-scenario behavior inside the function; state the general rule once.

**Be terse**: Prefer the shortest comment that conveys the non-obvious point. Don't repeat a fact in both the docstring and an inline comment. If a docstring or comment is growing into several sentences that walk through mechanics a reader can see in the code, that is a signal to cut it down, not to keep explaining.

## Type-narrowing assertions

When using assertions purely for mypy type narrowing (where the condition is already validated at the call site), add a comment explaining that the assertion is never false and why, and that it exists only for mypy. Don't add an assertion message—messages suggest the assertion might fail in production.
