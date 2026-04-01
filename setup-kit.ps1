# Antigravity Kit Supremo — Installer for Windows
# This script sets up the 'Kit Supremo' environment automatically.

$ErrorActionPreference = "Stop"

Write-Host "`n🪐 Antigravity Kit Supremo - Setup" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 1. Dependency Checks
Write-Host "`n🔍 Checking dependencies..." -ForegroundColor White

try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python detected: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Python 3 is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Please install Python from https://www.python.org/downloads/"
    exit 1
}

try {
    $nodeVersion = node --version 2>&1
    Write-Host "✅ Node.js detected: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Node.js is not installed." -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/"
    exit 1
}

# 2. Virtual Environment Setup
Write-Host "`n📦 Setting up Python Virtual Environment..." -ForegroundColor White
if (-not (Test-Path "venv")) {
    python -m venv venv
    Write-Host "✅ Virtual environment created." -ForegroundColor Green
} else {
    Write-Host "⚠️ Virtual environment already exists. Skipping." -ForegroundColor Yellow
}

# 3. Installing Engine Dependencies
Write-Host "`n🔧 Installing engine dependencies..." -ForegroundColor White
& .\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip --quiet
pip install google-genai --quiet
Write-Host "✅ Dependencies installed." -ForegroundColor Green

# 4. Finalizing Configuration
Write-Host "`n⚙️ Finalizing configuration..." -ForegroundColor White

if (-not (Test-Path ".env")) {
    $envContent = @"
# Antigravity Kit Supremo Configuration
GOOGLE_API_KEY=your_gemini_api_key_here
# OPENAI_API_KEY=your_openai_key_here

# Local Project Settings (Kit Supremo Standard)
AG_LOCAL_INSTALL=true
WORKSPACE_PATH=.
"@
    Set-Content -Path ".env" -Value $envContent
    Write-Host "✅ Created .env file (please add your API key)." -ForegroundColor Green
}

# 5. First Indexing (Optional/Dry Run)
Write-Host "`n🧠 Running initial discovery..." -ForegroundColor White
Write-Host "AI System is ready. Use 'ag-refresh' to index your project." -ForegroundColor Magenta

# 6. Success Message
Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "✨ KIT SUPREMO INSTALADO COM SUCESSO! ✨" -ForegroundColor Green -BackgroundColor Black
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "`nPróximos passos:" -ForegroundColor White
Write-Host "1. Configure sua API KEY no arquivo .env" -ForegroundColor Yellow
Write-Host "2. Na IDE Antigravity, suas regras já estão em .agents/rules/MASTER.md" -ForegroundColor Yellow
Write-Host "3. No Claude Code, use os Slash Commands (/plan, /brainstorm, /debug)" -ForegroundColor Yellow
Write-Host "4. Digite 'ag-refresh' para indexar este projeto." -ForegroundColor Yellow
Write-Host "`nBOA CODIFICAÇÃO, ARQUITETO SUPREMO!`n" -ForegroundColor Cyan
