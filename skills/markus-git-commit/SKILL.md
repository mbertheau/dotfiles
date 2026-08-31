---
name: markus-git-commit
description: >-
  Create commits, name branches, and push using Markus's commit conventions.
  Use when committing, splitting or arranging commits, executing an agreed
  multi-commit plan, naming a branch, or pushing.
---

# Git commit

Also follow `markus-dense-prose` for the message.

## Commit conventions

- **Include the "why"**: The body should explain the *motivation* as well. Headlines like "Enable shorter lease durations" are better than "Add renew() method". A technical aspect like "add function X" is not a valid motivation—the function existing isn't an end in itself. If there's no clear, single motivation for a commit, that's a hint the changes are arranged into commits incorrectly.
- **Scale the "why" to what the diff hides, not to the size of the change**: How much explanation a commit needs depends on how much of the motivation a competent reader can reconstruct from the diff and the surrounding code—not on how many lines changed. A one-line change deserves a long explanation when its reason lives outside the tree (a production incident, a measurement, a vendor bug, a spec or legal requirement) or is surprising enough that someone would otherwise "simplify" it back and reintroduce the problem. A large mechanical change may need almost nothing when the diff speaks for itself. Calibrate by the cost of the reader not knowing: the likelier they are to revert, misuse, or duplicate the change, the more the message must carry. Never spend words restating what the diff already shows, or defending editorial choices nobody questioned.
- **Analyze pros and cons**: Identify the benefits and drawbacks of the change. Verify their technical merit—both in theory and practice. A practical consequence (observed in testing or production) weighs more than a theoretical one. Be honest: don't overstate the problem being solved or claim benefits that are merely theoretical.
- **Acknowledge tradeoffs**: If the change has downsides, state them. Summarize what values guided the judgment to make the change despite the cons (e.g., "readability outweighs the minor verbosity increase").
- **Explain what/how**: After establishing the motivation and tradeoffs, describe the new behavior or mechanism if it helps the reviewer understand and judge the changes. Document behavior explicitly when callers need to know (e.g., return value semantics).
- Each message must stand alone - no references to "the last commit" or similar
- Commit messages must be understandable without additional context - somebody will look at the commit message in, say, the git history for a file and will not have the PR or a Jira ticket or the preceding and following commits available for context.
- **Never mix refactoring with features**: Even trivial-looking refactoring (moving code, renaming) must be a separate commit from feature work. Mixed commits make review harder and git archaeology less useful. When tempted to make a cosmetic change alongside functional changes, propose it separately rather than just doing it.
- **Coherent commits**: Each commit should contain changes that logically belong together by purpose, not by "used together later." A DB function and a constant that happen to both be needed by later code don't belong in the same commit unless they serve the same purpose.
- **Order commits for clean diffs**: When multiple refactorings interact, order them so simpler/foundational ones come first. This makes each commit's diff smaller and easier to review.
- **Minimize diff noise**: Keep unchanged functions in their original file positions when possible. Avoid renaming, reordering, or reformatting code that isn't directly related to the change.
- **Keep commit messages accurate**: After significant implementation changes during development, re-read the commit message to ensure it still accurately describes what the commit does.
- **Commit at planned boundaries without re-asking**: When we've agreed on a multi-commit plan and I've given a go-ahead, treat that as standing authorization to commit each unit as soon as its changes are complete and verified. Commit before touching the next unit's changes—never let changes belonging to two planned commits accumulate uncommitted in the working tree at once. The go-ahead on the plan is the explicit permission; don't wait for a per-commit prompt. If you're unsure whether a change belongs to the current unit or the next, stop and ask rather than lumping them together.
- Reference ticket IDs at the end: `During [TICKET-1234]`, `For [TICKET-1234]`, or just `[TICKET-1234]`
- **Branch naming**: `mbertheau-<TICKET>-short-description`
- **Branch config**: Set `origin/main` as upstream, `origin` as pushremote

## Git write operations

- Use non-interactive git commands: `GIT_SEQUENCE_EDITOR` or `GIT_EDITOR=true`
- Don't use `git show --no-stat` (unsupported)
- Don't use `git add -A` (many untracked files in worktree)
- Before committing, provide a summary of the changes
- Use explicit remote/branch when pushing: `git push origin <branch> --force-with-lease`
- Run history rewrites one command at a time and inspect between them. When a late correction belongs to an earlier commit, use `git commit --fixup=amend:<sha>` plus one autosquash rebase instead of `reset --soft` then `commit --amend`. If that rebase would hit a non-trivial conflict, rewind history and apply the correction directly in the erroneous commit.
