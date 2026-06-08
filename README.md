# 🔍 Let Claude Fix Your Site — Traffic Analysis + Code Audit + Fixes, All at Once

> You don't need to know what's broken. Claude finds it, explains it, and fixes it.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Works with Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)
[![Português](https://img.shields.io/badge/Leia%20em-Portugu%C3%AAs%20%F0%9F%87%A7%F0%9F%87%B7-009c3b)](README.pt.md)

---

## What this is

You give Claude two things: access to your **Google Search Console** (live traffic data) and access to your **project folder** (your actual files). Then you ask "what's wrong with my site?"

Claude does the rest, simultaneously. It reads your traffic data and your code at the same time, connects the dots, finds what's hurting you, and fixes it directly in the files.

One conversation. No SEO expertise needed. No coding experience needed.

---

## What happens after setup

You ask: *"What's wrong with my site?"*

Claude, working in parallel:

- Pulls 28 days of Google Search Console data: clicks, impressions, positions, alerts
- Reads your HTML files: title tags, meta descriptions, canonical URLs, OG tags, schema markup
- Reads your sitemap and checks every URL for problems
- Scans your JavaScript: syntax errors, redirect logic, auth flows that might be looping
- Compares your traffic data with your code to find where the problem Google sees matches a bug in your files

Then it tells you exactly what it found, why it matters, and either fixes it directly or shows you the exact change to make.

---

## Real example

Here's a slice of what Claude returned on an actual site audit:

**From traffic data (Google Search Console):**
```
🚨 Homepage clicks dropped 63% over 4 weeks.
   Position is stable at 3.1. This is a CTR problem, not a ranking problem.
   Title "We Help Businesses Grow" matches zero specific searches.
   Fix: replace with a title that names what you actually do and for whom.
```

**From the code files, found at the same time:**
```
🚨 [blog/index.html] Canonical points to /blog/index.html
   Google sees two versions of this page. Link authority is split.
   Fix: <link rel="canonical" href="https://yourdomain.com/blog/">

🚨 [contact/index.html, line 312] Redirect fires for all users
   Code meant to redirect mobile visitors also catches desktop users.
   Half of contact page visits bounce before the page loads.
   Fix: add a screen-width check before the redirect runs.

⚠️  [sitemap.xml] 5 URLs use .html extensions — Google prefers clean URLs
⚠️  [products/] 12 product pages are missing from the sitemap entirely
```

Claude then applied the canonical fix, cleaned the sitemap entries, and added the device check. All in the same conversation.

---

## Setup (5 minutes)

### Step 1 — Install Node.js

Download from [nodejs.org](https://nodejs.org), run the installer, done. Skip if you already have it.

### Step 2 — Create Google OAuth credentials

This is what gives Claude permission to read your Search Console data. It stays on your machine and nothing goes through any third-party service.

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create a project (click the dropdown at the top, New Project, any name)
3. **APIs & Services > Library**, search "Google Search Console API", Enable
4. **APIs & Services > Credentials > + Create Credentials > OAuth 2.0 Client ID**
5. Choose **Desktop app**, name it anything, Create
6. **Download JSON**, save it somewhere permanent (not the Downloads folder)

> If you see "Google hasn't verified this app": click **Advanced > Continue**. It's your own key accessing your own data.

### Step 3 — Run the setup script

**Windows:** double-click `setup.bat`

**Mac / Linux:** `chmod +x setup.sh && ./setup.sh`

The script asks for the JSON file path and your site URL, then writes everything to Claude's config automatically.

### Step 4 — Restart Claude and authorize

On first launch, Claude will show an authorization link. Open it, sign in with Google, approve. Done.

### Step 5 — Connect your project folder (optional but powerful)

In **Claude Cowork**: Settings, select your project folder.

This is what unlocks the code audit. Claude reads your HTML, sitemaps, and JavaScript and cross-references them with your traffic data. You can skip this if you only want the traffic analysis.

---

## What Claude can check

| Area | What it looks at |
|---|---|
| **Traffic drops** | Compares 3 time periods to isolate when and what fell |
| **CTR problems** | Where your position is good but nobody clicks |
| **Quick wins** | Queries on position 6-15 that could move with small fixes |
| **Content decay** | Pages that have been losing traffic for months |
| **Cannibalization** | Multiple pages competing for the same search query |
| **Canonical tags** | Wrong URL, `.html` extension, pointing to the wrong page |
| **Sitemap** | Dead URLs, missing pages, format inconsistencies |
| **JavaScript** | Syntax errors, redirect loops, auth issues, broken event handlers |
| **Schema markup** | Missing required fields for rich results (jobs, products, etc.) |
| **Deploy consistency** | Whether your source and production copies are actually in sync |

---

## Want Claude to visually test your site too?

Claude can install **Playwright**, a tool that opens a real browser in the background, and actually load your pages, follow redirects, and screenshot the results to verify fixes worked.

When you ask Claude to audit your site, it will ask: *"Do you want me to also visually test the pages in a browser? I can install Playwright for this. It runs in the background and doesn't open any windows."*

Just say yes and Claude handles the installation and testing automatically.

---

## Install the skills (Claude Cowork users)

Two skills available. Install both for the full experience.

**GSC Analyst** — guides Claude through traffic analysis with your Search Console data:
**[Download gsc-analyst.skill](./gsc-analyst.skill)**

**Project Auditor** — guides Claude through code auditing and cross-referencing with GSC:
**[Download project-auditor.skill](./project-auditor.skill)**

In Cowork: Settings > Skills > Install from file

---

## Troubleshooting

**"MCP server not connected"** — Restart Claude Desktop after running the setup script.

**"Authorization error"** — Run the Google OAuth flow again. Sometimes it needs a second attempt.

**"Site not found" or wrong data** — Check `GSC_SITE_URL` in your Claude config. Domain properties use `sc-domain:yourdomain.com`. URL prefix properties use `https://yourdomain.com/`.

**Node.js not found after installing** — Close and reopen your terminal after installing.

**Claude can't see my files** — In Cowork, go to Settings and make sure your project folder is selected.

---

## How it works (technical)

The GSC connection uses [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp), a local MCP server that runs via `npx`, authenticates with your Google OAuth credentials, and passes Search Console data directly to Claude. Nothing leaves your machine.

The code audit uses Claude's native file access in Cowork. Claude reads your files directly and runs analysis in an isolated Linux environment. No extra MCP or tools required.

```
Traffic data:  Claude <-> MCP server (local, npx) <-> Google Search Console API
Code audit:    Claude <-> Your project folder (direct file access)
Combined:      Claude connects both, finds the root cause, not just the symptom
```

---

## Contributing

Found a bug pattern worth adding to the auditor? A better analysis prompt? Open a PR.

---

## License

MIT — use it, fork it, share it.

---

*Built by [Fernandes](https://github.com/sabnck) while doing an actual production site audit with Claude.*
*Every issue in the examples above was found and fixed in a real site during a single conversation.*
