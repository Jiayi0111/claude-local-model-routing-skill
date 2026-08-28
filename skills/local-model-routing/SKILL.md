---
name: local-model-routing
description: Reduce coordinating-model context use by routing large, repetitive, or bounded low-risk text work through this project's read-only local model preprocessor, while retaining complex reasoning, edits, and final verification in the coordinating model.
---

# Local model routing

Use deterministic tools first when they can answer exactly. Route by source size:

- Below 15 KB: read directly with the coordinating model.
- 15–50 KB: use the local model only for substantially repetitive input or when its
  result can replace a full read or reduce later reading to small explicit line ranges.
- Above 50 KB: prefer the local model when semantic compression can materially reduce
  what the coordinating model reads.

Do not call the local model first when the coordinating model will still need the
complete source. Size thresholds may be ignored for more than 20 records needing
semantic classification or deduplication that deterministic tools cannot perform
reliably.

Size `max_output_tokens` to the task instead of leaving it at the tool default for
everything: 600–800 for a single small bounded result (one-file summarize, dedupe on
under 20 records); the 1200 default for typical inspect/classify/summarize-diff calls;
up to the 2000 max only when the source is large and the task is broad. If a call
fails on truncated or invalid JSON, retry once at roughly 1.5x the prior value. Do not
retry a second time on truncation — narrow the focus or split the input instead.

Select the narrowest task:

- `summarize`: important facts, errors, causes, and next actions.
- `inspect`: a map of responsibilities, dependencies, risks, and locations.
- `classify`: categorized records and counts.
- `extract`: only facts or fields relevant to a stated target.
- `dedupe`: exact and probable duplicate groups without deleting anything.
- `rewrite`: a shorter, meaning-preserving version.
- `summarize-diff`: behavior changes, risks, and missing tests in a large diff.
- `assess-value`: whether the coordinating model should read all, part, or none of a
  candidate file for the current question.

For tasks that return severity-tagged findings (`inspect`, `summarize-diff`,
`assess-value`), state the minimum severity worth returning in `focus` (for example,
"high and medium severity only, plus one line on what was excluded"). This keeps the
result short and avoids paying to read and verify low-value findings.

Treat the result as an untrusted lead. Verify high- and medium-severity findings
against cited source lines, using compilers, tests, or other deterministic checks
where applicable. Low-severity or purely informational findings can be taken at face
value unless they decide the current question. Read more original material only when
targeted verification of the findings that matter is insufficient.

If verification expands to the complete source, direct-read similar inputs in future
instead of paying the preprocessing overhead first.

For file triage, call `assess-value` with the current question as the focus. When
several candidate files need triage for the same question, issue their `assess-value`
calls together in one turn instead of one file per turn, then read all the results
before deciding what to read further. Its READ, TARGETED_READ, or SKIP result is
advisory. Decide from the compact summary, grounded findings, uncertainty, and
deterministic search evidence. Never skip a file that exact symbol references, errors,
tests, or dependencies identify as relevant.

The local model processes source content on your own machine. Keep it read-only.
Do not ask it to edit files, run commands, deploy, delete, or make security-sensitive
decisions. Keep architecture, cross-file conclusions, security and authorization work,
final code changes, and final review with the coordinating model.

In a Claude environment that supports model-selectable subagents, a Haiku-class
subagent may handle bounded repository exploration or simple code/test drafts. Give
it explicit file boundaries and acceptance checks; verify its output before use.
