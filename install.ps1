# OpenCode Profile Installer - Windows
# Run in PowerShell as Administrator for system tools, or as regular user for profile setup

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Blue
Write-Host "  OpenCode Profile Installer" -ForegroundColor Blue
Write-Host "  Windows" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# --- Paths ---
$ProfileDir = "$env:USERPROFILE\.config\opencode"
$CtfDir = "$env:USERPROFILE\Dev\ctf"
$SkillsDir = "$CtfDir\.agents\skills"

# --- Step 1: Install opencode config ---
Write-Host "[1/7] Installing opencode.json..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
New-Item -ItemType Directory -Force -Path "$ProfileDir\plugins" | Out-Null

# Convert opencode.json paths for Windows
$opencodeContent = Get-Content "$ScriptDir\opencode.json" -Raw
# Replace /tmp/ctf-venv/bin/ctf-mcp with Windows path
$ctfVenvPath = ($CtfDir -replace '\\','/') + "/ctf-venv/Scripts/ctf-mcp.exe"
$opencodeContent = $opencodeContent -replace '/tmp/ctf-venv/bin/ctf-mcp', $ctfVenvPath
# Replace npx paths for Windows
$opencodeContent | Set-Content "$ProfileDir\opencode.json" -Encoding UTF8
Write-Host "  [OK] opencode.json installed" -ForegroundColor Green

# --- Step 2: Install profile plugin ---
Write-Host ""
Write-Host "[2/7] Installing profile plugin..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\plugins\profile-plugin.ts" "$ProfileDir\plugins\" -Force
Copy-Item "$ScriptDir\plugins\package.json" "$ProfileDir\plugins\" -Force

Write-Host "  Installing npm dependencies..." -ForegroundColor Yellow
Push-Location $ProfileDir
if (Get-Command bun -ErrorAction SilentlyContinue) {
    bun install 2>&1 | Select-Object -Last 1
} elseif (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install 2>&1 | Select-Object -Last 3
} else {
    Write-Host "  [WARN] No bun or npm found. Install manually: cd $ProfileDir; npm install" -ForegroundColor Red
}
Pop-Location
Write-Host "  [OK] Profile plugin installed" -ForegroundColor Green

# --- Step 3: Copy CTF skills ---
Write-Host ""
Write-Host "[3/7] Copying CTF skills..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$SkillsDir\planning" | Out-Null
New-Item -ItemType Directory -Force -Path "$SkillsDir\debugging" | Out-Null
New-Item -ItemType Directory -Force -Path "$SkillsDir\ctf" | Out-Null

$SkillNames = @(
    "writing-plans", "executing-plans", "brainstorming", "architecture-review",
    "bug-hunter", "systematic-debugging", "debugging-strategies",
    "verification-before-completion", "test-driven-development", "using-superpowers",
    "dispatching-parallel-agents", "subagent-driven-development", "prompt-optimizer",
    "context-manager", "context7-auto-research", "writing-skills",
    "finishing-a-development-branch", "using-git-worktrees"
)

foreach ($skill in $SkillNames) {
    $srcPath = "$ScriptDir\skills\$skill"
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination "$SkillsDir\planning\" -Recurse -Force
    }
}
Write-Host "  [OK] Planning/debug skills copied" -ForegroundColor Green

# Clone CTF skills
Write-Host "  Downloading CTF skills from github.com/ljagiello/ctf-skills..." -ForegroundColor Yellow
$ctfSkillsTmp = "$env:TEMP\ctf-skills"
if (-not (Test-Path $ctfSkillsTmp)) {
    git clone --depth 1 https://github.com/ljagiello/ctf-skills.git $ctfSkillsTmp 2>&1 | Select-Object -Last 1
}
if (Test-Path $ctfSkillsTmp) {
    $ctfCategories = Get-ChildItem -Path $ctfSkillsTmp -Directory -Filter "ctf-*"
    foreach ($cat in $ctfCategories) {
        Copy-Item -Path $cat.FullName -Destination "$SkillsDir\ctf\" -Recurse -Force
    }
    Write-Host "  [OK] CTF skills (crypto, reverse, pwn, web, forensics, etc.) copied" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Failed to clone ctf-skills repo" -ForegroundColor Red
}

# --- Step 4: Install Python CTF tools ---
Write-Host ""
Write-Host "[4/7] Installing CTF Python tools..." -ForegroundColor Yellow

