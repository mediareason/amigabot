---
name: new-watch
description: Spin up a new watcher for a different topic from this repo as the template. Use when Ben says "make a watcher for X", "new bot for <topic>", "use amigabot as a template for …".
---

# New watcher from this template

Goal: a new Decibel project repo that watches a new topic, with the engine untouched and only the topic swapped.

1. **Interview briefly** (skip what Ben already said): the topic in one line, what's out of scope, 3–5 sources he already trusts, how often (daily / weekly), and the visual vibe for the page.
2. **Create the repo** under `mediareason` via GitHub MCP, named `<topic>bot` unless Ben names it. Ask public or private.
3. **Copy** everything from this repo except `data/items.jsonl`, `docs/transmissions/*`, `docs/dives/*`, `.decibel/` contents.
4. **Rewrite `watch.yaml`** for the new topic: scope, 6–8 beats, primary/secondary sources (verify each URL loads), search queries, heat rubric examples in the topic's terms.
5. **Reset data:** empty `items.jsonl`, `threads.json` = `[]`, `site.json` with the new title/repo and no `last_sweep`.
6. **Re-skin `index.html`:** the BEATS list must match `watch.yaml` beats; change the palette tokens on `:root`, the font, the header effect and the pixel icons to fit the topic's era/vibe. Keep the structure (drawers / signals / threads / meters).
7. **Decibel init:** new `.decibel/manifest.yaml`, CLAUDE.md with the decibel block and the watcher section rewritten for the topic; register it (`registry add`).
8. **Cold-start sweep** with the `sweep` skill (lookback = `cadence.lookback_days`) so the page ships with real content.
9. Copy `scripts/sweep.sh` and add the cron line for the new session prefix.
10. Record an ADR in the new project: "Forked from amigabot @ <commit>".

If the engine needed a change to fit the new topic, make that change **here in amigabot first** (generic, not topic-specific), then copy it. The template only stays a template if fixes flow back.
