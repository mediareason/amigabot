# Amigabot

```
 ___________________________________________
|                                           |
|   AMIGABOT  ·  signals from the scene     |
|___________________________________________|
```

An agent that keeps tabs on the retro **Amiga** scene — new hardware, games and ports, demoparties, OS and app releases, emulators, events, magazines, and the business of the Amiga name — and publishes it as a Workbench-flavoured feed.

**Live page:** https://mediareason.github.io/amigabot/ (GitHub Pages from the repo root)

Built by [Decibel](https://decibel.systems) on Decibel Tools + HQ. It's also our **template for watchers**: point it at another topic by editing one file.

## How it works

```
 cron / HQ Dispatch ──▶ sweep skill ──▶ data/items.jsonl ──▶ index.html (Pages reads data/)
                             │                 │
                             │                 └──▶ threads.json ◀──▶ Sentinel "thread" issues
                             └──▶ HQ page + HQ chat line with ASK buttons ──▶ deep-dive skill
```

- **Sweep** (daily): checks every source in `watch.yaml`, files new **signals** by *beat* (hardware, games, scene…) and *heat* (1–5), follows **threads** (ongoing stories like the THEA1200 launch), commits the data, and posts a summary to HQ.
- **Deep dive** (on request): one story top to bottom, written up in `docs/dives/`.
- **Transmission** (Fridays): the week's best, in `docs/transmissions/`.

## Layout

| Path | What |
|---|---|
| `watch.yaml` | Topic definition — scope, beats, sources, heat rubric. **The one file to change for a new topic.** |
| `data/items.jsonl` | Signal store, one JSON object per line |
| `data/threads.json` | Stories being followed |
| `data/site.json` | Feed metadata |
| `index.html` | The page — static, no framework; reads `data/` directly |
| `docs/` | Weekly transmissions and deep dives |
| `scripts/build.mjs` | Validates `data/`; writes a gitignored `feed.js` so the page opens from disk (no dependencies) |
| `scripts/sweep.sh` | Cron trigger into the running agent session |
| `.claude/skills/` | `sweep`, `deep-dive`, `new-watch` |
| `CLAUDE.md` | Agent instructions and house rules |

## Run it

```bash
node scripts/build.mjs --check   # validate data
node scripts/build.mjs           # validate + write feed.js for local viewing
open index.html                  # works straight from disk
```

Agent side: open the project in a Claude Code session with Decibel Tools connected and say **sweep**, or hit Dispatch on the project in HQ.

## Ground rules

Every signal links to its source. Summaries are written fresh, never copied. Items tipped in by hand show as *unverified* until a sweep checks them. See `CLAUDE.md`.

## License

Code: MIT. Signals are short original summaries linking to their sources; all linked content belongs to its owners. Amiga is a trademark of its respective owner; this project is unaffiliated.
