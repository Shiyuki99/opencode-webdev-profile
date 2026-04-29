# OpenCode WebDev Profile

A complete OpenCode profile for web development with MCP servers, skills, and profile management.

## Installation

```bash
# Clone this repository
git clone https://github.com/Shiyuki99/opencode-webdev-profile.git
cd opencode-webdev-profile

# Run installation script
chmod +x install.sh
./install.sh
```

## What's Included

### MCP Servers
- **supabase** - Database & Auth (remote)
- **github** - GitHub integration (local)
- **sequential-thinking** - Advanced reasoning (local)
- **21st-dev-magic** - AI UI component generation (local)

### Profile Plugin
The profile plugin allows switching between different configurations using the `OPENCODE_PROFILE` environment variable.

Current profiles:
- `webdev` (default) - Web development focused

## Usage

```bash
# Start opencode with webdev profile (default)
opencode

# Or explicitly set profile
OPENCODE_PROFILE=webdev opencode
```

## Adding MCP Servers

Edit `opencode.json` to add more MCP servers:

```json
{
  "mcp": {
    "your-server": {
      "type": "local",
      "command": ["npx", "-y", "your-mcp-package"],
      "enabled": true
    }
  }
}
```

## Skills

Skills are automatically loaded from your workspace. The profile includes permissions for webdev-related skills.

## License

MIT