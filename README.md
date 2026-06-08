# 🔍 Ask Claude About Your Google Search Console — Setup in 5 Minutes

> No dashboards. No CSV exports. No SEO tools. Just ask Claude directly.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Works with Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![Português](https://img.shields.io/badge/Leia%20em-Portugu%C3%AAs%20%F0%9F%87%A7%F0%9F%87%B7-009c3b)](README.pt.md)

---

## This repo covers two things

**[Part 1](#part-1--connect-claude-to-google-search-console)** — Connect Claude to your live traffic data via Google Search Console (5-minute setup)

**[Part 2](#part-2--let-claude-audit-your-codebase)** — Let Claude read your actual project files and find what's breaking your SEO before Google does (no extra setup)

Used together, Claude becomes a full SEO + dev audit loop: it sees what's hurting your traffic *and* finds the root cause in your code.

---

## Part 1 — Connect Claude to Google Search Console

### What You Can Ask

```
"Why did my homepage traffic drop 80% this month?"

"Which pages have the worst click-through rates?"

"I rank #1 for some keywords but get 0 clicks — what's happening?"

"Find my fastest-decaying content before it falls off completely."

"What are my easiest quick wins this week?"

"Are any of my pages competing against each other for the same query?"
```

### What You Need

| Requirement | Notes |
|---|---|
| [Claude Desktop](https://claude.ai/download) | Free plan works |
| [Node.js](https://nodejs.org) v18+ | Just the installer, ~30 seconds |
| Google Search Console | Any property you own |
| ~5 minutes | Seriously |

### Setup

**Step 1 — Install Node.js** (skip if you already have it)

Download from [nodejs.org](https://nodejs.org) and run the installer.

**Step 2 — Create your Google OAuth credentials**

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project (name it anything — "Claude GSC" works)
3. **APIs & Services → Library** → search **Google Search Console API** → Enable
4. **APIs & Services → Credentials → + Create Credentials → OAuth 2.0 Client ID**
5. Choose **Desktop app**, name it anything, click **Create**
6. Click **Download JSON** — save the file somewhere you'll find it

**Step 3 — Run the setup script**

Windows: double-click `setup.bat` — Mac/Linux: `chmod +x setup.sh && ./setup.sh`

The script checks Node.js, asks for the OAuth JSON path and your site URL, and writes the Claude config automatically.

**Step 4 — Restart Claude and authorize**

Claude will ask you to authorize Google on first launch. Follow the link, approve, done.

### Example Output

```
📊 Site Overview (last 28 days)
   Clicks: 1,247  |  Impressions: 18,432  |  CTR: 6.8%  |  Avg position: 14.2

🚨 Critical Issue Found
   Your homepage dropped 81% in clicks over 3 weeks.
   Position is stable at 2.9 — CTR problem, not a ranking problem.
   The title "Welcome to Our Website" doesn't match what users searched for.

⚡ Quick Wins (this week)
   3 pages on position 6-10 with high impressions and low CTR.
   Fixing their titles could recover ~40 clicks/week with zero link building.
```

### What Claude Can Check

| Analysis | What it looks at |
|---|---|
| **Traffic drops** | Compares 3 periods, isolates pages and queries that fell |
| **CTR opportunities** | Where your ranking vs click rate is below benchmark |
| **Quick wins** | Queries on position 6–15 with easy improvement potential |
| **Content decay** | Pages with 3+ months of consistent decline |
| **Cannibalization** | Multiple URLs competing for the same query |
| **Content gaps** | Queries where you rank but have no real content |
| **Sitemap audit** | Coverage errors, missing pages |
| **URL inspection** | Index status, mobile usability, last crawl date |

### Install the GSC Analyst Skill (Cowork users)

**[Download gsc-analyst.skill](./gsc-analyst.skill)**

In Cowork: Settings → Skills → Install from file → `gsc-analyst.skill`

---

## Part 2 — Let Claude Audit Your Codebase

> No extra setup. Claude reads your files directly and finds what's broken before Google does.

This is what most "AI for SEO" tools miss: **the problem isn't always in your traffic data — it's in your code.**

Wrong canonical tags. Sitemaps pointing to `.html` URLs that redirect. Title tags that look fine until you check what Google actually indexed. Auth redirects that create loops on mobile. Iframes that load before authentication and break the entire login page.

Claude can read your project files and cross-reference them with your GSC data to find the root cause — not just the symptom.

### What it looks like

In **Claude Cowork**: Settings → select your project folder. Then ask:

> *"Audit my site's SEO — check the code and cross-reference with my Search Console data"*

Claude will:
1. Map your project structure
2. Read HTML files and check title, meta, canonical, OG tags, schema markup
3. Read your sitemap and verify every URL format and status
4. Scan JavaScript for syntax errors, broken redirect logic, auth issues
5. Cross-reference with GSC data to see which issues are actually hurting traffic
6. Deliver a prioritized fix list

### What Claude finds that you'd never catch manually

| Issue | Where it hides |
|---|---|
| Canonical pointing to `.html` URL | `<link rel="canonical">` in HTML |
| Sitemap listing inactive/deleted pages | Your `sitemap.xml` |
| Auth redirect creating a login loop | JS redirect inside mobile init function |
| Title tag keyword mismatch vs. GSC queries | Checked by comparing code to GSC data |
| Schema markup missing required fields | `<script type="application/ld+json">` |
| Iframe loading auth page before user opens it | Hidden `src=` on `display:none` container |
| Pages missing from sitemap | Codebase routes vs sitemap entries compared |
| Edit applied to source but not deploy copy | `source/` vs `_release/` diff |

### Example Output

```
🚨 CRITICAL — Fix before next deploy

   [empregos/index.html] Canonical points to /empregos/index.html
   Google is indexing the .html version. All link equity is split.
   Fix: <link rel="canonical" href="https://yourdomain.com/empregos/">

   [servicos/index.html line 8189] Redirect loop risk
   mobStart() redirects all authenticated providers to /servicos/?painel=prestador
   — including desktop users. This fires on every page load, not just mobile.
   Fix: add a mobile check before the redirect.

⚠️  HIGH — Fix this week

   [sitemap.xml] 3 URLs use .html extension — should be clean URLs
   [empregos/empresa.html] Accessible via ?slug= with empty value — returns 200
   Should redirect to /empregos/ with a 301.
```

### Install the Project Auditor Skill (Cowork users)

**[Download project-auditor.skill](./project-auditor.skill)**

In Cowork: Settings → Skills → Install from file → `project-auditor.skill`

---

## How It Works

**Part 1 (GSC)** uses [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp) — a local MCP server running via `npx`. Authenticates with Google OAuth, exposes 20 Search Console tools to Claude. Your data never leaves your machine.

**Part 2 (Code audit)** uses Claude's built-in file access in Cowork or Claude Code. No extra MCP needed. Claude reads your files directly and runs analysis in a sandboxed Linux environment.

```
Part 1: Claude ←→ MCP Server (local) ←→ Google Search Console API
Part 2: Claude ←→ Your project folder (direct file access)
Both:   Claude cross-references GSC data + code findings
```

---

## Troubleshooting (Part 1)

**"MCP server not connected"** → Restart Claude Desktop after running the setup script.

**"Authorization error"** → Run the OAuth flow again. Sometimes needs a second attempt.

**"Site not found"** → Check `GSC_SITE_URL` in your config. Domain properties: `sc-domain:yourdomain.com`. URL prefix: `https://yourdomain.com/`.

**Node.js not found after installing** → Close and reopen terminal after install.

---

## Contributing

Found a better analysis prompt? A bug pattern worth adding to the auditor? Open a PR.

---

## License

MIT — use it, fork it, share it.

---

*Built by [Fernandes](https://github.com/sabnck) while doing actual SEO analysis and code auditing with Claude.*  
*The issues in the examples above were found in a real production site.*
