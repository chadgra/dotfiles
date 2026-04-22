---
name: gitlab-mr-review
description: Interactively review a GitLab MR with AI assistance. Fetches the MR, analyzes the diff, and walks through issues one at a time — you decide post/skip/edit for each. Posts approved inline comments directly to GitLab via the API. Trigger with "review MR <number>", "help me review MR <number>", or "look at MR <number>". Works on gitlab.com. Requires GITLAB_TOKEN env var or ~/.gitlab_token.
---

# GitLab MR Review

Orchestrates a full interactive MR review: fetch → analyze → post.

## How to invoke

Say something like:
- "Review MR 1234"
- "Help me review MR 42"
- "Let's look at MR 99 in myorg/myrepo"

You can optionally provide a project path if you're not in the repo's directory:
- "Review MR 12 in vivint/camera-build"

## Before starting: verify auth

```bash
GITLAB_TOKEN="${GITLAB_TOKEN:-$(cat ~/.gitlab_token 2>/dev/null)}"
[ -z "$GITLAB_TOKEN" ] && echo "ERROR: No GITLAB_TOKEN found" && exit 1
echo "Token found (${#GITLAB_TOKEN} chars)"
```

If no token found, stop immediately and tell the user:
> "Set $GITLAB_TOKEN in your environment or create ~/.gitlab_token with your GitLab personal access token (needs `api` scope). Then try again."

## Phase 1: Fetch

Invoke the `gitlab-mr-fetch` skill with the MR IID (and optional project path if provided).

This builds the context block: MR metadata, diff, full file contents, SHAs (base/head/start), and existing inline comments. All subsequent phases depend on this context staying in the conversation.

## Phase 2: Analyze

Once the fetch phase is complete and the context block is in the conversation, invoke `gitlab-mr-analyze`.

This walks through findings one at a time. You respond with `post`, `skip`, or `edit` for each. On `post` or `edit`, Phase 3 fires automatically.

## Phase 3: Comment (automatic per approved comment)

The analyze phase invokes `gitlab-mr-comment` for each approved finding — you don't need to trigger this manually during a normal review.

You can also invoke `gitlab-mr-comment` directly at any time if you want to post a comment outside the review flow:
> "Post an inline comment on src/foo.rs line 42 saying 'This needs error handling'"

## Full flow

```
1. gitlab-mr-fetch  → builds context (metadata, diff, SHAs, existing comments)
2. gitlab-mr-analyze → issue loop:
     for each finding:
       present issue → wait → post/skip/edit
       on post/edit → gitlab-mr-comment → confirm → next issue
3. summary + optional overall verdict (approve / request changes / comment-only)
```

## Tips

- You can ask questions about any issue before deciding — just ask and the issue will be re-presented after the answer
- `skip` is always safe if you're uncertain — you can review the diff yourself after
- If a comment fails to post, you'll be offered retry or skip — the review continues regardless
- Run from inside the repo directory for automatic project path detection; use "in org/repo" to override
