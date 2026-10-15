#!/usr/bin/env bash
set -euo pipefail

ensure_symlink() {
    local dest=$1
    local target=$2
    local expected
    expected=$(readlink -f "$target")

    if [[ ! -d "$expected" ]]; then
        echo "$target is not a directory" >&2
        exit 1
    fi

    if [[ -L "$dest" ]]; then
        local actual
        actual=$(readlink -f "$dest" || true)
        if [[ "$actual" == "$expected" ]]; then
            return 0
        fi
        echo "$dest exists and is not a symlink to $expected" >&2
        exit 1
    fi

    if [[ -e "$dest" ]]; then
        echo "$dest exists and is not a symlink to $expected" >&2
        exit 1
    fi

    ln -s "$expected" "$dest"
}

mkdir -p "$HOME/.cursor"
ensure_symlink "$HOME/.cursor/rules" "$HOME/src/dotfiles/rules"
ensure_symlink "$HOME/.cursor/skills" "$HOME/src/dotfiles/skills"

mkdir -p "$HOME/.cursor/plugins/local"
if [[ ! -e "$HOME/.cursor/plugins/local/mstack" ]]; then
    gh repo clone mbertheau/mstack "$HOME/.cursor/plugins/local/mstack"
fi

humanlayer="$HOME/.cursor/plugins/local/humanlayer"
if [[ ! -e "$humanlayer/repo" ]]; then
    mkdir -p "$humanlayer"
    gh repo clone humanlayer/skills "$humanlayer/repo"
fi
mkdir -p "$humanlayer/skills" "$humanlayer/.cursor-plugin"
ensure_symlink "$humanlayer/skills/show-me" "$humanlayer/repo/plugins/show-me/skills/show-me"
ensure_symlink "$humanlayer/skills/visual-pr" "$humanlayer/repo/plugins/visual-pr/skills/visual-pr"
cat >"$humanlayer/.cursor-plugin/plugin.json" <<'EOF'
{
  "name": "humanlayer",
  "description": "show-me and visual-pr from humanlayer/skills",
  "skills": "./skills/"
}
EOF

# Published set from mattpocock/skills .claude-plugin/plugin.json.
# skills/in-progress and skills/misc are not part of that plugin.
mattpocock="$HOME/.cursor/plugins/local/mattpocock-skills"
repo="$mattpocock/repo"
if [[ ! -e "$repo" ]]; then
    mkdir -p "$mattpocock"
    gh repo clone mattpocock/skills "$repo"
fi
mkdir -p "$mattpocock/skills" "$mattpocock/.cursor-plugin"
for rel in \
    engineering/ask-matt \
    engineering/diagnosing-bugs \
    engineering/grill-with-docs \
    engineering/triage \
    engineering/improve-codebase-architecture \
    engineering/setup-matt-pocock-skills \
    engineering/tdd \
    engineering/to-spec \
    engineering/to-tickets \
    engineering/wayfinder \
    engineering/implement \
    engineering/implement-spec \
    engineering/prototype \
    engineering/research \
    engineering/domain-modeling \
    engineering/codebase-design \
    engineering/code-review \
    engineering/pr \
    engineering/retro \
    engineering/wizard \
    productivity/grill-me \
    productivity/grilling \
    productivity/handoff \
    productivity/teach \
    productivity/to-questionnaire \
    productivity/wait-what \
    productivity/writing-for-agents
do
    ensure_symlink "$mattpocock/skills/${rel##*/}" "$repo/skills/$rel"
done

# Writing a PR body matches this skill's description on its own, so Cursor
# would load it unasked. Keep it slash-only.
python3 - "$repo/skills/engineering/pr/SKILL.md" <<'PY'
import pathlib, sys

path = pathlib.Path(sys.argv[1])
text = path.read_text()
parts = text.split("---", 2)
if len(parts) < 3:
    raise SystemExit(f"{path} has no frontmatter")
frontmatter = parts[1]
if "disable-model-invocation:" in frontmatter:
    raise SystemExit(0)
lines = frontmatter.splitlines(keepends=True)
rewritten = []
inserted = False
for line in lines:
    rewritten.append(line)
    if not inserted and line.startswith("description:"):
        rewritten.append("disable-model-invocation: true\n")
        inserted = True
if not inserted:
    raise SystemExit(f"{path} frontmatter has no description")
path.write_text("---".join((parts[0], "".join(rewritten), parts[2])))
PY

cat >"$mattpocock/.cursor-plugin/plugin.json" <<'EOF'
{
  "name": "mattpocock-skills",
  "description": "Matt Pocock's engineering and productivity skills",
  "skills": "./skills/"
}
EOF
