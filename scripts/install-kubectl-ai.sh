#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
# Exit immediately if a command in a pipeline exits with a non-zero status.
set -euo pipefail

KUBECTL_AI_VERSION="0.0.7"
KUBECTL_AI_URL="https://github.com/GoogleCloudPlatform/kubectl-ai/releases/download/v${KUBECTL_AI_VERSION}/kubectl-ai_Linux_x86_64.tar.gz"
DOWNLOAD_DIR="$HOME/software/kubectl-ai"
INSTALL_DIR="$HOME/bin"
TARBALL_NAME="kubectl-ai_Linux_x86_64.tar.gz"

echo "Installing kubectl-ai v${KUBECTL_AI_VERSION}..."

# Create necessary directories
mkdir -p "$DOWNLOAD_DIR" "$INSTALL_DIR"

# Download the tarball
echo "Downloading from ${KUBECTL_AI_URL}..."
curl -fSsL "$KUBECTL_AI_URL" -o "$DOWNLOAD_DIR/$TARBALL_NAME" || { echo "Error: Download failed."; exit 1; }

# Extract the tarball
echo "Extracting ${TARBALL_NAME}..."
cd "$DOWNLOAD_DIR" || exit 1 # Change directory for extraction
tar -xvf "$TARBALL_NAME" || { echo "Error: Extraction failed."; exit 1; }

# Copy the binary to the install directory
echo "Copying kubectl-ai binary to ${INSTALL_DIR}..."
cp "$DOWNLOAD_DIR/kubectl-ai" "$INSTALL_DIR/" || { echo "Error: Copying binary failed."; exit 1; }

# Make the binary executable
chmod +x "$INSTALL_DIR/kubectl-ai"

# Clean up downloaded files
echo "Cleaning up..."
rm "$TARBALL_NAME"
rm -rf "$DOWNLOAD_DIR"

echo "kubectl-ai v${KUBECTL_AI_VERSION} installed successfully to ${INSTALL_DIR}."

hash -r

# Verify installation
if command -v kubectl-ai &> /dev/null; then
  echo "Verification: kubectl-ai is in your PATH."
else
  echo "Verification: kubectl-ai is NOT in your PATH. Make sure ${INSTALL_DIR} is in your \$PATH."
fi
