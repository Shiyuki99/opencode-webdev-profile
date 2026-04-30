#!/bin/bash

set -e

echo "========================================"
echo "OpenCode Profile Installer"
echo "========================================"

PROFILE_DIR="${HOME}/.config/opencode"
mkdir -p "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR/plugins"

echo "Installing opencode.json..."
cp opencode.json "$PROFILE_DIR/opencode.json"

echo "Installing profile plugin..."
cp plugins/profile-plugin.ts "$PROFILE_DIR/plugins/"
cp plugins/package.json "$PROFILE_DIR/plugins/"

echo "Installing npm dependencies..."
cd "$PROFILE_DIR"
if command -v bun &> /dev/null; then
    bun install
elif command -v npm &> /dev/null; then
    npm install
else
    echo "Warning: No bun or npm found. Install manually: cd ~/.config/opencode && npm install"
fi

echo "Setting up CTF skills..."
SKILLS_DIR="${HOME}/Dev/ctf/.agents/skills"
mkdir -p "$SKILLS_DIR"

echo ""
echo "========================================"
echo "Installation complete!"
echo "========================================"
echo ""
echo "Available profiles:"
echo "  webdev (default) - Web development"
echo "  ctf              - Capture The Flag"
echo ""
echo "Usage:"
echo "  opencode                          # webdev profile"
echo "  OPENCODE_PROFILE=ctf opencode     # ctf profile"
echo ""
echo "MCP Servers:"
echo "  supabase, github, sequential-thinking"
echo "  21st-dev-magic, ctf-mcp"
echo ""
echo "To install CTF system tools (requires sudo):"
echo "  sudo pacman -S wireshark-qt radare2 hashcat john nmap foremost steghide audacity dirb ffuf gobuster perl-image-exiftool ltrace strace"
echo ""
echo "For CTF MCP servers (requires pip):"
echo "  pip install ctf-mcp"
echo "  pip install ptai"
echo ""