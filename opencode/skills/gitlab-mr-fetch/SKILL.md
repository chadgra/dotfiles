---
name: gitlab-mr-fetch
description: Fetch all context needed to review a GitLab MR: metadata, diff, base/head SHAs, existing inline comments, and changed file list. Use this skill when starting a GitLab MR review or when you need to understand what changed in an MR. Works on gitlab.com. Requires GITLAB_TOKEN env var or ~/.gitlab_token file.
---

# GitLab MR Fetch

Collect everything needed to review a GitLab MR. This skill produces a structured context block used by the analyze and comment phases.

## Auth and project setup

```bash
GITLAB_TOKEN="${GITLAB_TOKEN:-$(cat ~/.gitlab_token 2>/dev/null)}"
if [ -z "$GITLAB_TOKEN" ]; then
  echo "No GitLab token found. Set \$GITLAB_TOKEN or create ~/.gitlab_token"
  exit 1
fi

REMOTE_URL=$(git remote get-url origin)
PROJECT_PATH=$(echo "$REMOTE_URL" \
  | sed 's|.*gitlab\.com[:/]||' \
  | sed 's|\.git$||')
PROJECT_PATH_ENCODED=$(echo "$PROJECT_PATH" | sed 's|/|%2F|g')

# MR_IID is the merge request number from the URL or user request (e.g., "MR 42" → MR_IID=42)
# Do NOT use the internal numeric 'id' field from the API — use 'iid' (the project-scoped number)
MR_IID=<number provided by user>
```

If the user provides a project path explicitly (e.g., "review MR 42 in myorg/myrepo"), use that instead of auto-detecting.

## Step 1: Fetch MR metadata and SHAs

```bash
MR_JSON=$(curl --silent \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}")

echo "$MR_JSON" | python3 -c "
import json,sys
mr = json.load(sys.stdin)
print('Title:', mr['title'])
print('Author:', mr['author']['name'])
print('Source branch:', mr['source_branch'])
print('Target branch:', mr['target_branch'])
print('State:', mr['state'])
print('Base SHA:', mr['diff_refs']['base_sha'])
print('Head SHA:', mr['diff_refs']['head_sha'])
print('Start SHA:', mr['diff_refs']['start_sha'])
print('Description:', mr.get('description','(none)')[:500])
"
```

Extract and hold in context:
- `BASE_SHA` = `mr.diff_refs.base_sha`
- `HEAD_SHA` = `mr.diff_refs.head_sha`
- `START_SHA` = `mr.diff_refs.start_sha` (use for `start_sha` in comment position — do NOT assume it equals base_sha)

## Step 2: Fetch the diff

```bash
glab mr diff "${MR_IID}" 2>/dev/null \
  || curl --silent \
       --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}/diffs" \
     | python3 -c "
import json,sys
diffs = json.load(sys.stdin)
for d in diffs:
    print(f'--- a/{d[\"old_path\"]}')
    print(f'+++ b/{d[\"new_path\"]}')
    print(d['diff'])
"
```

## Step 3: Fetch existing inline comments

Collect the set of already-commented `(file, line)` pairs so the analyze phase can skip them:

```bash
curl --silent \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}/discussions" \
| python3 -c "
import json,sys
discussions = json.load(sys.stdin)
commented = set()
for d in discussions:
    for note in d.get('notes', []):
        pos = note.get('position')
        if pos:
            path = pos.get('new_path') or pos.get('old_path')
            line = pos.get('new_line') or pos.get('old_line')
            if path and line:
                commented.add(f'{path}:{line}')
                print(f'  Already commented: {path}:{line}')
if not commented:
    print('  No existing inline comments.')
"
```

## Step 4: Read full file context for changed files

Get the changed file list from the API (reusing auth from above):

```bash
CHANGED_FILES=$(curl --silent \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "https://gitlab.com/api/v4/projects/${PROJECT_PATH_ENCODED}/merge_requests/${MR_IID}/diffs" \
  | python3 -c "
import json,sys
diffs = json.load(sys.stdin)
for d in diffs:
    print(d['new_path'])
")

for f in $CHANGED_FILES; do
  if [ -f "$f" ]; then
    echo "=== $f ==="
    cat "$f"
    echo ""
  else
    echo "=== $f (not in local checkout — using diff only) ==="
  fi
done
```

Note: for very large files, use judgment about whether to include full content or just the diff. Full content helps with understanding context but can flood the conversation.

## Output: context block

After running all steps, present a summary context block:

```
=== MR CONTEXT ===
Project:        <org/repo>
MR IID:         <number>  ← project-scoped number visible in the URL (iid), not the internal API id
Title:          <title>
Author:         <name>
Source branch:  <branch>
Target branch:  <branch>
State:          <open/merged/etc>

Base SHA:       <sha>
Head SHA:       <sha>
Start SHA:      <sha>

Changed files:  <N> files
  - <file1>
  - <file2>
  ...

Existing inline comments: <N> (will be skipped in analysis)

Diff and file context loaded. Ready for analysis.
=================
```

This context block stays in the conversation for the analyze and comment phases.
