#!/bin/bash

set -e

echo "Installing OpenCode WebDev Profile..."

PROFILE_DIR="${HOME}/.config/opencode"
mkdir -p "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR/plugins"

echo "Copying opencode.json..."
cp opencode.json "$PROFILE_DIR/opencode.json"

echo "Copying plugins..."
cp -r plugins/* "$PROFILE_DIR/plugins/"

echo "Installing npm dependencies..."
cd "$PROFILE_DIR"
if command -v bun &> /dev/null; then
    bun install
elif command -v npm &> /dev/null; then
    npm install
else
    echo "Warning: No bun or npm found. You may need to install dependencies manually."
fi

echo ""
echo "Installation complete!"
echo ""
echo "MCP Servers installed:"
echo "  - supabase (remote)"
echo "  - github (local)"
echo "  - sequential-thinking (local)"
echo "  - 21st-dev-magic (local)"
echo ""
echo "To run opencode with this profile, use:"
echo "  opencode"
echo ""
echo "To switch profiles (if you add more), set:"
echo "  OPENCODE_PROFILE=profilename"