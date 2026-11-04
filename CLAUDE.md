<!-- decibel:start -->
## Decibel Tools — project memory

This project uses Decibel Tools (MCP). **Decibel is the durable memory for this project. Your own session memory is a cache.** It is not visual, it does not survive a crash, and it is not shared with the other people and agents on this project. Anything worth remembering past this session goes into Decibel, not into a scratch file or your memory.

- **Start of session:** `oracle next_actions`, then `roadmap read` to see where the project is and what the current milestone is.
- **During work:** track tasks with `sentinel create_issue` / `close_issue`. Record *why* with `architect create_adr`. Log recurring pain with `friction log`.
- **Before stopping:** `learnings append` anything the next session must know. Close what you finished.

Never create manual folders or markdown files for epics, issues, ADRs, proposals, or wishes. Use the tools. Full reference: `templates/AGENT.md` in `@decibelsystems/tools`.
<!-- decibel:end -->

## Amigabot

Amigabot is a **watcher**: an agent that keeps tabs on one topic — here, the retro Amiga scene — and turns what it finds into a living, visual feed. It is also Decibel's **template for watchers**: everything topic-specific lives in `watch.yaml` and `data/`; everything else should work unchanged for any other topic (see `TEMPLATE.md`).

### What it does

| Verb | Skill | When |
|---|---|---|
| **sweep** | `.claude/skills/sweep` | Daily (cron → `scripts/sweep.sh`), or when Ben says "sweep", or an HQ Dispatch job asks for one |
| **deep-dive** | `.claude/skills/deep-dive` | When Ben (or an HQ ASK answer) asks to dig into a thread or item |
| **digest** | part of `sweep` on Fridays | Weekly "transmission" page in HQ |

If an HQ Dispatch job (`.decibel/agentic/jobs/JOB-*.yml`) just says "sweep" or "dive <thread>", run the matching skill.

### Where things live

- `watch.yaml` — topic definition: scope, beats, sources, heat rubric. Read it at the start of every sweep. Change it only when Ben asks.
- `data/items.jsonl` — the signal store. One JSON object per line, append-only in spirit (edit a line only to correct it). **This is the source of truth for the feed.**
- `data/threads.json` — ongoing stories. Each open thread is mirrored by a Sentinel issue labelled `thread`.
- `data/site.json` — feed metadata (`last_sweep`, `sweeps` counter).
- `index.html` — the public page (GitHub Pages from the repo root). It reads `data/` directly, so a sweep only needs to commit data. `node scripts/build.mjs` validates `data/` and writes a gitignored `feed.js` so the page also opens from disk.
- `docs/transmissions/` — weekly digests (markdown). `docs/dives/` — deep-dive write-ups.

### Item schema (`data/items.jsonl`)

```json
{"id":"YYYY-MM-DD-short-slug","date":"YYYY-MM-DD","beat":"games","heat":3,
 "title":"…","summary":"…","source":"Site name","url":"https://…",
 "thread":"thread-id or null","links":["optional extra urls"],
 "date_approx":true, "via":"ben", "verified":false}
```

`date_approx`, `via`, `verified` and `links` are optional. `verified:false` marks an item that came from a human tip and hasn't been checked against its source by a sweep yet; the page labels it.

### House rules

1. **Every item links to a source you actually opened this sweep** (or one Ben gave you, marked `via:"ben"`). No source, no item.
2. **Write in your own words.** Title ≤ 12 words, summary ≤ 40 words. Never paste sentences from a source; at most one quoted phrase under 15 words, and only when the exact wording matters. Never reproduce lyrics, tracker module text, or magazine pages.
3. **Prefer the original source** over a re-report (the developer's itch.io page over a news site that covered it).
4. **Dedupe** by URL and by meaning: if the same news is already filed, add the new URL to `links` instead of a new item.
5. **Heat honestly** using the rubric in `watch.yaml`. Most items are 2–3. A 5 should be rare.
6. **No rumour without a named source.** Forum speculation can feed a thread's question, not an item.
7. The repo is **public**. Nothing private goes in it: no HQ chat contents, no names of people who aren't public figures in the scene, no Decibel business.
8. Always `node scripts/build.mjs --check` before committing; it must pass.

### HQ integration (see ADRs)

- **Dispatch in:** HQ's project page Dispatch button → daemon `agentic.enqueue` → worker runs this repo with the prompt. "sweep" / "dive <id>" are the verbs.
- **Pages out:** after each sweep, `views propose` a page in HQ (audience `org`) summarising what's new; on Fridays, the weekly transmission.
- **Chat out:** one HQ chat line per sweep with the top 1–3 signals and up to 3 `ASK:` buttons ("Dive into X?"). An answered ASK becomes a `deep-dive` job.
- **Threads:** each open thread = a Sentinel issue labelled `thread`; close the issue when the thread is resolved.
- **Provenance:** sweeps and dives emit `provenance` events, so "where did this come from" is answerable.
