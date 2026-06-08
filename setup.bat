@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║   Claude + Google Search Console — Setup Script     ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

:: ── 1. Check Node.js ──────────────────────────────────────────────────────
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo  [!] Node.js not found.
    echo.
    echo  Please install it from: https://nodejs.org
    echo  Choose the LTS version, run the installer, then come back and run this script again.
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do set NODE_VER=%%v
echo  [OK] Node.js %NODE_VER% found.
echo.

:: ── 2. Ask for OAuth JSON file ────────────────────────────────────────────
echo  STEP 1 of 3 — OAuth credentials
echo  ─────────────────────────────────────────────────────────
echo.
echo  You need a Google OAuth JSON file (Desktop App type).
echo.
echo  If you haven't created it yet:
echo    1. Go to: https://console.cloud.google.com
echo    2. Create a project, enable "Google Search Console API"
echo    3. Credentials → Create Credentials → OAuth 2.0 Client ID → Desktop app
echo    4. Download the JSON file
echo.
echo  Drag and drop the JSON file into this window, then press Enter:
set /p OAUTH_PATH=  >

:: Clean up quotes and trailing spaces
set OAUTH_PATH=%OAUTH_PATH:"=%
set "OAUTH_PATH=%OAUTH_PATH: =%"

if not exist "%OAUTH_PATH%" (
    echo.
    echo  [ERROR] File not found. Make sure you dragged the right file.
    echo  Try again by running this script once more.
    pause
    exit /b 1
)
echo.
echo  [OK] OAuth file found.
echo.

:: ── 3. Ask for site URL ───────────────────────────────────────────────────
echo  STEP 2 of 3 — Your site URL
echo  ─────────────────────────────────────────────────────────
echo.
echo  What is your site URL in Google Search Console?
echo.
echo  Examples:
echo    Domain property:    sc-domain:yourdomain.com
echo    URL prefix:         https://yourdomain.com/
echo.
set /p SITE_URL=  Your site:

if "%SITE_URL%"=="" (
    echo.
    echo  [ERROR] Site URL cannot be empty.
    pause
    exit /b 1
)
echo.
echo  [OK] Site URL set.
echo.

:: ── 4. Write Claude config ────────────────────────────────────────────────
echo  STEP 3 of 3 — Writing Claude configuration
echo  ─────────────────────────────────────────────────────────
echo.

set CONFIG_DIR=%APPDATA%\Claude
set CONFIG_PATH=%CONFIG_DIR%\claude_desktop_config.json

:: Normalize OAuth path separators for JSON (backslash → double backslash)
set "OAUTH_JSON=%OAUTH_PATH:\=\\%"

:: Check if config already exists
if exist "%CONFIG_PATH%" (
    echo  Found existing Claude config at:
    echo  %CONFIG_PATH%
    echo.
    echo  The script will NOT overwrite your existing config.
    echo  Instead, it will create a snippet file you can paste in manually.
    goto :write_snippet
)

:: No existing config — create fresh one
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

(
echo {
echo   "mcpServers": {
echo     "gsc": {
echo       "command": "npx",
echo       "args": ["-y", "suganthan-gsc-mcp"],
echo       "env": {
echo         "GSC_AUTH_MODE": "oauth",
echo         "GSC_OAUTH_SECRETS_FILE": "%OAUTH_JSON%",
echo         "GSC_SITE_URL": "%SITE_URL%"
echo       }
echo     }
echo   }
echo }
) > "%CONFIG_PATH%"

echo  [OK] Config written to: %CONFIG_PATH%
goto :done

:write_snippet
set SNIPPET_PATH=%~dp0gsc-config-snippet.json
(
echo.
echo   Add this inside "mcpServers": { } in your claude_desktop_config.json:
echo.
echo     "gsc": {
echo       "command": "npx",
echo       "args": ["-y", "suganthan-gsc-mcp"],
echo       "env": {
echo         "GSC_AUTH_MODE": "oauth",
echo         "GSC_OAUTH_SECRETS_FILE": "%OAUTH_JSON%",
echo         "GSC_SITE_URL": "%SITE_URL%"
echo       }
echo     }
echo.
) > "%SNIPPET_PATH%"
type "%SNIPPET_PATH%"
echo  Snippet also saved to: %SNIPPET_PATH%
echo.
echo  Your config is at: %CONFIG_PATH%
echo  Open it in Notepad and paste the snippet inside "mcpServers": { }
echo.

:done
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║                  YOU'RE ALMOST DONE                 ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo  1. Restart Claude Desktop completely (quit and reopen)
echo.
echo  2. When Claude opens, it will ask you to authorize Google.
echo     Click the link, sign in, and approve the permissions.
echo.
echo  3. Try asking Claude:
echo     "Why did my traffic drop recently?"
echo     "What are my quick SEO wins this week?"
echo     "Give me a full analysis of my site"
echo.
echo  That's it. You're connected.
echo.
pause
