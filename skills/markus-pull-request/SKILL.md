---
name: markus-pull-request
description: >-
  Open and update GitHub pull requests using Markus's conventions. Use when
  creating a PR, updating a PR title or description, reading or acting on
  review comments, or choosing between the GitHub MCP and the gh CLI.
---

# Pull requests

Also follow `markus-dense-prose` for the title and body.

- Use `gh pr create`, always as draft first
- **Title**: Same principle as commit messages.
- Include ticket references in body on their own lines: `[TICKET-1234]`
- Never include a test plan
- Update title and description when scope changes

## GitHub access

Use the GitHub MCP for read-only access to GitHub. Use the gh CLI tool for write access.

### PR comments and reviews

Use `gh monitor` to work with review comments.

```bash
gh monitor review view PR_NUMBER
gh monitor --help
```
