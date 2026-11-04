# Using Amigabot as a template

Amigabot is built so that the **engine** (skills, build script, page structure, HQ wiring) is topic-neutral, and the **topic** lives in two places:

| Topic-specific | Engine (don't fork-edit) |
|---|---|
| `watch.yaml` | `.claude/skills/sweep`, `deep-dive` |
| `data/*` | `scripts/build.mjs` (except the `BEATS` list) |
| Page skin: palette tokens, font, header effect, pixel icons, `BEATS` list in `index.html` | Page structure: drawers / signals / threads / meters |
| Watcher section of `CLAUDE.md` | Decibel block, house rules |

## Fastest path

In a session on this repo, say: **"make a watcher for <topic>"**. The `new-watch` skill interviews you briefly, creates the repo, rewrites `watch.yaml`, re-skins the page for the topic's era, runs a cold-start sweep, and records an ADR.

## By hand

1. Copy the repo; clear `data/items.jsonl`, set `data/threads.json` to `[]`, reset `data/site.json`.
2. Rewrite `watch.yaml`. Keep beats to 6–8.
3. Update `BEATS` in both `scripts/build.mjs` and `index.html` to match.
4. Re-skin: change `:root` tokens, the font link, the `copper` canvas effect, and the `PIX` icons.
5. New `.decibel/manifest.yaml`, register the project, run a sweep.

## Ideas this should stretch to

Watchers for: a client's competitive landscape, a component supply market, a Japanese hardware scene, a research field, a set of GitHub repos. If a topic needs a source type the sweep can't handle (an API, an RSS feed, a Slack channel), add it to the **engine** here as a generic `kind`, then fork.
