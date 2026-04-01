# 🪐 Supremo Commit - Kit Supremo CLI (Windows)
# Use: .\commit.ps1 "message"

param (
    [Parameter(Mandatory=$false, Position=0)]
    [string]$Message
)

$ErrorActionPreference = "Stop"

# 1. Message check
if (-not $Message) {
    $Message = Read-Host "📝 Digite a mensagem do commit"
}

if (-not $Message) {
    Write-Host "❌ Erro: Mensagem de commit é obrigatória." -ForegroundColor Red
    exit 1
}

Write-Host "`n🚀 Iniciando Supremo Commit..." -ForegroundColor Cyan

# 2. Git Logic
try {
    Write-Host "📦 Staging files..." -ForegroundColor White
    git add .

    Write-Host "💾 Committing: $Message" -ForegroundColor White
    git commit -m "$Message"

    # Check for remote
    $remote = git remote -v
    if ($remote -match "origin") {
        Write-Host "📤 Pushing to GitHub (phpelis/kit_supremo)..." -ForegroundColor White
        git push origin main
        Write-Host "`n✅ COMMIT & PUSH REALIZADOS COM SUCESSO!" -ForegroundColor Green
    } else {
        Write-Host "`n✅ COMMIT REALIZADO LOCALMENTE!" -ForegroundColor Green
        Write-Host "⚠️  Nota: Nenhum remote 'origin' detectado. Use 'git remote add origin' para sincronizar." -ForegroundColor Yellow
    }
} catch {
    Write-Host "`n❌ Erro durante o processo de commit." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Gray
    exit 1
}

Write-Host "`n✨ Boa codificação, Arquiteto Supremo!`n" -ForegroundColor Cyan
