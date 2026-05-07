# OpenCode Profiles

Complete OpenCode profiles for **web development** with MCP servers, profile switching plugin, and curated skills.

## Quick Install

### Linux / macOS

```bash
git clone https://github.com/Shiyuki99/opencode-webdev-profile.git
cd opencode-webdev-profile
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/Shiyuki99/opencode-webdev-profile.git
cd opencode-webdev-profile
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install.ps1
```

## Profiles

Switch profiles using the `OPENCODE_PROFILE` environment variable:

```bash
# Web development (default)
opencode

# CTF / cybersecurity mode
OPENCODE_PROFILE=ctf opencode

# Windows PowerShell
$env:OPENCODE_PROFILE="ctf"; opencode
```

| Profile | MCP Servers | Skills |
|---------|-------------|--------|
| **webdev** (default) | supabase, github, 21st-dev-magic, sequential-thinking | api-patterns, architecture-review, ui-styling, supabase, writing-plans + 8 more |
| **ctf** | ctf-mcp (166 tools), sequential-thinking, github | CTF categories (crypto, reverse, pwn, web, forensics, OSINT) + planning/debug skills |

## What Gets Installed

### MCP Servers (auto-configured)

| Server | Type | Description |
|--------|------|-------------|
| supabase | remote | Database, Auth, Realtime, Storage |
| github | local | GitHub API (issues, PRs, repos) |
| sequential-thinking | local | Advanced multi-step reasoning |
| 21st-dev-magic | local | AI UI component generation |
| ctf-mcp | local | 166 CTF tools (crypto, web, pwn, reverse, forensics, stego) |

### Skills (auto-copied)

**Webdev** (13 skills): api-patterns, architecture-review, brainstorming, bug-hunter, ckm:design, codex-review, context-manager, database-optimizer, frontend-ui-dark-ts, supabase, ui-styling, ui-ux-pro-max, writing-plans

**CTF** (18 workspace skills + 10 category skills from [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills)):
- Workspace: writing-plans, executing-plans, brainstorming, bug-hunter, systematic-debugging, debugging-strategies, verification-before-completion, context-manager, context7-auto-research, prompt-optimizer + 8 more
- CTF categories: ctf-crypto (16), ctf-reverse (13), ctf-pwn (16), ctf-web (18), ctf-forensics (14), ctf-osint (4), ctf-malware (4), ctf-misc (10), ctf-writeup (1), ctf-ai-ml (4)

### CTF System Tools (optional, requires sudo)

<details>
<summary><strong>Linux (Arch)</strong></summary>

```bash
sudo pacman -S --noconfirm wireshark-qt tshark radare2 hashcat john nmap netcat-openbsd \
  foremost steghide audacity dirb ffuf gobuster perl-image-exiftool ltrace strace gdb
```
</details>

<details>
<summary><strong>Linux (Debian/Ubuntu)</strong></summary>

```bash
sudo apt-get install -y wireshark tshark radare2 hashcat john nmap netcat-openbsd \
  foremost steghide audacity dirb ffuf gobuster exiftool ltrace strace gdb
```
</details>

<details>
<summary><strong>macOS</strong></summary>

```bash
brew install --cask wireshark
brew install radare2 hashcat john nmap netcat foremost steghide audacity ffuf gobuster exiftool ltrace strace gdb
```
</details>

<details>
<summary><strong>Windows (PowerShell as Admin)</strong></summary>

```powershell
# Using winget
winget install --id WiresharkFoundation.Wireshark -e --accept-source-agreements --accept-package-agreements
winget install --id GnuWin32.Make -e --accept-source-agreements --accept-package-agreements

# Using Chocolatey (if installed)
choco install wireshark nmap ghidra -y

# Using Scoop (if installed)
scoop install nmap

# Python tools (works on Windows)
pip install oletools binwalk volatility3

# Ruby tools
gem install zsteg
```
</details>

### CTF Python Tools (cross-platform)

