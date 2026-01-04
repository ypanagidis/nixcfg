#!/usr/bin/env bash
set -euo pipefail

NIX_FILE="${1:-./helium.nix}"

# Get latest release from GitHub API
LATEST=$(curl -s https://api.github.com/repos/imputnet/helium-linux/releases/latest | grep -oP '"tag_name": "\K[^"]+')

if [[ -z "$LATEST" ]]; then
  echo "Failed to fetch latest version"
  exit 1
fi

# Get current version from nix file
CURRENT=$(grep -oP 'version = "\K[^"]+' "$NIX_FILE")

if [[ "$CURRENT" == "$LATEST" ]]; then
  echo "Already on latest version: $LATEST"
  exit 1
fi

echo "Updating Helium: $CURRENT -> $LATEST"

DOWNLOAD_URL="https://github.com/imputnet/helium-linux/releases/download/${LATEST}/helium-${LATEST}-x86_64.AppImage"

# Verify URL exists
if ! curl -sI "$DOWNLOAD_URL" | grep -q "200\|302"; then
  echo "Download URL not found: $DOWNLOAD_URL"
  exit 1
fi

NEW_HASH=$(nix-prefetch-url "$DOWNLOAD_URL" 2>/dev/null)

sed -i "s|version = \".*\"|version = \"$LATEST\"|" "$NIX_FILE"
sed -i "s|/download/[^/]*/helium-[^\"]*|/download/${LATEST}/helium-${LATEST}-x86_64.AppImage|" "$NIX_FILE"
sed -i "s|sha256 = \".*\"|sha256 = \"$NEW_HASH\"|" "$NIX_FILE"

echo "Done. Version: $LATEST, Hash: $NEW_HASH"
