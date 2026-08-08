# Yazi config

Plugins are locked in `package.toml` and live under `plugins/`.

## Fresh install

```bash
# after `brew install yazi` (or package manager)
mkdir -p ~/.config/yazi
rsync -a .config/yazi/ ~/.config/yazi/
ya pkg install   # restore plugins from package.toml
```

## Notable plugins

| Plugin | Source | Key |
|--------|--------|-----|
| what-size | `pirafrank/what-size` | `.` then `s` |
| git | `yazi-rs/plugins:git` | (status signs) |
| smart-enter | `yazi-rs/plugins:smart-enter` | `l` / Enter |
| smart-paste | `yazi-rs/plugins:smart-paste` | `p` |
| smart-filter | `yazi-rs/plugins:smart-filter` | `F` |
| full-border | `yazi-rs/plugins:full-border` | (UI) |
| chmod | `yazi-rs/plugins:chmod` | `c` `m` |
| toggle-pane | `yazi-rs/plugins:toggle-pane` | `T` |
| mount | `yazi-rs/plugins:mount` | `M` |
| diff | `yazi-rs/plugins:diff` | `D` |
| zoom | `yazi-rs/plugins:zoom` | `+` / `-` |
| jump-to-char | `yazi-rs/plugins:jump-to-char` | `f` |
| mactag | `yazi-rs/plugins:mactag` | `t` `a` / `t` `r` |
| piper | `yazi-rs/plugins:piper` | (preview helper) |
