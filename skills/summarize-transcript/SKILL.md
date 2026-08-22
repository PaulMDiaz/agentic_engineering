---
name: summarize-transcript
description: Use when the user asks to summarize, parse, or extract decisions from a meeting transcript such as a .vtt file.
---

# Summarize Transcript

Create a concise Markdown summary from a meeting transcript, usually a `.vtt` file copied
from Microsoft Teams or another meeting tool.

## Process

1. Read the transcript file the user provided. If the path is outside the current
   workspace and cannot be read, ask for access or for the file contents.
2. Parse transcript content before summarizing:
   - Ignore `WEBVTT` headers, cue numbers, timestamps, and formatting metadata.
   - Preserve speaker names when available.
   - Merge fragmented cue text into coherent speaker turns.
   - Remove obvious duplicate caption fragments without changing meaning.
3. Create a 1-2 page Markdown file unless the user asks for a different length.
4. If the user does not provide an output path, write a file named
   `<transcript-name>-summary.md` in the current working directory.
5. Include only information supported by the transcript. Mark unknown owners, dates, or
   conclusions as `Unassigned`, `No due date stated`, or `Not resolved`.

## Output Structure

Use this structure:

```markdown
# Transcript Summary

Source: <transcript filename>

## Executive Summary

<Short narrative summary of the meeting's purpose, major discussion points, outcomes, and
important context.>

## Action Items

| Owner | Action | Due Date / Trigger | Notes |
| --- | --- | --- | --- |
| <name or Unassigned> | <specific action> | <date, trigger, or No due date stated> | <brief context> |

## Unresolved Questions

- <Question or unresolved issue> - <who raised it / relevant context if known>

## Architectural Design Decisions

### <Decision title>

- **Decision:** <What was decided>
- **Context:** <Why this came up>
- **Alternatives:** <Real alternatives discussed or implied>
- **Rationale:** <Why this option was chosen>
- **Trade-off:** <What was gained and what was accepted>
- **Reversal cost:** <Why changing this later would be meaningful>
```

If a section has no transcript-backed content, keep the heading and write `None identified`.

## ADR Filter

Record an architectural design decision only when all three are true:

- **Hard to reverse:** changing the decision later would have meaningful cost.
- **Surprising without context:** a future reader would plausibly wonder why the team did
  it this way.
- **Result of a real trade-off:** there were genuine alternatives and the team chose one
  for specific reasons.

Skip decisions that are easy to reverse, obvious from the code or context, or not the
result of a real alternative. Those may belong in the executive summary, not the ADR
section.

## Quality Bar

- Prefer crisp synthesis over chronological minutes.
- Do not invent owners, deadlines, agreements, or decision rationale.
- Keep action items concrete and executable.
- Keep unresolved questions distinct from action items.
- Quote sparingly only when exact wording matters.
