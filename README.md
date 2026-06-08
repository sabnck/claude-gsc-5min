# 🔍 Ask Claude About Your Google Search Console — Setup in 5 Minutes

> No dashboards. No CSV exports. No SEO tools. Just ask Claude directly.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Works with Claude Desktop](https://img.shields.io/badge/Claude-Desktop-orange)](https://claude.ai/download)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-blue)](https://modelcontextprotocol.io)

---

## What This Is

A 5-minute setup that connects **Claude Desktop** (free) to your **Google Search Console** data using MCP (Model Context Protocol).

Once connected, Claude can see your actual traffic numbers and answer questions like a senior SEO analyst — no subscription, no dashboard, no learning curve.

---

## What You Can Ask

```
"Why did my homepage traffic drop 80% this month?"

"Which pages have the worst click-through rates?"

"I rank #1 for some keywords but get 0 clicks — what's happening?"

"Find my fastest-decaying content before it falls off completely."

"What are my easiest quick wins this week?"

"Are any of my pages competing against each other for the same query?"
```

Claude pulls the real data from your Search Console and explains what's happening — in plain language.

---

## What You Need

| Requirement | Notes |
|---|---|
| [Claude Desktop](https://claude.ai/download) | Free plan works |
| [Node.js](https://nodejs.org) v18+ | Just the installer, ~30 seconds |
| Google Search Console | Any property you own |
| ~5 minutes | Seriously |

---

## Setup

### Step 1 — Install Node.js (skip if you already have it)

Download from [nodejs.org](https://nodejs.org) and run the installer. That's it.

### Step 2 — Create your Google OAuth credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project (name it anything — "Claude GSC" works)
3. Go to **APIs & Services → Library** → search **Google Search Console API** → Enable
4. Go to **APIs & Services → Credentials → + Create Credentials → OAuth 2.0 Client ID**
5. Choose **Desktop app**, name it anything, click **Create**
6. Click **Download JSON** — save the file somewhere you'll find it

> **First time using Google Cloud Console?** The script will walk you through each screen.

### Step 3 — Run the setup script

**Windows:**
```
Double-click setup.bat
```

**Mac / Linux:**
```bash
chmod +x setup.sh && ./setup.sh
```

The script will:
- Check that Node.js is installed
- Ask you to paste the path to the OAuth JSON you downloaded
- Ask for your site URL
- Write everything to your Claude config automatically
- Tell you exactly what to do next

### Step 4 — Restart Claude and authorize

When Claude opens, it will ask you to authorize with Google. Follow the link, approve the permissions, and you're done.

---

## Example Output

After setup, open Claude and type:

> *"Give me a full SEO analysis of my site"*

Claude will run multiple checks automatically and respond with something like:

```
📊 Site Overview (last 28 days)
   Clicks: 1,247  |  Impressions: 18,432  |  CTR: 6.8%  |  Avg position: 14.2

🚨 Critical Issue Found
   Your homepage dropped 81% in clicks over the last 3 weeks.
   Position is stable at 2.9 — this is a CTR problem, not a ranking problem.
   The title tag "Welcome to Our Website" doesn't match what users searched for.

⚡ Quick Wins (this week)
   3 pages ranking on position 6-10 with high impressions but low CTR.
   Fixing their title tags could recover ~40 clicks/week with no link building.

📉 Content Decay
   2 articles have been losing traffic for 4+ months.
   They rank for informational queries that now have AI overviews above them.
```

---

## What Claude Can Do With Your GSC Data

| Analysis | What it checks |
|---|---|
| **Traffic drops** | Compares 3 time periods, isolates pages and queries that fell |
| **CTR opportunities** | Pages where your ranking vs click rate is below benchmark |
| **Quick wins** | Queries on position 6–15 where small improvements = big gains |
| **Content decay** | Pages with 3+ months of consistent decline |
| **Cannibalization** | Multiple URLs competing for the same query |
| **Content gaps** | Queries where you have impressions but no real content |
| **Sitemap audit** | Errors, missing pages, coverage issues |
| **URL inspection** | Index status, mobile usability, last crawl date |

---

## Install the Companion Skill (Claude Cowork users)

If you use **Claude Cowork**, install the companion skill. It teaches Claude to:
- Guide you through setup step by step
- Run the right analyses automatically for your situation
- Give you a structured report instead of a raw data dump

**[Download gsc-analyst.skill](./gsc-analyst.skill)**

In Cowork: Settings → Skills → Install from file → select `gsc-analyst.skill`

---

## How It Works (Technical)

This uses [suganthan-gsc-mcp](https://www.npmjs.com/package/suganthan-gsc-mcp), a local MCP server that runs on your machine via `npx`. It authenticates with Google using your OAuth credentials and exposes 20 Search Console tools to Claude via the Model Context Protocol.

**Your data never leaves your machine.** The MCP server runs locally, talks directly to Google's API, and passes data to Claude Desktop (also local). Nothing goes through any third-party service.

```
Claude Desktop ←→ MCP Server (local, npx) ←→ Google Search Console API
```

---

## Troubleshooting

**"MCP server not connected" in Claude**
→ Make sure you restarted Claude Desktop after running the setup script.

**"Authorization error" when Claude first connects**
→ Run through the Google OAuth flow again. Sometimes it needs a second attempt.

**"Site not found" or wrong data**
→ Open your Claude config file and check the `GSC_SITE_URL` value. Domain properties use `sc-domain:yourdomain.com`, URL prefix properties use `https://yourdomain.com/`.

**Node.js not found after installing**
→ Close and reopen your terminal/command prompt after installing Node.js.

---

## Contributing

Found a better prompt? A more useful analysis? Open a PR — this is meant to grow.

---

## License

MIT — use it, fork it, share it.

---

*Built by [Fernandes](https://github.com/sabnck) while doing actual SEO analysis with Claude.*  
*The analyses in the examples above are real outputs from a live site audit.*
