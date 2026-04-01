#!/bin/bash
# 🪐 Supremo Commit - Kit Supremo CLI (Bash)
# Use: ./commit.sh "message"

MESSAGE=$1

# 1. Message check
if [ -z "$MESSAGE" ]; then
    read -p "📝 Digite a mensagem do commit: " MESSAGE
fi

if [ -z "$MESSAGE" ]; then
    echo -e "\033[0;31m❌ Erro: Mensagem de commit é obrigatória.\033[0m"
    exit 1
fi

echo -e "\n\033[0;36m🚀 Iniciando Supremo Commit...\033[0m"

# 2. Git Logic
echo -e "📦 Staging files..."
git add .

echo -e "💾 Committing: $MESSAGE"
git commit -m "$MESSAGE"

# Check for remote
if git remote -v | grep -q "origin"; then
    echo -e "📤 Pushing to GitHub (phpelis/kit_supremo)..."
    git push origin main
    echo -e "\n\033[0;32m✅ COMMIT & PUSH REALIZADOS COM SUCESSO!\033[0m"
else
    echo -e "\n\033[0;32m✅ COMMIT REALIZADO LOCALMENTE!\033[0m"
    echo -e "\033[0;33m⚠️  Nota: Nenhum remote 'origin' detectado.\033[0m"
fi

echo -e "\n\033[0;36m✨ Boa codificação, Arquiteto Supremo!\033[0m\n"
