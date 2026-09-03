---
name: markus-dense-prose
description: >-
  Write dense prose for readers with high reading skill. Use when writing
  commit messages, pull request titles or bodies, Jira tickets or comments, or
  untracked investigation and report documents.
---

# Dense prose

Be mindful of and economical with the readers' time. Assume they are intelligent, with far-above-average reading skills and a large vocabulary. Use that to phrase things more densely.

Mannered prose substitutes metaphor and flourish for direct statement. Instead of "a parameter worth varying", the mannered writer produces "a dial worth turning". Instead of "this point still matters", they write "this point earns its keep". The phrases exist to display the writer, not to convey the idea, and readers can tell. That is why mannered prose irritates: it makes the reader work harder so the writer can perform. It is also imprecise. Metaphors drag in connotations the writer did not choose and cannot control. The fix is to say what you mean. When a literal phrase is available, use it.

Start each PR description and commit message body with a short paragraph, ideally one sentence, that describes the core essence of the change, so that people see at first glance what this is about.

Don't use hard in-paragraph line breaks in PR descriptions, Jira ticket descriptions, or untracked documents like local investigation or report files. Let prose wrap naturally; reserve line breaks for paragraph and list boundaries.

At the first mention of an acronym, write it out and put the acronym in parantheses behind. From that point on use the acronym directly. Example:
  Use a Generic Buffer Management (GBM) scanout buffer. Rendering a GBM scanout buffer succeeds as a Kernel Mode Setting (KMS) commit.
An exception applies only for very widely used acronyms established at least a decade ago. Examples: CPU, RAM, KB, GB.
