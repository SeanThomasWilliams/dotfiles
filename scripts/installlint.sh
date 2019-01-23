#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

scversion="stable"
cd "$DIR" || exit
wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz"
tar -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
cp shellcheck-"${scversion}"/shellcheck "$HOME/bin/"
shellcheck --version
rm -rf shellcheck-"${scversion}"*
