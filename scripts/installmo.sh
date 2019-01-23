#!/bin/bash -e

# Download
curl -sSL https://git.io/get-mo -o mo

# Make executable
chmod +x mo

# Move to the right folder
sudo mv mo /usr/local/bin/

# Test
echo "" | mo > /dev/null
