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

## Analysis approach

Read the entire diff and all full file contexts before surfacing any issues. Build a complete internal list of findings. Then work through them one at a time — never dump the full list to the user.

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
File: <path>, line <N>
Change: <one sentence: what the code change actually does>
Concern: <one sentence: what might be wrong or worth discussing>

Suggested comment:
"<draft comment text written as if you are the reviewer — specific, actionable, collegial>"

[post] [skip] [edit]
```

- `N` = current issue number (1-indexed)
- `M` = estimated total (can be approximate, e.g. "~5")
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

**`skip`**:
- Note it as skipped internally
- Move to the next issue immediately

**`edit`**:
- Ask: "What should the comment say?"
- Wait for the user to provide revised text
- Then invoke `gitlab-mr-comment` with the revised text
- After confirmed posted, move to the next issue

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
- **Comment-only**: Done, no action needed
