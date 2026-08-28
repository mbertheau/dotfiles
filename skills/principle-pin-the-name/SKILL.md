---
name: principle-pin-the-name
description: Apply when choosing or reviewing names for modules, files, types, functions, or variables, and when a name is generic, overloaded, clever, uncommented-but-opaque, borrowed from a wider domain, or stale after the domain model changed. Choose a domain hierarchy that fits this subject tightly, place each technical name on one of its nodes, and keep one name per concept.
metadata:
  type: principle
---

# Pin the Name

A name places a technical entity on one node of a conceptual hierarchy. Write the name so a reader who lands in the middle can recover that node and the adjacent path.

**Why:** Programs are made of directories, modules, files, types, functions, variables, and constants. That technical nesting is given. Subject domains are made of conceptual entities that also nest, and several domain trees can usually be projected onto the same technical entities. Everyday domain words collapse heights. Code cannot. An unplaced or collapsed name, or a name pinned to the wrong tree, forces the reader to rebuild the subject from scratch, and they will rebuild it wrong.

**Choose the domain tree.** Conceptual nesting is not technical nesting, and it is not unique. Git-the-implementation names repository, object store, commit, ref, peel. A git-flow tool names feature line, release line, hotfix, production tip. Both talk about "branches" and "commits"; they are not the same hierarchy. Pick the tree that covers this subject domain and not much more. A generic git vocabulary inside a git-flow module is an imported, undersized tree — it refuses nodes the subject actually has. A git-flow vocabulary inside git itself is an oversized tree — it names nodes this subject does not own. Names inherit the chosen tree. If the tree is wrong, every name is misplaced even when internally consistent.

A faithful name does not fix a file that sits across two nodes of the *chosen* tree. If the name needs a slash of unrelated concepts, or if no honest name fits, the technical entity is two concepts wearing one name — split it. Breaking the concept may reach schema, APIs, and call sites; that cost is cheaper than a permanent lie.

## Place the name

- Name the *node and its purpose*, not the mechanism or the current implementation. `featureBranchTip` is a commit marked as the tip of a line of work. `ref` is a mechanism. `stripAndCollapseSpaces` is an implementation; `normalizeWhitespace` is the purpose. `data` is no node at all.
- Pin the height. If a domain word names several nodes (`branch` as marker vs `branch` as lineage), pick one sense inside this context and keep it. Do not let the word float.
- Assume only the familiarity this boundary may demand. Public surface uses widely shared problem-domain language. A team module may use team language and solution-domain words (`Tree`, `Observer`, `Node`). A local variable may use whatever the enclosing function already fixed. Over-assuming (team slang on a public function) and under-assuming (generic CS words inside a domain-heavy module) are both failures to place.
- Repeat some of the immediately adjacent path. Readers do not start at the top of the file. A name that restates the neighboring node (`baseCommit`, not `base`; `featureBranch`, not `branch`) lets them look in the right place and reassemble the tree. That overlap is how you pin height when the surrounding scope is not yet in view. Do not repeat the whole path. Do not omit the adjacent step.
- Use the part of speech the node requires. Types, modules, and objects are nouns or noun phrases. Functions and methods are verbs or verb phrases, including side effects. A verb class or a noun function is usually a misplaced node.

## Keep one mapping

- One concept, one name. One name, one concept. Pick a canonical word and stop using its synonyms (`get` vs `fetch`, `start` vs `begin`). Consistency is the cheapest principle and the most expensive to violate, because every alias poisons search and understandability.
- If two names are almost the same (`ProductInfo` / `ProductData`, `account` / `account2`), they are either the same node or a distinction you have not named. Merge them or make the difference speak.
- Reveal intent. The name should say why the entity exists, what it does, and how it is used. If a comment is required to decode it, the name failed.
- Do not disinform. Do not call a grouping `accountList` unless it is a List. Do not encode type, scope, or Hungarian prefixes into the name in a language that already has types. Do not use a word whose entrenched meaning is not the node you mean.
- Stay austere. No jokes, puns, temporary metaphors, or private mythology (`HolyHandGrenade`, taps/kegs/casks, FIST/ARMS). A name that needs a glossary entry *inside* the module that coined it is too clever for that boundary. Glossaries belong at team or public boundaries, and only for terms the domain already owns.

## Fit the boundary

- Neither too vague nor too specific, neither a telegram nor a sentence. Specificity and length are judged against the radius of the boundary, not against an absolute count.
- Make the name pronounceable and searchable. If you cannot say it in a review, or cannot grep it without drowning in noise, it is not pinned for a team.
- Overlap at boundaries is useful. A name just inside a module and a name just outside it should share enough path that a reader can cross without translating. They should not share so much that the boundary disappears.

## Move the name when the tree moves

- A stale name is a broken mapping, not a historical monument. Rename in the same change that relocates the concept, including the change that switches which domain tree this code is serving.
- Make renaming cheap and routine. Principles rot as the software evolves; the correct state is consistently correct, not historically stable.
- When a principle is already violated, fix the name or split the concept. Do not add a second name beside the first.

## Failure modes

- *Unplaced* — attaches to no conceptual node (`data`, `info`, `manager`, `util`, `tmp`, `handle`, `process` as a public name).
- *Wrong tree* — consistent with a neighboring or more generic domain, not this one (raw `ref` language in a git-flow module; `hotfix` / `develop` language in git itself).
- *Oversized tree* — the chosen hierarchy names nodes this subject does not own.
- *Undersized tree* — the chosen hierarchy cannot place entities the subject actually has.
- *Misplaced* — attaches to the wrong node of an otherwise fitting tree (`branch` when the value is a tip commit).
- *Collapsed* — one name for two heights of the same tree, or two concepts sharing one name.
- *Aliased* — two names for one concept.
- *Disinformed* — the word means something else in the language, the platform, or the domain.
- *Implementation-bound* — names the current algorithm instead of the purpose; will lie after the next rewrite.
- *Over-assumed* — requires knowledge outside this boundary's radius, including in-jokes and team slang on a public surface.
- *Under-assumed* — refuses domain language the reader at this boundary already has.
- *Over-specified* — repeats path the immediate scope has already fixed *and* that a mid-file reader cannot miss.
- *Under-specified* — omits the adjacent step a mid-file reader needs in order to rejoin the tree.
- *Cute* — clever, metaphorical, or encoded so that even module locals need a legend.
- *Unspeakable / unsearchable* — cannot be said or found.
- *Stale* — the domain node moved; the technical name did not.

## The test

Point at the name and say which subject domain you chose, why that tree fits tightly, which conceptual node the name is, which parent it sits under, which purpose it names (not which mechanism), and which familiarity the reader is allowed. If you cannot, if a wider or neighboring tree fits just as well, if two heights both fit, if a second name already means the same node, or if a comment is doing the name's job, the name is not pinned.
