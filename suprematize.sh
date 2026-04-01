#!/bin/bash
# 🪐 Suprematize - Kit Supremo Installer (Bash)
# Use: curl -sSL https://raw.githubusercontent.com/phpel/kit_supremo/main/suprematize.sh | bash

set -e

# 1. Configuration
REPO_URL="https://github.com/phpelis/kit_supremo.git"
TEMP_DIR="/tmp/kit_supremo_temp"

echo -e "\n\033[0;36m🚀 Iniciando Transplante do Kit Supremo...\033[0m"

# 2. Cleanup Temp
if [ -d "$TEMP_DIR" ]; then rm -rf "$TEMP_DIR"; fi

# 3. Clone
echo -e "📦 Baixando Kit do GitHub..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" --quiet

# 4. Injecting Files
echo -e "💉 Injetando Inteligência e Metodologia..."

FILES_TO_COPY=(
    ".agents"
    ".context"
    ".project-map"
    ".cursorrules"
    "CLAUDE.md"
    "PROJECT_MAP.md"
    "STATUS.md"
)

for ITEM in "${FILES_TO_COPY[@]}"; do
    SOURCE="$TEMP_DIR/$ITEM"
    if [ -e "$SOURCE" ]; then
        echo -e "   -> Copiando $ITEM"
        cp -rf "$SOURCE" .
    fi
done

# 5. Cleanup
rm -rf "$TEMP_DIR"

echo -e "\n\033[0;36m=============================================\033[0m"
echo -e "\033[0;32m✨ PROJETO SUPREMATIZADO COM SUCESSO! ✨\033[0m"
echo -e "\033[0;36m=============================================\033[0m"
echo -e "\n\033[0;37mPróximos Passos:\033[0m"
echo -e "\033[0;33m1. Claude Code: Digite '/brainstorm' para iniciar.\033[0m"
echo -e "\033[0;33m2. Antigravity: Digite 'ag-refresh' para indexar.\033[0m"
echo -e "\033[0;33m3. Confira o MASTER.md em .agents/rules/.\033[0m"
echo -e "\n\033[0;36mBOA CODIFICAÇÃO, ARQUITETO SUPREMO!\033[0m\n"
