# Add user-installed commands to graphical and login sessions.
for path_dir in "$HOME/scripts" "$HOME/anaconda3/bin" "$HOME/.local/bin" "$HOME/bin"; do
  case ":$PATH:" in
    *":$path_dir:"*) ;;
    *) PATH="$path_dir:$PATH" ;;
  esac
done
export PATH
unset path_dir