$pythonCmd = $null
if (Get-Command python3 -ErrorAction SilentlyContinue) { $pythonCmd = "python3" }
elseif (Get-Command python -ErrorAction SilentlyContinue) { $pythonCmd = "python" }

if ($pythonCmd) {
    $venvDir = "$CtfDir\ctf-venv"
    if (-not (Test-Path $venvDir)) {
        & $pythonCmd -m venv $venvDir
    }
    
    $activateScript = "$venvDir\Scripts\Activate.ps1"
    & $activateScript
    & $pythonCmd -m pip install --upgrade pip -q 2>&1 | Select-Object -Last 1
    & $pythonCmd -m pip install oletools binwalk volatility3 -q 2>&1 | Select-Object -Last 1
    Write-Host "  [OK] Python CTF tools installed (oletools, binwalk, volatility3)" -ForegroundColor Green
    Write-Host "    venv location: $venvDir" -ForegroundColor Green

    # Install CTF-MCP
    Write-Host "  Installing CTF-MCP..." -ForegroundColor Yellow
    $ctfMcpTmp = "$env:TEMP\CTF-MCP"
    if (-not (Test-Path $ctfMcpTmp)) {
        git clone --depth 1 https://github.com/Coff0xc/CTF-MCP.git $ctfMcpTmp 2>&1 | Select-Object -Last 1
    }
    if (Test-Path $ctfMcpTmp) {
        Push-Location $ctfMcpTmp
        & $pythonCmd -m pip install -e . -q 2>&1 | Select-Object -Last 1
        Pop-Location
        $ctfMcpPath = "$venvDir\Scripts\ctf-mcp.exe"
        Write-Host "  [OK] CTF-MCP installed at $ctfMcpPath" -ForegroundColor Green
    }
    Deactivate -ErrorAction SilentlyContinue
} else {
    Write-Host "  [WARN] Python not found. Install Python 3.10+ from python.org" -ForegroundColor Red
}

# --- Step 5: Install zsteg (if Ruby available) ---
Write-Host ""
Write-Host "[5/7] Installing Ruby tools..." -ForegroundColor Yellow
if (Get-Command gem -ErrorAction SilentlyContinue) {
    & gem install zsteg 2>&1 | Select-Object -Last 1
    Write-Host "  [OK] zsteg installed" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] Ruby/gem not found. Install Ruby+Devkit from rubyinstaller.org for zsteg" -ForegroundColor Yellow
}

# --- Step 6: CTF system tools (optional) ---
Write-Host ""
Write-Host "[6/7] CTF system tools (optional)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Install Wireshark:" -ForegroundColor Cyan
Write-Host "    winget install --id WiresharkFoundation.Wireshark -e --accept-source-agreements --accept-package-agreements" -ForegroundColor White
Write-Host ""
Write-Host "  Or via Chocolatey (if installed):" -ForegroundColor Cyan
Write-Host "    choco install wireshark nmap ghidra -y" -ForegroundColor White
Write-Host ""
Write-Host "  Or via Scoop (if installed):" -ForegroundColor Cyan
Write-Host "    scoop install nmap" -ForegroundColor White
Write-Host ""
Write-Host "  Download Ghidra from: https://ghidra-sre.org/" -ForegroundColor Cyan
Write-Host "  Download GDB for Windows: https://sourceware.org/gdb/" -ForegroundColor Cyan
Write-Host ""

# --- Step 7: Summary ---
Write-Host "[7/7] Generating install log..." -ForegroundColor Yellow
$logContent = @"
========================================================
OpenCode Profile Installation Log (Windows)
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
5. ctf-mcp (local) - 166 CTF tools

USAGE
-----
- opencode                        # webdev profile (default)
- $env:OPENCODE_PROFILE="ctf"; opencode  # ctf profile

PYTHON CTF TOOLS
-----------------
- oletools, binwalk, volatility3, ctf-mcp
- venv: $CtfDir\ctf-venv
"@
$logContent | Set-Content "$CtfDir\install-log.txt" -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Available profiles:" -ForegroundColor White
Write-Host "    webdev (default) - Web development" -ForegroundColor Cyan
Write-Host "    ctf              - Capture The Flag" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Usage:" -ForegroundColor White
Write-Host "    opencode                        # webdev profile" -ForegroundColor Cyan
Write-Host '    $env:OPENCODE_PROFILE="ctf"; opencode  # ctf profile' -ForegroundColor Cyan
Write-Host ""
Write-Host "  Install log: $CtfDir\install-log.txt" -ForegroundColor White
Write-Host ""