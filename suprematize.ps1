# 🪐 Suprematize - Kit Supremo Installer (Windows)
# Use: irm -uri "https://path-to-your-repo/suprematize.ps1" | iex

$ErrorActionPreference = "Stop"

# 1. Configuration
$repoUrl = "https://github.com/phpelis/kit_supremo.git" # ATUALIZE COM SEU REPO REAL
$tempDir = Join-Path $env:TEMP "kit_supremo_temp"

Write-Host "`n🚀 Iniciando Transplante do Kit Supremo..." -ForegroundColor Cyan

# 2. Cleanup Temp
if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }

# 3. Clone
Write-Host "📦 Baixando Kit do GitHub..." -ForegroundColor White
git clone --depth 1 $repoUrl $tempDir --quiet

# 4. Injecting Files
Write-Host "💉 Injetando Inteligência e Metodologia..." -ForegroundColor White

$filesToCopy = @(
    ".agents",
    ".context",
    ".project-map",
    ".cursorrules",
    "CLAUDE.md",
    "PROJECT_MAP.md",
    "STATUS.md"
)

foreach ($item in $filesToCopy) {
    $source = Join-Path $tempDir $item
    if (Test-Path $source) {
        Write-Host "   -> Copiando $item" -ForegroundColor Gray
        Copy-Item -Path $source -Destination "." -Recurse -Force
    }
}

# 5. Bootstrap
Write-Host "`n⚙️ Configurando Ambiente Local..." -ForegroundColor White
if (Test-Path "setup-kit.ps1") {
    powershell -ExecutionPolicy Bypass -File "setup-kit.ps1"
}

# 6. Cleanup
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "✨ PROJETO SUPREMATIZADO COM SUCESSO! ✨" -ForegroundColor Green -BackgroundColor Black
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "`nPróximos Passos:" -ForegroundColor White
Write-Host "1. Claude Code: Digite '/brainstorm' para iniciar." -ForegroundColor Yellow
Write-Host "2. Antigravity: Digite 'ag-refresh' para indexar." -ForegroundColor Yellow
Write-Host "3. Confira o MASTER.md em .agents/rules/." -ForegroundColor Yellow
Write-Host "`nBOA CODIFICAÇÃO, ARQUITETO SUPREMO!`n" -ForegroundColor Cyan
