# Grok user skills

Snapshot of `~/.grok/skills` (Grok Build / Grok CLI user-scoped skills).

## Restore

```bash
mkdir -p ~/.grok
rsync -a .grok/skills/ ~/.grok/skills/
```

Or symlink:

```bash
mkdir -p ~/.grok
ln -sfn "$PWD/.grok/skills" ~/.grok/skills
```

Note: Grok also ships bundled skills under `~/.grok/bundled/skills/` (not tracked here).
