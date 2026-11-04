---
name: deep-dive
description: Investigate one thread or signal in depth and publish a write-up to docs/dives/. Use when Ben says "dive into X", "dig into", "what's the full story on", when an HQ ASK for a dive is answered yes, or when an HQ Dispatch job says "dive <thread-id>".
---

# Deep dive

A sweep is wide and shallow. A dive is one story, top to bottom.

## Scope it

- Identify the thread (`data/threads.json`) or item (`data/items.jsonl`). If neither exists, it's still fine — make the dive, then offer to open a thread.
- Write down the one question the dive answers. Usually the thread's `question`.

## Research

- Start from every URL already filed on the thread (items + `links`).
- 5–15 searches: original announcements, developer/vendor pages, forum threads with first-hand reports, party results, interviews. Prefer primary sources.
- Build a dated timeline as you go.
- Note disagreements between sources instead of picking one silently.

## Write `docs/dives/<thread-id>-YYYY-MM-DD.md`

```
# <Story title>
_Amigabot deep dive · <date>_

**Short answer:** 2–3 sentences answering the question.

## Timeline
- YYYY-MM-DD — what happened ([source](url))

## What we know / what we don't
## What to watch next
## Sources
```

Own words throughout (CLAUDE.md house rules). Keep it under ~800 words.

## Ship

- Add any newly found signals to `data/items.jsonl` (normal filing rules).
- Update the thread (`status`, `next`, sharper `question`). Link the dive from the thread with a `dive` field: `"dive": "dives/<file>.md"`.
- Build, check, commit `dive: <thread-id>`, push.
- `views propose` the dive as an HQ page (audience `org`), and send one HQ chat line with the short answer + link.
- `learnings append` anything surprising about where good information lives for this topic.