```bash
python -m venv ctf-venv
source ctf-venv/bin/activate  # Linux/macOS
# OR: ctf-venv\Scripts\activate  # Windows

pip install oletools binwalk volatility3
gem install zsteg
```

### Additional Free CTF MCP Servers (not auto-installed)

These can be added to `opencode.json` manually:

| MCP Server | Install | Free? | Tools |
|-----------|---------|-------|-------|
| [kali-mcp-go](https://github.com/found-cake/kali-mcp-go) | Go binary | Yes | tshark, nmap, sqlmap, hydra, metasploit |
| [MCP-Kali-Server](https://github.com/TriV3/MCP-Kali-Server) | `python mcp_server.py` | Yes | nmap, gobuster, nikto, hydra, sqlmap |
| [pentest-ai](https://github.com/0xSteph/pentest-ai) | `pip install ptai` | Yes (w/ Claude sub or Ollama) | 150+ tools, 12 agents |
| [MCP-Ghidra5](https://github.com/TheStingR/MCP-Ghidra5) | Python script | Yes (w/ Ollama) | Ghidra headless analysis, decompilation |
| [PentestThinkingMCP](https://github.com/ibrahimsaleem/PentestThinkingMCP) | `npm run build` | Yes | Attack path planning (Beam Search + MCTS) |
| [r2mcp](https://github.com/radareorg/radare2) | `r2pm -r r2mcp` | Yes | Radare2 reverse engineering |
| [CTF-time-mcp](https://github.com/0x-Professor/CTF-time-mcp) | npm | Yes | CTFtime schedule lookup |

<details>
<summary><strong>Example: Adding kali-mcp-go to opencode.json</strong></summary>

```json
{
  "mcp": {
    "kali-mcp": {
      "type": "local",
      "command": ["/path/to/mcp-client", "--server", "http://127.0.0.1:5000"],
      "env": {
        "KALI_MCP_API_TOKEN": "your-token"
      },
      "enabled": true
    }
  }
}
```
</details>

<details>
<summary><strong>Example: Adding r2mcp (Radare2) to opencode.json</strong></summary>

```json
{
  "mcp": {
    "r2mcp": {
      "type": "local",
      "command": ["r2pm", "-r", "r2mcp"],
      "enabled": true
    }
  }
}
```
</details>

## Directory Structure

After installation:

```
~/.config/opencode/
  opencode.json            # Main config (MCP servers + profiles)
  plugins/
    profile-plugin.ts      # Profile switching plugin
    package.json            # Plugin dependencies

~/Dev/ctf/
  .agents/skills/
    planning/              # Workflow skills from workspace
    debugging/             # Debug analysis skills
    ctf/                   # Full CTF skills from ljagiello/ctf-skills

~/Dev/Projects/automation_webstore/website/
  .agents/skills/          # Webdev skills (original, already present)
```

## Adding a New Profile

Edit `~/.config/opencode/plugins/profile-plugin.ts` to add a new profile:

```typescript
const profiles: Profiles = {
  webdev: { /* ... */ },
  ctf: { /* ... */ },
  myprofile: {
    mcp: {
      "my-server": { enabled: true },
    },
    enabled_skills: ["my-skill"],
    disabled_skills: ["unwanted-skill"],
  },
};
```

Then use it: `OPENCODE_PROFILE=myprofile opencode`

## Credits

- CTF skills: [ljagiello/ctf-skills](https://github.com/ljagiello/ctf-skills)
- CTF-MCP: [Coff0xc/CTF-MCP](https://github.com/Coff0xc/CTF-MCP)
- Medium: [@cryptax - Agent skills setup for Insomni'hack CTF](https://cryptax.medium.com/agent-skills-setup-for-insomnihack-ctf-c7c2b3c2e0f3)
- Medium: [@harishhacker3010 - Cracking CTFs with AI Agents](https://medium.com/@harishhacker3010/cracking-ctfs-and-finding-zero-days-with-ai-agents-41a1083ba088)
- Profile plugin pattern: [krystofrezac/gist](https://gist.github.com/krystofrezac/7f16ba252279f889eb750a866b257a1d)

## License

MIT
