# Dotfiles

Personal shell, editor, terminal, and desktop configuration. Install `shc` and a C compiler, then run `./bootstrap` to build the CLI wrappers and link everything into your home directory.

## Ubuntu 26 installation

From this directory, as the intended user with passwordless sudo:

```sh
./scripts/ubuntudeps.sh
./bootstrap
```

Run the same commands again to repeat the setup. To upgrade the declared
packages and command-line helpers without relinking configuration or replaying
editor installation, run `./scripts/ubuntudeps.sh` and `./install-helpers` only.
The dependency script uses noninteractive apt, waits for a temporary package
lock, reports unavailable packages individually, keeps an installed Docker,
and does not autoremove packages or add Firefox/Git PPAs. Wezterm keeps its
declared Fury repository and becomes the user's XDG default terminal and the
system `x-terminal-emulator` alternative. Tailscale uses its official repository
for the installed Ubuntu release and installs the package only, leaving normal
package-maintainer service handling unchanged. It does not control the daemon,
enroll a device, reset or delete an existing identity, or supply an auth key.

Native Ubuntu libvirt, QEMU and virt-manager packages provide virtualization;
the daemon is enabled and the user joins `libvirt` and `kvm`. Use a fresh login
shell to exercise the new groups with `virsh -c qemu:///system list --all` and
`virsh -c qemu:///system capabilities`. GNOME remote-desktop, OpenSSL and native
Python GI/libsecret dependencies are included; remote access configuration is
separate. NVIDIA packages are skipped on machines without NVIDIA hardware;
otherwise Ubuntu's driver packages are used, not a CUDA repository for a
different Ubuntu release.

The bootstrap builds the wrappers, links personal configuration, installs Vim
plugins synchronously without a graphical window, and installs the defined
Python, Ruby, Node and Go helpers. Python editor packages live in
`~/.local/share/dotfiles/venv`, leaving the system Python untouched. Helper
commands are available through `~/.local/bin`. A tracked-file deployment with
no `.gitmodules` does not need Git metadata. The TypeScript language server
uses 5.3.0 for Ubuntu's Node version. `lua-fmt` is explicitly skipped because
Yarn cannot resolve its upstream dependency reference. Git LFS is installed
before plugin checkouts because the personal Git configuration enables its
filters and checkout hook. Tree-sitter uses its `master` branch to retain the
configured `configs.setup` API on Neovim 0.11; its rewritten `main` branch
requires Neovim 0.12 or newer. Neovim-only Lua setup, SOPS integration and
TokyoNight colors are limited to Neovim; Vim retains the shared Vimscript setup.

The bootstrap replaces home-directory configuration links. Run it only in the
user account being configured, not on another workstation. It does not set
GNOME display layouts, greeter settings or battery policy. Successful package
installation alone is not proof that wrappers, plugins or helpers ran; retain
the output of both commands and check those tools in a fresh login shell.
Check the selected terminal with `xdg-terminal-exec --print-id --print-cmd` and
its actual graphical launch. Observe Tailscale membership with
`tailscale status --json` read-only; preserve any existing identity and network
settings rather than changing them to meet an unenrolled-state check.

## Neovim on older Ubuntu releases

If Ubuntu's Neovim is too old for the editor configuration, run this before
`./bootstrap`:

```sh
./scripts/install-neovim-appimage.sh
```

The installer selects the Neovim release supported by the configured
Tree-sitter branch. It keeps the extracted binary and runtime together under
`~/software/neovim-appimage` and links `~/bin/nvim` to that installation,
without replacing package-managed files in `/usr`. Previous bundles remain
available to existing editors. New launches use the selected bundle; run
`hash -r` in an existing Bash shell to refresh its command paths.

After each coherent shared editor edit, immediately check the real local
configured startup and its messages, then the affected laptop startup.
`nvim --headless '+qa!'` uses the default configuration; exit 0 alone does not
prove success when startup errors were printed.

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
