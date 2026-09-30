# Dotfiles

Personal shell, editor, terminal, and desktop configuration. Install `shc` and a C compiler, then run `./bootstrap` to build the CLI wrappers and link everything into your home directory.

## Desktop and shell startup

On i3 login, a plain terminal opens on `4:tmux`; no default tmux session is
created. Run `tmux-sessionizer` (or `ts` in interactive Bash) to choose a project.

`.profile` sets graphical-login command paths without loading Bash bindings or
completions. User commands take priority in this order: `~/scripts`, `~/bin`,
`~/.local/bin`, then `~/anaconda3/bin`. Interactive Bash still loads `.alias`.
SSH shells default to `DISPLAY=:0` only when no display was supplied; local i3
and SSH-forwarded displays are preserved. Use `ssh -t` when attaching tmux via
an SSH command, since tmux needs a terminal rather than just an X display.

## GitHub and GitLab CLIs

The installed `gh` and `glab` wrappers allow reads but deny common remote modifications by default. After receiving explicit permission, authorize one command with:

```sh
REPO_WRITE_AUTHORIZED=1 gh <command>
REPO_WRITE_AUTHORIZED=1 glab <command>
```

Regular `git` commands are unaffected.
