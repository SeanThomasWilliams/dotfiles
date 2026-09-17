# Dotfiles

Personal shell, editor, terminal, and desktop configuration. Install `shc` and a C compiler, then run `./bootstrap` to build the CLI wrappers and link everything into your home directory.

## GitHub and GitLab CLIs

The installed `gh` and `glab` wrappers allow reads but deny common remote modifications by default. After receiving explicit permission, authorize one command with:

```sh
REPO_WRITE_AUTHORIZED=1 gh <command>
REPO_WRITE_AUTHORIZED=1 glab <command>
```

Regular `git` commands are unaffected.
