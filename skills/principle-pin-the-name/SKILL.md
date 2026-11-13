---
name: principle-pin-the-name
description: Apply when choosing or reviewing names for modules, files, types, functions, or variables, and when a name is generic, overloaded, clever, uncommented-but-opaque, borrowed from everyday speech or a wider domain, or stale after the domain model changed. Choose the objects, attributes, and relationships that fit this subject, place each technical name on one of them, and keep one name per concept.
metadata:
  type: principle
---

# Pin the Name

A name pins a technical entity to one object, attribute, or relationship in a domain model, so a mid-file reader can recover which it is and what it belongs to.

**Why:** Programs are made of directories, modules, files, types, functions, variables, and constants. The domain is objects, their attributes, and the relationships between them. Everyday words collapse the three into one; a name cannot. An unplaced or collapsed name, or a name on the wrong model, makes the reader rebuild the subject wrong.

**Choose the domain model.** Several models can cover the same code, and the model is not the technical structure. Git-the-implementation names repository, object store, commit, ref, peel. A git-flow tool names feature line, release line, hotfix, production tip. Both talk about "branches" and "commits"; they are not the same model. Pick the one that covers this subject and not much more. Generic git words in a git-flow module are an imported, undersized model: they cannot name a feature line or a hotfix. Git-flow words in git are oversized: they name a hotfix git does not own. A wrong model misplaces every name that inherits it, consistency included.

A faithful name does not fix an entity spread across two objects, or an object and an unrelated attribute, of the *chosen* model. A slash of unrelated concepts, or no honest name, means two concepts are wearing one name — split it. Schema, APIs, and call sites are cheaper than a permanent lie.

## Place the name

- Name the object, attribute, or relationship and its purpose, not the mechanism or the implementation. `featureBranchTip` is the commit at the tip of a feature line. `ref` is a mechanism. `stripAndCollapseSpaces` is an implementation; `normalizeWhitespace` is the purpose. `data` names nothing in the model.
- Pin the referent. If a word can name more than one thing (`branch` as the marker vs `branch` as the lineage), pick one sense in this context and keep it. Do not let the word float.
- Assume only the familiarity this boundary may demand. Public names use problem-domain language. A team module may add team language and solution-domain words (`Tree`, `Observer`, `Node`). A local variable may use what the enclosing function already fixed. Slang on a public name, and generic CS words in a domain module, both fail to place.
- Repeat the adjacent object or relationship. Readers do not start at the top of the file. `baseCommit`, not `base`; `featureBranch`, not `branch`. Do not repeat the whole chain or omit the adjacent step.
- Use the part of speech required. Objects, types, modules, and attributes are nouns. Relationships are nouns or verb phrases. Functions and methods are verbs or verb phrases, including side effects. A verb class or a noun function is the wrong kind of thing.

## Keep one mapping

- One concept, one name. One name, one concept. Pick a canonical word and stop using its synonyms (`get` vs `fetch`, `start` vs `begin`). Every alias poisons search and understanding.
- If two names are almost the same (`ProductInfo` / `ProductData`, `account` / `account2`), they are the same referent, or a distinction you have not named. Merge them or make the difference speak.
- The name should say why the entity exists, what it does, and how it is used. If a comment is required to decode it, the name failed.
- Do not disinform. Do not call a grouping `accountList` unless it is a List. Do not encode type, scope, or Hungarian prefixes into the name in a language that already has types. The entrenched meaning is honest when it maps onto this referent. It lies when the reader arrives at a different referent: the wrong type, a platform term, or something else already in this domain.
- Stay austere. No jokes, puns, temporary metaphors, or private mythology (`HolyHandGrenade`, taps/kegs/casks, FIST/ARMS). A name that needs a glossary entry *inside* the module that coined it is too clever for that boundary. Glossaries belong at team or public boundaries, and only for terms the domain already owns. Borrow a vivid everyday word when the meaning transfers and the domain has no competing referent. In taiwan-eyes, an Android app for learning to read Traditional Chinese from photos, `crowdedness` is a photo attribute: how many characters the photo contains. 3 is not much, 60 is a lot, and it drives difficulty. The meaning transfers: a crowded space is full of people, and a crowded photo is full of characters. No competing referent: the app has no crowds of people. Taps, kegs, and casks need a legend. Everyday language alone, or a legend: that is the line.

## Fit the boundary

- Neither too vague nor too specific, neither a telegram nor a sentence. Specificity and length are judged against the radius of the boundary, not against an absolute count.
- Make the name pronounceable and searchable. If you cannot say it in a review, or cannot grep it without drowning in noise, it is not pinned for a team.
- Overlap at boundaries is useful. Names just inside a module and just outside it should share enough that a reader can cross without translating, and not so much that the boundary disappears.

## Move the name when the model moves

- A stale name is a broken mapping, not a historical monument. Rename in the same change that relocates the concept, including a switch of domain model.
- Make renaming cheap and routine. Principles rot as the software evolves; the correct state is consistently correct, not historically stable.
- When a principle is already violated, fix the name or split the concept. Do not add a second name beside the first.

## Failure modes

- *Unplaced* — no object, attribute, or relationship (`data`, `info`, `manager`, `util`, `tmp`, `handle`, `process` as a public name).
- *Wrong model* — a neighboring or more generic domain (raw `ref` in a git-flow module; `hotfix` / `develop` in git itself).
- *Oversized model* — names what this subject does not own.
- *Undersized model* — cannot place what the subject actually has.
- *Misplaced* — wrong referent in a fitting model (`branch` when the value is a tip commit).
- *Collapsed* — one name for two things the model keeps apart.
- *Aliased* — two names for one concept.
- *Disinformed* — entrenched meaning lands on a different referent the reader could reach (wrong type, platform term, or something else already there). A sense that maps here is not this.
- *Implementation-bound* — names the algorithm instead of the purpose, and lies after the next rewrite.
- *Over-assumed* — needs knowledge outside this boundary, such as slang on a public surface.
- *Under-assumed* — refuses domain language the reader here already has.
- *Over-specified* — repeats an adjacent object the scope and a mid-file reader already have.
- *Under-specified* — omits the adjacent object or relationship needed to rejoin the model.
- *Cute* — locals need a legend (joke, pun, encoding, temporary metaphor, private mythology). Transfer with no competing referent is not this.
- *Unspeakable / unsearchable* — cannot be said or found.
- *Stale* — the referent moved; the name did not.

## The test

Point at the name and say which model you chose and why it fits, whether it is an object, an attribute, or a relationship, what it belongs to or connects, which purpose it names, and which familiarity the reader is allowed. For a borrowed word, say how it transfers and what competing referent is absent. If you cannot, if another model, referent, or name also fits, or if a legend or a comment is required, the name is not pinned.
