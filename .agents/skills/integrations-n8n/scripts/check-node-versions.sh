#!/usr/bin/env bash
# check-node-versions.sh
# Scans all node files in n8n/<workflow>/nodes/ and reports nodes that may
# need a version audit. Does NOT call the MCP — it simply lists all typeVersion
# values found so you know which get_node calls to make.
#
# Usage:
#   bash skills/33-n8n/scripts/check-node-versions.sh [workflow-folder]
#
# Examples:
#   bash skills/33-n8n/scripts/check-node-versions.sh
#          → scans ALL workflows under n8n/
#   bash skills/33-n8n/scripts/check-node-versions.sh payment-flow
#          → scans only n8n/payment-flow/

set -euo pipefail

# --- config ---
N8N_DIR="${N8N_DIR:-n8n}"
TARGET="${1:-}"

# Nodes known to have had significant version changes — flag these specially
HIGH_RISK_NODES=(
  "httpRequest"
  "set"
  "code"
  "if"
  "switch"
  "merge"
  "splitInBatches"
)

# --- helpers ---
is_high_risk() {
  local node_type="$1"
  for risk in "${HIGH_RISK_NODES[@]}"; do
    if [[ "$node_type" == *"$risk"* ]]; then
      echo "true"
      return
    fi
  done
  echo "false"
}

# --- main ---
if [[ ! -d "$N8N_DIR" ]]; then
  echo "ERROR: Directory '$N8N_DIR' not found."
  echo "Run this script from the project root."
  exit 1
fi

if [[ -n "$TARGET" ]]; then
  SEARCH_PATH="$N8N_DIR/$TARGET/nodes"
else
  SEARCH_PATH="$N8N_DIR"
fi

echo ""
echo "=== n8n Node Version Audit ==="
echo "Scanning: $SEARCH_PATH"
echo ""

FOUND=0
FLAGGED=0

while IFS= read -r file; do
  # Extract type and typeVersion using grep + sed (no jq dependency)
  node_type=$(grep -o '"type": *"[^"]*"' "$file" 2>/dev/null | head -1 | sed 's/"type": *"\(.*\)"/\1/')
  type_version=$(grep -o '"typeVersion": *[0-9.]*' "$file" 2>/dev/null | head -1 | sed 's/"typeVersion": *\(.*\)/\1/')

  [[ -z "$node_type" ]] && continue

  FOUND=$((FOUND + 1))
  risk=$(is_high_risk "$node_type")
  flag=""
  [[ "$risk" == "true" ]] && flag=" ⚠ HIGH RISK — check get_node for defaultVersion" && FLAGGED=$((FLAGGED + 1))

  printf "  %-55s typeVersion: %-5s%s\n" "$node_type" "${type_version:-?}" "$flag"
  printf "    File: %s\n" "$file"
  echo ""

done < <(find "$SEARCH_PATH" -name "*.json" 2>/dev/null | sort)

if [[ $FOUND -eq 0 ]]; then
  echo "No node JSON files found."
  exit 0
fi

echo "---"
echo "Total nodes scanned : $FOUND"
echo "High-risk nodes     : $FLAGGED  (run get_node on each to compare typeVersion vs defaultVersion)"
echo ""
echo "Next step: for each HIGH RISK node, run in n8n MCP:"
echo "  get_node(\"<nodeType>\")  → check 'defaultVersion' in response"
echo "  If typeVersion < defaultVersion → upgrade with n8n_update_partial_workflow"
echo ""
