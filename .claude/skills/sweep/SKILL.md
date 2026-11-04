---
name: sweep
description: Run a watcher sweep — check every source in watch.yaml for news since the last sweep, file new signals in data/items.jsonl, update threads, rebuild the page, push, and report to HQ. Use when the daily cron fires, when Ben says "sweep", "what's new", "check the scene", or when an HQ Dispatch job asks for a sweep.
---

# Sweep

One pass over the topic. Output: new signals on the page, an HQ page, one HQ chat line.

## 0. Orient (1 minute)

- Read `watch.yaml` (scope, beats, sources, heat rubric), `data/site.json` (`last_sweep`), `data/threads.json`.
- `learnings list` for this project — past corrections from Ben about what he does and doesn't want.
- Window = from `last_sweep` to now. Cold start (no `last_sweep`) = `cadence.lookback_days`.

## 1. Gather

- **Every `sources.primary`** — WebFetch the URL, ask for items dated inside the window.
- **Two or three `sources.secondary`** — rotate; note which you checked in the run log so the next sweep picks others.
- **Each `search_queries` entry** — WebSearch, `standard` mode. Use `extended` only when a thread needs a fresh or hard-to-find fact.
- **Each open thread** — one targeted search for its `question`. If it has a `next` date that has passed, find out what happened.
- **Unverified items** (`verified:false`) — open the URL. If it checks out, set `verified:true` and correct the summary if needed. If the page is gone or says something else, fix or remove the item and say so in the report.

Stay inside `topic.scope`; skip anything in `out_of_scope`.

## 2. Filter and file

For each candidate:

1. Is it in the window and in scope? Is the source one you opened? If not, drop it.
2. Already filed (same URL, or same news from another site)? → add the URL to that item's `links`. Done.
3. Find the **original** source (developer page, party results, vendor) and use that as `url`; the news site goes in `links`.
4. Write `title` (≤ 12 words) and `summary` (≤ 40 words) **in your own words**. See CLAUDE.md house rules.
5. Pick one `beat`. Score `heat` with the rubric — most things are 2–3.
6. Attach to a `thread` if it moves one forward.
7. Append the line to `data/items.jsonl`.

## 3. Threads

- Update each touched thread: `status` (`heating` = moving fast, `watching` = normal, `cooling` = quiet), `next` / `next_label` if a date is known, sharpen the `question`.
- **New thread** when a story will clearly need following across sweeps (a dated launch, an ongoing dispute, a project with milestones). Keep ≤ `threads_max_open`. Create a Sentinel issue labelled `thread` with the question as the body.
- **Resolved** threads: set status `cooling`, and close the Sentinel issue with one line on how it ended. Remove from `threads.json` one sweep later.

## 4. Build, check, ship

```bash
node scripts/build.mjs --check   # must pass
node scripts/build.mjs
```

- Set `data/site.json`: `last_sweep` = now (ISO with offset), `sweeps` += 1. Rebuild.
- Commit `data/` (and any `docs/` write-ups): `sweep YYYY-MM-DD: N new signals` (list titles in the body). Push to `main`. Pages redeploys on its own; `feed.js` is gitignored.
- `provenance` event: sweep completed, N new, sources checked.

## 5. Report to HQ

- `views propose` (audience `org`) a page, slug `amigabot-sweep-YYYY-MM-DD`, title `Amigabot · <Mon D>`: new signals grouped by beat, thread updates, link to the public page.
- **Fridays:** also write `docs/transmissions/YYYY-MM-DD.md` (the week's 5–10 best signals, a paragraph per thread) and propose it as a page `amigabot-transmission-YYYY-MM-DD`.
- **One HQ chat message:** a line with the count and the hottest 1–3 titles, then up to 3 `ASK:` lines, each offering a deep dive ("ASK: Dive into the THEA1200 launch reception?"). If nothing new, say so in one line and skip ASKs.
- If the HQ daemon isn't reachable, still finish steps 1–4 and log `friction` ("HQ unreachable during sweep").

## 6. Close

- `learnings append` anything the next sweep should know (a source that moved, a site that blocks fetching, a beat that's always empty).
- `friction log` a source that keeps failing.
