# OpenCode Profiles

Complete OpenCode profiles for **web development** and **CTF (Capture The Flag)** with MCP servers, profile plugin, and curated skills.

## Quick Install

```bash
git clone https://github.com/Shiyuki99/opencode-webdev-profile.git
cd opencode-webdev-profile
chmod +x install.sh
./install.sh
```

## Profiles

### WebDev (default)
Web development profile with database, UI, and API skills.
- **MCP**: supabase, github, 21st-dev-magic, sequential-thinking
- **Skills**: api-patterns, architecture-review, ui-styling, supabase, writing-plans, brainstorm + more

### CTF
Capture The Flag / cybersecurity profile with 166 built-in tools.
- **MCP**: ctf-mcp, sequential-thinking, github
- **Skills**: CTF skills from [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills) + debugging, planning, and analysis skills
- **166 tools** across crypto (53), web (46), pwn (27), reverse, forensics, stego

## Usage

```bash
# Web development
opencode

# CTF mode
OPENCODE_PROFILE=ctf opencode
```

## MCP Servers

| Server | Type | Description |
|--------|------|-------------|
| supabase | remote | Database & Auth |
| github | local | GitHub API |
| sequential-thinking | local | Advanced reasoning |
| 21st-dev-magic | local | AI UI components |
| ctf-mcp | local | 166 CTF tools |

## Skills Directory Structure

```
~/.config/opencode/
  opencode.json        # Main config
  plugins/
    profile-plugin.ts  # Profile switching
    package.json       # Dependencies

~/Dev/ctf/
  .agents/skills/
    planning/          # Workflow skills from workspace
    debugging/         # Debug analysis skills
    ctf/               # Full CTF skills from repo
```

## Install System Tools (CTF)

```bash
# Arch Linux
sudo pacman -S wireshark-qt radare2 hashcat john nmap foremost steghide audacity dirb ffuf gobuster perl-image-exiftool ltrace strace

# Python tools
pip install ctf-mcp ptai

# Ruby tools
gem install zsteg
```

## Credits

- CTF skills: [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills)
- CTF-MCP: [Coff0xc/CTF-MCP](https://github.com/Coff0xc/CTF-MCP)
- Medium: [@cryptax - Agent skills setup for Insomni'hack CTF](https://cryptax.medium.com/agent-skills-setup-for-insomnihack-ctf-c7c2b3c2e0f3)
- Medium: [@harishhacker3010 - Cracking CTFs with AI Agents](https://medium.com/@harishhacker3010/cracking-ctfs-and-finding-zero-days-with-ai-agents-41a1083ba088)