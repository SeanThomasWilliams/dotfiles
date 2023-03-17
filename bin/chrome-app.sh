#!/bin/bash

set -euo pipefail

# This script is used to launch a Chrome App from the command line.

# The first argument is the name of the application
# We find the application name in the local applications directory, then run the exec command from the
# desktop file.

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <app name>"
    exit 1
fi

if [[ ${DEBUG-} -eq 1 ]]; then
  set -x
fi

APP_NAME="$*"

# Find the application name
if ! grep -q -r "$APP_NAME" "$HOME/.local/share/applications/" ; then
    echo "Application $APP_NAME not found!"
    exit 1
fi

# Get the desktop file
DESKTOP_FILE=$(grep -l -r "$APP_NAME" "$HOME/.local/share/applications/")

EXEC_COMMAND=$(grep '^Exec' "$DESKTOP_FILE" |\
  tail -n 1 |\
  sed 's/^Exec=//' |\
  sed 's/%.//' |\
  sed 's/^"//g' |\
  sed 's/" *$//g'
)

PROFILE_DIRECTORY=$(echo "$EXEC_COMMAND" |\
  grep -Eo "profile-directory=[^-]*" |\
  tr -d '"' |\
  cut -d= -f2 |\
  sed 's/^ *//g' |\
  sed 's/ *$//g')

APP_ID=$(echo "$EXEC_COMMAND" |\
  grep -Eo "app-id=[^-]*" |\
  tr -d '"' |\
  cut -d= -f2 |\
  sed 's/^ *//g' |\
  sed 's/ *$//g')

echo >&2 "Running: " google-chrome --profile-directory="$PROFILE_DIRECTORY" --app-id="$APP_ID"

google-chrome --profile-directory="$PROFILE_DIRECTORY" --app-id="$APP_ID" &
