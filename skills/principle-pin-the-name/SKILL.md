---
name: principle-pin-the-name
description: Apply when choosing or reviewing names for modules, files, types, functions, or variables, and when a name is generic, overloaded, or stale after the domain model changed. Place each technical name on one node of the conceptual hierarchy.
metadata:
  type: principle
---

# Pin the Name

A name places a technical entity on one node of a conceptual hierarchy. Write the name so a reader who lands in the middle can recover that node and the adjacent path.

**Why:** Programs are made of directories, modules, files, types, functions, variables, and constants. Subject domains are made of conceptual entities that nest. Git is the stock example — repository, commit DAG, commit, branch-as-marker, branch-as-line-of-work, `main` as the distinguished line. Everyday domain words collapse those heights. Code cannot. An unplaced or collapsed name forces the reader to rebuild the tree from scratch, and they will rebuild it wrong.

**Two hierarchies.** Conceptual nesting is not technical nesting. A faithful name does not fix a file that sits across two domain nodes. If the name needs a slash of unrelated concepts, split the technical entity.

**The pattern:**

- Name the *node*, not the mechanism. `featureBranchTip` is a commit marked as the tip of a line of work. `ref` is a mechanism. `data` is no node at all.
- Pin the height. If a domain word names several nodes (`branch` as marker vs `branch` as lineage), pick one sense inside this context and keep it. Do not let the word float.
- Assume only the familiarity this boundary may demand. Public surface uses widely shared domain language. A team module may use team language. A local variable may use whatever the enclosing function already fixed. Over-assuming (team slang on a public function) and under-assuming (generic CS words inside a domain-heavy module) are both failures to place.
- Repeat some of the immediately adjacent path. Readers do not start at the top of the file. A name that restates the neighboring node (`baseCommit`, not `base`; `featureBranch`, not `branch`) lets them look in the right place and reassemble the tree. That overlap is how you pin height when the surrounding scope is not yet in view. Do not repeat the whole path. Do not omit the adjacent step.
- When the conceptual hierarchy moves, the names move with it. A stale name is a broken mapping, not a historical monument. Rename in the same change that relocates the concept.

**Overlap at boundaries is useful.** A name just inside a module and a name just outside it should share enough path that a reader can cross the boundary without translating. They should not share so much that the boundary disappears.

**Failure modes:**

- *Unplaced* — attaches to no conceptual node (`data`, `info`, `manager`, `util`, `tmp` as a public name).
- *Misplaced* — attaches to the wrong node (`branch` when the value is a tip commit).
- *Collapsed* — one name for two heights of the same tree.
- *Over-assumed* — requires knowledge outside this boundary's radius.
- *Under-assumed* — refuses domain language the reader at this boundary already has.
- *Over-specified* — repeats path the immediate scope has already fixed *and* that a mid-file reader cannot miss.
- *Under-specified* — omits the adjacent step a mid-file reader needs in order to rejoin the tree.
- *Stale* — the domain node moved; the technical name did not.

**The test:** Point at the name and say which conceptual node it is, which parent it sits under, and which familiarity the reader is allowed. If you cannot, or if two heights both fit, the name is not pinned.
