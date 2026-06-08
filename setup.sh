#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║   Claude + Google Search Console — Setup Script     ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

# ── 1. Check Node.js ──────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
    echo -e "${RED}[!] Node.js not found.${RESET}"
    echo ""
    echo "Please install it from: https://nodejs.org"
    echo "Choose the LTS version, install it, then run this script again."
    echo ""
    exit 1
fi

NODE_VER=$(node --version)
echo -e "${GREEN}[OK]${RESET} Node.js $NODE_VER found."
echo ""

# ── 2. Ask for OAuth JSON file ────────────────────────────────────────────
echo -e "${BOLD}STEP 1 of 3 — OAuth credentials${RESET}"
echo "─────────────────────────────────────────────────────────"
echo ""
echo "You need a Google OAuth JSON file (Desktop App type)."
echo ""
echo "If you haven't created it yet:"
echo "  1. Go to: https://console.cloud.google.com"
echo "  2. Create a project, enable 'Google Search Console API'"
echo "  3. Credentials → Create Credentials → OAuth 2.0 Client ID → Desktop app"
echo "  4. Download the JSON file"
echo ""
read -rp "  Paste the path to your OAuth JSON file: " OAUTH_PATH

# Expand ~ and remove surrounding quotes
OAUTH_PATH="${OAUTH_PATH/#\~/$HOME}"
OAUTH_PATH="${OAUTH_PATH//\"/}"

if [ ! -f "$OAUTH_PATH" ]; then
    echo ""
    echo -e "${RED}[ERROR]${RESET} File not found: $OAUTH_PATH"
    echo "Make sure you entered the correct path and try again."
    exit 1
fi

echo ""
echo -e "${GREEN}[OK]${RESET} OAuth file found."
echo ""

# ── 3. Ask for site URL ───────────────────────────────────────────────────
echo -e "${BOLD}STEP 2 of 3 — Your site URL${RESET}"
echo "─────────────────────────────────────────────────────────"
echo ""
echo "What is your site URL in Google Search Console?"
echo ""
echo "  Domain property:    sc-domain:yourdomain.com"
echo "  URL prefix:         https://yourdomain.com/"
echo ""
read -rp "  Your site: " SITE_URL

if [ -z "$SITE_URL" ]; then
    echo -e "${RED}[ERROR]${RESET} Site URL cannot be empty."
    exit 1
fi

echo ""
echo -e "${GREEN}[OK]${RESET} Site URL set."
echo ""

# ── 4. Detect config path ─────────────────────────────────────────────────
echo -e "${BOLD}STEP 3 of 3 — Writing Claude configuration${RESET}"
echo "─────────────────────────────────────────────────────────"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_DIR="$HOME/Library/Application Support/Claude"
else
    CONFIG_DIR="$HOME/.config/Claude"
fi

CONFIG_PATH="$CONFIG_DIR/claude_desktop_config.json"
OAUTH_ESCAPED=$(echo "$OAUTH_PATH" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')

SNIPPET=$(cat <<EOF
    "gsc": {
      "command": "npx",
      "args": ["-y", "suganthan-gsc-mcp"],
      "env": {
        "GSC_AUTH_MODE": "oauth",
        "GSC_OAUTH_SECRETS_FILE": "$OAUTH_ESCAPED",
        "GSC_SITE_URL": "$SITE_URL"
      }
    }
EOF
)

if [ ! -f "$CONFIG_PATH" ]; then
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_PATH" <<EOF
{
  "mcpServers": {
$SNIPPET
  }
}
EOF
    echo -e "${GREEN}[OK]${RESET} Config written to: $CONFIG_PATH"
else
    SNIPPET_PATH="$(dirname "$0")/gsc-config-snippet.txt"
    cat > "$SNIPPET_PATH" <<EOF

Add this inside "mcpServers": { } in your claude_desktop_config.json:

$SNIPPET

Your config is at: $CONFIG_PATH
EOF
    echo -e "${YELLOW}[!]${RESET} Existing config found. Snippet saved to: $SNIPPET_PATH"
    cat "$SNIPPET_PATH"
    echo ""
    echo "Open your config file and paste the snippet inside the mcpServers block."
fi

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║                  YOU'RE ALMOST DONE                 ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo "  1. Restart Claude Desktop completely (quit and reopen)"
echo ""
echo "  2. When Claude opens, it will ask you to authorize Google."
echo "     Click the link, sign in, and approve the permissions."
echo ""
echo "  3. Try asking Claude:"
echo -e "     ${CYAN}\"Why did my traffic drop recently?\"${RESET}"
echo -e "     ${CYAN}\"What are my quick SEO wins this week?\"${RESET}"
echo -e "     ${CYAN}\"Give me a full analysis of my site\"${RESET}"
echo ""
echo "  That's it. You're connected."
echo ""
