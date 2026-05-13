---
name: gitlab-mr-analyze
description: Analyze a GitLab MR diff and walk through findings one issue at a time, presenting each with context and a draft comment, waiting for the reviewer to decide post/skip/edit before moving on. Use this skill after fetching an MR with gitlab-mr-fetch, or standalone when you already have the diff in context. Surfaces logic bugs, error handling gaps, security concerns, unclear naming, style issues, and missing tests.
---

# GitLab MR Analyze

Walk through a GitLab MR diff issue by issue. Present one finding at a time. Wait for the reviewer's decision before continuing.

## Prerequisites

This skill expects the following to already be in context (from `gitlab-mr-fetch`):
- The full diff
- Full file content for changed files
- The set of already-commented `(file, line)` pairs
- `BASE_SHA`, `HEAD_SHA`, `START_SHA`, `MR_IID`, `PROJECT_PATH`

If any of these are missing, run `gitlab-mr-fetch` first.

## Parsing line numbers from the diff

This is critical — incorrect line numbers cause comments to land on the wrong lines or fail entirely.

The diff uses unified diff format. Each file section has one or more hunk headers like:

```
@@ -10,6 +15,8 @@
```

This means: starting at old line 10 (6 lines), starting at new line 15 (8 lines). The `+15` is the `new_line` starting point for that hunk.

**To find the `new_line` for any line in the diff:**

1. When you see a `@@ ... +START,COUNT @@` header, the next line in the hunk is `new_line = START`
2. For each subsequent line in the hunk:
   - Lines starting with `+` (added): increment `new_line` counter, this is an added line
   - Lines starting with ` ` (context, no prefix): increment `new_line` counter, this is an unchanged line
   - Lines starting with `-` (removed): do NOT increment `new_line` (only `old_line`)
3. The `new_line` value at the moment you reach the relevant line is what to pass to the GitLab API

**Always derive line numbers by walking the diff — never estimate or guess.**

When presenting an issue, include a short snippet from the diff showing the relevant lines with their line numbers annotated. **Always include the hunk header (`@@ ... @@`) at the top of the snippet** — this makes the starting line number auditable and catches miscounts early.

For hunks that contain both additions and deletions, show both old and new line numbers side by side (old/new). For hunks that are purely additions or purely context, showing just the new line number is sufficient:

```
 @@ -40,6 +49,8 @@
 42/51  fn process_request(req: Request) -> Result<Response> {
   -52 -    let data = req.body;
   +52 +    let data = req.body.unwrap();   ← flagged line
   +53 +    process(data)
```

Lines prefixed with `+` are additions, `-` are deletions, and a space means context. Omit the word "line" — the numbers alone are enough.

**Verification step:** Before presenting each issue, recount from the hunk header's `+START` value to the flagged line using the rules above, and confirm the `new_line` in `File: <path>, <new_line>` matches.

## Analysis approach

If the diff has no issues worth raising, skip directly to the summary and tell the user: "I reviewed the diff and found no issues to flag. The changes look clean." Then offer the verdict as usual.

Read the entire diff and all full file contexts before surfacing any issues. Build a complete internal list of findings, recording the exact `new_line` (or `old_line` for deletions) for each by walking the diff as described above. Then work through them one at a time — never dump the full list to the user.

For each changed file, consider:
- Does this change introduce a logic bug?
- Is error handling correct and complete?
- Are there security concerns (injection, auth bypass, secret exposure)?
- Is naming clear and consistent with the rest of the file?
- Does the change need tests that aren't present?
- Does the change break existing contracts or interfaces?
- Are there style issues inconsistent with the surrounding code?

Skip findings for lines that already have an existing inline comment.

## Issue presentation format

Present each issue exactly like this — no deviations:

```
--- Issue N of ~M ---
File: <path>, <new_line>
Change: <one sentence: what the code change actually does>
Concern: <one sentence: what might be wrong or worth discussing>

```diff
 41/50  <context line>
   +42 +<added line>          ← relevant line
   +43 +<added line>
```

Suggested comment:
"<draft comment text written as if you are the reviewer — specific, actionable, collegial>"

[post] [skip] [edit]
```

The code snippet should show 1–3 lines of context above and below the flagged line. Use old/new number columns when the hunk has both additions and deletions; use a single new-line number when the hunk is additions/context only. This gives you enough context to understand the change and verify the line number before posting.

- `N` = current issue number (1-indexed)
- `M` = estimated total. Derive from the count of findings in your internal list. If you haven't fully enumerated yet, use a reasonable estimate based on the diff size.
- The line number shown in `File: <path>, <N>` is the `new_line` derived by walking the diff hunk (see "Parsing line numbers" above). For deleted-only lines use `old_line` and pass `old_line` to `gitlab-mr-comment` instead.
- The suggested comment should be written in first person as the reviewer, not as AI narrating

Wait for the user's response after each issue. Do not proceed until they respond.

## Handling user responses

**`post`** (or just pressing enter if they say post):
- Take the suggested comment text as-is
- Invoke the `gitlab-mr-comment` skill with:
  - The file path and line number from this issue
  - `BASE_SHA`, `HEAD_SHA`, `START_SHA` from context
  - `MR_IID` and `PROJECT_PATH` from context
  - The suggested comment body
- After the comment is confirmed posted, move to the next issue
- If the comment fails to post, the `gitlab-mr-comment` skill will offer retry or skip — follow its guidance before moving on.

**`skip`**:
- Note it as skipped internally
- Move to the next issue immediately

**`edit`**:
- Ask: "What should the comment say?"
- Wait for the user to provide revised text
- Then invoke `gitlab-mr-comment` with the revised text
- After confirmed posted, move to the next issue
- If the comment fails to post, the `gitlab-mr-comment` skill will offer retry or skip — follow its guidance before moving on.

**Any other response** (e.g., a question about the code):
- Answer the question
- Re-present the same issue with the same format afterward
- Wait for post/skip/edit

## After all issues

Present a summary:

```
=== Review complete ===
Issues found:   <total>
Comments posted: <N>
Skipped:        <M>
```

Then ask:
> "Would you like to submit an overall MR verdict? Options: approve, request changes, or leave as comment-only."

- **Approve**: `glab mr approve <MR_IID>`
- **Request changes**: Use the GitLab API — `POST /projects/:id/merge_requests/:iid/discussions` with `{ "body": "<overall feedback>" }` and no position object
- **Comment-only**: Tell the user: "Review complete — comments posted, no overall verdict submitted."
