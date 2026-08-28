#!/usr/bin/env bash
# Installs the local-model-routing Claude Code skill into ~/.claude/skills/.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Jiayi0111/claude-local-model-routing-skill/main/install.sh | bash
# or, from a local clone:
#   ./install.sh

set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/Jiayi0111/claude-local-model-routing-skill/main"
SKILL_DIR="${HOME}/.claude/skills/local-model-routing"
SKILL_FILE="${SKILL_DIR}/SKILL.md"

mkdir -p "${SKILL_DIR}"

SELF_PATH="${BASH_SOURCE[0]:-$0}"
LOCAL_SKILL="$(cd "$(dirname "${SELF_PATH}")" 2>/dev/null && pwd)/skills/local-model-routing/SKILL.md"

if [ -f "${LOCAL_SKILL}" ]; then
  cp "${LOCAL_SKILL}" "${SKILL_FILE}"
else
  curl -fsSL "${REPO_RAW_BASE}/skills/local-model-routing/SKILL.md" -o "${SKILL_FILE}"
fi

echo "Installed: ${SKILL_FILE}"
echo
echo "This skill only supplies routing instructions for Claude Code. It assumes an MCP"
echo "server already exposes a preprocessing tool (path, task, focus, max_output_tokens"
echo "-> structured JSON) backed by a local model. If you don't have one configured"
echo "yet, set that up before the skill has anything to route to."
echo
echo "Restart Claude Code (or start a new session) to pick up the new skill."
