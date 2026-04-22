---
name: gitlab-mr-comment
description: Post a single inline comment on a GitLab MR diff using the GitLab REST API via curl. Use this skill when you need to post an inline review comment on a specific file and line in a GitLab merge request. Required when glab CLI cannot post inline/positional comments. Needs GITLAB_TOKEN env var, project path, MR IID, base SHA, head SHA, file path, line number, and comment text.
---

# GitLab MR Inline Comment

Post a single inline diff comment on a GitLab MR using the REST API.

## Why curl, not glab

`glab` cannot post positional (inline) comments — it only supports general MR comments. The GitLab API requires a `position` object with SHAs and line info for inline placement. Always use curl for this.

## Auth setup

Read the token:
```bash
# Prefer env var
GITLAB_TOKEN="${GITLAB_TOKEN:-$(cat ~/.gitlab_token 2>/dev/null)}"
```

If neither exists, stop and tell the user:
> "No GitLab token found. Set $GITLAB_TOKEN or create ~/.gitlab_token with your personal access token."

## Get project path

```bash
REMOTE_URL=$(git remote get-url origin)
# Handles both SSH (git@gitlab.com:org/repo.git) and HTTPS (https://gitlab.com/org/repo.git)
PROJECT_PATH=$(echo "$REMOTE_URL" \
  | sed 's|.*gitlab\.com[:/]||' \
  | sed 's|\.git$||')
# URL-encode the slash: org/repo → org%2Frepo
PROJECT_PATH_ENCODED=$(echo "$PROJECT_PATH" | sed 's|/|%2F|g')
```

## Determine line side

- Line was **added or unchanged** in the new version → use `new_path` + `new_line`
- Line was **deleted** (only exists in old version) → use `old_path` + `old_line`
- When in doubt about a context line, prefer `new_path` + `new_line`

## Post the comment

### New/context line (most common)

```bash
curl --silent --request POST \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{
    \"body\": \"${COMMENT_BODY}\",
    \"position\": {
      \"base_sha\": \"${BASE_SHA}\",
      \"head_sha\": \"${HEAD_SHA}\",
      \"start_sha\": \"${START_SHA}\",
      \"position_type\": \"text\",
      \"new_path\": \"${FILE_PATH}\",
      \"new_line\": ${LINE_NUMBER}
    }
  }" \
  "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}/discussions"
```

### Deleted line (old side only)

```bash
curl --silent --request POST \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{
    \"body\": \"${COMMENT_BODY}\",
    \"position\": {
      \"base_sha\": \"${BASE_SHA}\",
      \"head_sha\": \"${HEAD_SHA}\",
      \"start_sha\": \"${START_SHA}\",
      \"position_type\": \"text\",
      \"old_path\": \"${FILE_PATH}\",
      \"old_line\": ${LINE_NUMBER}
    }
  }" \
  "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}/discussions"
```

## Handle the response

Parse the curl output (it returns JSON):

**Success** — response contains `"id"` and `"notes"`. Extract and show the web URL:
```
✓ Comment posted: https://gitlab.com/<project>/-/merge_requests/<iid>#note_<note_id>
```

**Failure** — response contains `"message"`. Show the error clearly:
```
✗ Failed to post comment: <message value>
```

Common failures and fixes:
| Error | Cause | Fix |
|---|---|---|
| `invalid line_range` | Line number doesn't exist in diff | Check the diff — use the exact line number shown |
| `Note {:base_sha=>...} is invalid` | SHA mismatch | Re-fetch the MR to get current SHAs |
| `401 Unauthorized` | Bad or missing token | Check `$GITLAB_TOKEN` |
| `404 Not Found` | Wrong project path or MR IID | Verify with `git remote get-url origin` and MR number |

If posting fails, offer the user two choices:
1. Retry with corrected info (ask what to change)
2. Skip this comment and continue the review
