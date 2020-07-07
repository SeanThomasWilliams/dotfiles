#!/bin/bash -ex

mkdir -p "$HOME/bin"

curl -sL "https://github.com/nelsonenzo/tmux-appimage/releases/download/3.0a-appimage0.1.0/tmux-3.0a-x86_64.AppImage" \
  -o "$HOME/bin/tmux.temp"

chmod u+x "$HOME/bin/tmux.temp"
mv -v "$HOME/bin/tmux.temp" "$HOME/bin/tmux"
"$HOME/bin/tmux" -V
