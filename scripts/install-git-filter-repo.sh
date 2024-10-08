#!/bin/bash

set -eux

mkdir -p "$HOME/software"
cd "$HOME/software"

sudo rm -rf "$HOME/software/git-filter-repo" \
  "$(git --exec-path)/git-filter-repo" \
  "$(git --man-path)/man1/git-filter-repo" \
  "$(git --html-path)/git-filter-repo.html" \
  "$(python -c "import site; print(site.getsitepackages()[-1])")/git_filter_repo.py"

git clone https://github.com/newren/git-filter-repo
cd git-filter-repo
make snag_docs

sudo cp -a git-filter-repo "$(git --exec-path)"
sudo cp -a Documentation/man1/git-filter-repo.1 "$(git --man-path)/man1"
sudo cp -a Documentation/html/git-filter-repo.html "$(git --html-path)"
sudo ln -s "$(git --exec-path)/git-filter-repo" \
    "$(python -c "import site; print(site.getsitepackages()[-1])")/git_filter_repo.py"
