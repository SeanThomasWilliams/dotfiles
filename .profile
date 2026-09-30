# Keep graphical login setup POSIX-compatible; interactive Bash loads .alias.
# Prepend in reverse priority, matching .alias: scripts, bin, then .local/bin.
for path_dir in "$HOME/anaconda3/bin" "$HOME/.local/bin" "$HOME/bin" "$HOME/scripts"; do
  if [ -d "$path_dir" ]; then
    PATH="$path_dir:$PATH"
  fi
done
PATH=$(printf '%s' "$PATH" | awk -v RS=: '
  length($0) && !seen[$0]++ {
    if (out != "") out = out ":"
    out = out $0
  }
  END { print out }
')
export PATH
unset path_dir

# Use the usual desktop display for SSH without overriding X forwarding or i3.
if [ -n "${SSH_CONNECTION-}${SSH_CLIENT-}" ] && [ -z "${DISPLAY-}" ]; then
  export DISPLAY=:0
fi
