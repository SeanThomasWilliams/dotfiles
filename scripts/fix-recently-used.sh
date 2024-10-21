#!/usr/bin/env bash

# Remove recently-used.xbel and make it immutable
mkdir -p ~/.local/share
if [[ -f ~/.local/share/recently-used.xbel ]]; then
  sudo chattr -i ~/.local/share/recently-used.xbel
  rm -f ~/.local/share/recently-used.xbel
fi

true > ~/.local/share/recently-used.xbel
sudo chattr +i ~/.local/share/recently-used.xbel
