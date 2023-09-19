#!/bin/bash

set -euo pipefail

# This script will take the plugin name as an argument and add it to asdf if it is not already installed
# Then the script will update the plugin to the latest version
# If the plugin is already installed, the script will update the plugin to the latest version
# If the plugin is not installed, the script will install the plugin and update it to the latest version
# The script will set the global version of the plugin to the latest version

# Example usage: ./asdf-update.sh terraform

if [[ "${DEBUG:-0}" -eq 1 ]]; then
  set -x
fi

if [[ ! -x "$(command -v asdf)" ]]; then
  echo >&2 "asdf is not installed"
  exit 0
fi

if [[ $# -eq 0 ]] ; then
  echo >&2 "Please provide the name of the plugin you would like to update or install"
  echo >&2 "Current plugins:"
  asdf current >&2
  exit 1
fi

cd "$HOME"
PLUGIN_NAME=$1

# Check if plugin is installed
if asdf plugin list | grep -q $PLUGIN_NAME; then
  echo >&2 "$PLUGIN_NAME is already installed"
else
  echo >&2 "$PLUGIN_NAME is not installed"
  asdf plugin add "$PLUGIN_NAME"
fi

# Update plugin to latest version
asdf plugin update "$PLUGIN_NAME"

# Get latest version of plugin
LATEST_VERSION="$(asdf latest "$PLUGIN_NAME")"

cd "$HOME"
asdf install "$PLUGIN_NAME" "$LATEST_VERSION"

# Set global version of plugin to latest version
asdf global "$PLUGIN_NAME" "$LATEST_VERSION"

echo >&2 "Successfully updated $PLUGIN_NAME to $LATEST_VERSION"
