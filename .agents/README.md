# Agent skills

Snapshot of `~/.agents/skills` (shared agent skills for Cursor, Codex, Cline, OpenCode, Zed, Grok, etc.).

## Restore

```bash
mkdir -p ~/.agents
rsync -a .agents/skills/ ~/.agents/skills/
# optional lock file for npx skills
cp .agents/.skill-lock.json ~/.agents/.skill-lock.json
```

Or symlink:

```bash
mkdir -p ~/.agents
ln -sfn "$PWD/.agents/skills" ~/.agents/skills
```
