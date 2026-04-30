#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================"
echo -e "  OpenCode Profile Installer"
echo -e "  Linux / macOS"
echo -e "========================================${NC}"
echo ""

# --- Detect OS ---
if [[ -f /etc/arch-release ]]; then
    OS="arch"
    PKG_MGR="pacman"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
    PKG_MGR="apt"
elif [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
    PKG_MGR="brew"
else
    OS="linux"
    PKG_MGR="unknown"
fi

echo -e "${GREEN}Detected OS: $OS${NC}"

# --- Paths ---
PROFILE_DIR="${HOME}/.config/opencode"
CTF_DIR="${HOME}/Dev/ctf"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Step 1: Install opencode config ---
echo ""
echo -e "${YELLOW}[1/6] Installing opencode.json...${NC}"
mkdir -p "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR/plugins"
cp "$SCRIPT_DIR/opencode.json" "$PROFILE_DIR/opencode.json"
echo -e "${GREEN}  ✓ opencode.json installed${NC}"

# --- Step 2: Install profile plugin ---
echo ""
echo -e "${YELLOW}[2/6] Installing profile plugin...${NC}"
cp "$SCRIPT_DIR/plugins/profile-plugin.ts" "$PROFILE_DIR/plugins/"
cp "$SCRIPT_DIR/plugins/package.json" "$PROFILE_DIR/plugins/"

echo -e "${YELLOW}  Installing npm dependencies...${NC}"
cd "$PROFILE_DIR"
if command -v bun &> /dev/null; then
    bun install 2>&1 | tail -1
elif command -v npm &> /dev/null; then
    npm install 2>&1 | tail -3
else
    echo -e "${RED}  ✗ No bun or npm found. Install manually: cd ~/.config/opencode && npm install${NC}"
fi
echo -e "${GREEN}  ✓ Profile plugin installed${NC}"

# --- Step 3: Copy skills ---
echo ""
echo -e "${YELLOW}[3/6] Copying skills...${NC}"

# Webdev skills to workspace
WORKSPACE_SKILLS_DIR="${HOME}/Dev/Projects/automation_webstore/website/.agents/skills"
if [[ -d "$WORKSPACE_SKILLS_DIR" ]]; then
    echo -e "${GREEN}  ✓ Workspace skills directory found${NC}"
else
    echo -e "${YELLOW}  Creating workspace skills directory...${NC}"
    mkdir -p "$WORKSPACE_SKILLS_DIR"
fi

# CTF skills
CTF_SKILLS_DIR="${CTF_DIR}/.agents/skills"
mkdir -p "$CTF_SKILLS_DIR/planning"
mkdir -p "$CTF_SKILLS_DIR/debugging"
mkdir -p "$CTF_SKILLS_DIR/ctf"

# Copy planning/debug skills to CTF dir
SKILL_NAMES=(writing-plans executing-plans brainstorming architecture-review bug-hunter systematic-debugging debugging-strategies verification-before-completion test-driven-development using-superpowers dispatching-parallel-agents subagent-driven-development prompt-optimizer context-manager context7-auto-research writing-skills finishing-a-development-branch using-git-worktrees)

for skill in "${SKILL_NAMES[@]}"; do
    if [[ -d "$SCRIPT_DIR/skills/$skill" ]]; then
        cp -r "$SCRIPT_DIR/skills/$skill" "$CTF_SKILLS_DIR/planning/"
    fi
done
echo -e "${GREEN}  ✓ Planning/debug skills copied to ~/Dev/ctf/.agents/skills/${NC}"

# Clone and copy CTF skills from ljagiello/ctf-skills
echo -e "${YELLOW}  Downloading CTF skills from github.com/ljagiello/ctf-skills...${NC}"
if [[ ! -d /tmp/ctf-skills ]]; then
    git clone --depth 1 https://github.com/ljagiello/ctf-skills.git /tmp/ctf-skills 2>&1 | tail -1
fi
if [[ -d /tmp/ctf-skills ]]; then
    cp -r /tmp/ctf-skills/ctf-* "$CTF_SKILLS_DIR/ctf/"
    echo -e "${GREEN}  ✓ CTF skills (crypto, reverse, pwn, web, forensics, etc.) copied${NC}"
else
    echo -e "${RED}  ✗ Failed to clone ctf-skills repo${NC}"
fi

# --- Step 4: Install CTF Python tools ---
echo ""
echo -e "${YELLOW}[4/6] Installing CTF Python tools...${NC}"
if command -v python3 &> /dev/null; then
    VENV_DIR="${CTF_DIR}/ctf-venv"
    python3 -m venv "$VENV_DIR" 2>/dev/null || true
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip -q 2>/dev/null
    pip install oletools binwalk volatility3 -q 2>&1 | tail -1
    echo -e "${GREEN}  ✓ Python CTF tools installed (oletools, binwalk, volatility3)${NC}"
    echo -e "${GREEN}    venv location: $VENV_DIR${NC}"

    # Install CTF-MCP
    echo -e "${YELLOW}  Installing CTF-MCP...${NC}"
    if [[ ! -d /tmp/CTF-MCP ]]; then
        git clone --depth 1 https://github.com/Coff0xc/CTF-MCP.git /tmp/CTF-MCP 2>&1 | tail -1
    fi
    if [[ -d /tmp/CTF-MCP ]]; then
        cd /tmp/CTF-MCP && pip install -e . -q 2>&1 | tail -1
        CTF_MCP_PATH=$(which ctf-mcp 2>/dev/null || echo "$VENV_DIR/bin/ctf-mcp")
        echo -e "${GREEN}  ✓ CTF-MCP installed at $CTF_MCP_PATH${NC}"
    fi
    deactivate 2>/dev/null || true
else
    echo -e "${RED}  ✗ Python3 not found. Install Python 3.10+ first.${NC}"
fi

# Install zsteg
if command -v gem &> /dev/null; then
    gem install zsteg 2>&1 | tail -1
    echo -e "${GREEN}  ✓ zsteg installed${NC}"
fi

# --- Step 5: CTF system tools ---
echo ""
echo -e "${YELLOW}[5/6] CTF system tools (optional, requires sudo)${NC}"
echo ""
echo -e "  Run the following command to install CTF system tools:"
echo ""
if [[ "$OS" == "arch" ]]; then
    echo -e "  ${BLUE}sudo pacman -S --noconfirm wireshark-qt tshark radare2 hashcat john nmap netcat-openbsd foremost steghide audacity dirb ffuf gobuster perl-image-exiftool ltrace strace gdb${NC}"
elif [[ "$OS" == "debian" ]]; then
    echo -e "  ${BLUE}sudo apt-get install -y wireshark tshark radare2 hashcat john nmap netcat-openbsd foremost steghide audacity dirb ffuf gobuster exiftool ltrace strace gdb${NC}"
elif [[ "$OS" == "macos" ]]; then
    echo -e "  ${BLUE}brew install --cask wireshark && brew install radare2 hashcat john nmap netcat foremost steghide audacity ffuf gobuster exiftool gdb${NC}"
else
    echo -e "  ${BLUE}# Install via your package manager: wireshark, tshark, radare2, hashcat, john, nmap, foremost, steghide, gdb${NC}"
fi
echo ""

# --- Step 6: Summary ---
echo -e "${YELLOW}[6/6] Generating install log...${NC}"
cat > "${CTF_DIR}/install-log.txt" << 'LOGEOF'
========================================================
OpenCode Profile Installation Log
========================================================

PROFILES INSTALLED
-----------------
1. webdev (default) - Web development profile
2. ctf - Capture The Flag / cybersecurity profile

MCP SERVERS CONFIGURED
----------------------
1. supabase (remote) - Database & Auth
2. github (local) - GitHub API integration
3. sequential-thinking (local) - Advanced reasoning
4. 21st-dev-magic (local) - AI UI component generation
5. ctf-mcp (local) - 166 CTF tools (crypto, web, pwn, reverse, forensics, stego)

SKILLS - WEBDEV
---------------
api-patterns, architecture-review, brainstorming, bug-hunter,
ckm:design, codex-review, context-manager, database-optimizer,
frontend-ui-dark-ts, supabase, ui-styling, ui-ux-pro-max, writing-plans

SKILLS - CTF
-------------
Planning: writing-plans, executing-plans, brainstorming, architecture-review,
bug-hunter, systematic-debugging, debugging-strategies, verification-before-completion
Debugging: test-driven-development, using-superpowers, dispatching-parallel-agents
CTF Categories: crypto, reverse, pwn, web, forensics, OSINT, malware, misc, writeup, AI/ML

PYTHON CTF TOOLS (~/Dev/ctf/ctf-venv)
---------------------------------------
- oletools, binwalk, volatility3, ctf-mcp

RUBY TOOLS
----------
- zsteg (PNG/BMP steganography)

USAGE
-----
- opencode                       # webdev profile (default)
- OPENCODE_PROFILE=ctf opencode  # ctf profile
LOGEOF

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "  Available profiles:"
echo -e "    ${BLUE}webdev${NC} (default) - Web development"
echo -e "    ${BLUE}ctf${NC}            - Capture The Flag"
echo ""
echo -e "  Usage:"
echo -e "    ${BLUE}opencode${NC}                          # webdev profile"
echo -e "    ${BLUE}OPENCODE_PROFILE=ctf opencode${NC}     # ctf profile"
echo ""
echo -e "  Install log: ${CTF_DIR}/install-log.txt"
echo ""