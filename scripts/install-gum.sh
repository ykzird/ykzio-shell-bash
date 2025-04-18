#!/bin/bash

set -e

# Check for curl or wget
if ! command -v curl >/dev/null && ! command -v wget >/dev/null; then
  echo "❌ Error: curl or wget is required to download gum."
  exit 1
fi

# Determine latest release version from GitHub
echo "🔍 Fetching latest gum release..."
GUM_LATEST=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)

if [[ -z "$GUM_LATEST" ]]; then
  echo "❌ Failed to fetch the latest gum release."
  exit 1
fi

# Download the .deb package
echo "⬇️  Downloading gum from $GUM_LATEST..."
curl -L "$GUM_LATEST" -o gum_latest_amd64.deb

# Install the package
echo "📦 Installing gum..."
sudo dpkg -i gum_latest_amd64.deb || sudo apt-get install -f -y

# Clean up
rm -f gum_latest_amd64.deb

# Confirm installation
if command -v gum >/dev/null; then
  echo "✅ Gum installed successfully!"
else
  echo "❌ Gum installation failed."
fi
