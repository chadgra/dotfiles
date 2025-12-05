# Agent Routing Guide for OpenCode

This guide helps OpenCode automatically route requests to the right agents without 
the user having to specify them.

## Automatic Routing Rules

### By File Extension

| Extension | Primary Agent | Secondary Agents |
|-----------|--------------|------------------|
| `.lua` | lua-expert | performance, security |
| `.py` | python-expert | security, performance |
| `.rs` | rust-expert | security, performance |
| `.cpp`, `.cc`, `.cxx` | cpp-expert | security, performance |
| `.c`, `.h`, `.hpp` | cpp-expert | security, performance |
| `.toml` | config-expert | security |
| `.yml`, `.yaml` | config-expert | security |
| `.json` | config-expert | - |
| `.conf` | config-expert | security |
| `.zshrc`, `.bashrc` | config-expert | security, performance |
| `.zshenv`, `.zprofile` | config-expert | security |

### By File Path Pattern

| Path Pattern | Primary Agent | Secondary Agents |
|--------------|--------------|------------------|
| `nvim/lua/plugins/` | lua-expert | config-expert, performance |
| `nvim/lua/config/` | lua-expert | config-expert |
| `zsh/` | config-expert | security, performance |
| `git/` | config-expert | - |
| `tmux/` | config-expert | - |
| `kitty/` | config-expert | - |

### By User Intent Keywords

| Keywords | Route To |
|----------|----------|
| "review", "check" | review (auto-delegates) |
| "slow", "fast", "optimize", "performance" | performance |
| "secure", "security", "safe", "vulnerability" | security |
| "explain", "understand", "how does" | explain |
| "debug", "fix", "bug", "error" | debug |
| "refactor", "clean up", "improve structure" | refactor |
| "document", "docs", "comments" | document |
| "test", "TDD" | test-driven |

### By Code Content

When analyzing code content, trigger:

**security agent** if code contains:
- Password, credential, secret, token, API key
- Authentication, authorization, login
- File operations with user input
- SQL queries
- exec, eval, system calls
- Network operations

**performance agent** if code contains:
- Nested loops
- Large data operations
- Startup/initialization code
- Plugins loading on startup
- Heavy computations

**lua-expert** if code contains:
- `vim.api`, `vim.opt`, `vim.keymap`
- `require()`, `pcall()`
- LazyVim plugin specs
- Neovim autocommands

**python-expert** if code contains:
- Python type hints (`: str`, `-> int`)
- `async def`, `await`
- List comprehensions, decorators
- `requirements.txt`, `pyproject.toml`

**rust-expert** if code contains:
- `impl`, `trait`, `struct`, `enum`
- Lifetime annotations (`'a`)
- `Result<T, E>`, `Option<T>`
- `Cargo.toml`, `cargo` commands

**cpp-expert** if code contains:
- `std::`, `#include`, templates
- Smart pointers (`unique_ptr`, `shared_ptr`)
- `new`/`delete`, RAII patterns
- `CMakeLists.txt`

## Decision Tree for Main OpenCode Agent

```
User Request Received
│
├─ Is it a review request?
│  ├─ Yes → Use review agent (it will auto-delegate)
│  └─ No → Continue
│
├─ Does request mention specific concern? (perf, security, etc.)
│  ├─ Yes → Route to that specialist agent
│  └─ No → Continue
│
├─ What file type?
│  ├─ .lua → Consider lua-expert
│  ├─ .py → Consider python-expert
│  ├─ .rs → Consider rust-expert
│  ├─ .cpp/.c/.h → Consider cpp-expert
│  ├─ .toml/.yml/.json → Consider config-expert
│  ├─ Shell config → Consider config-expert
│  └─ Other → Continue
│
├─ What's the task?
│  ├─ Implement feature → test-driven
│  ├─ Fix bug → debug
│  ├─ Improve code → refactor
│  ├─ Explain code → explain
│  ├─ Add docs → document
│  └─ General work → Use main capabilities
│
└─ If multiple agents might help → Launch in parallel
```

## Examples of Automatic Routing

### Example 1: Simple File Review
```
User: "Check this file: nvim/lua/plugins/telescope.lua"

Routing Logic:
- File extension: .lua → lua-expert
- Path: nvim/lua/plugins/ → performance matters
- Word "check" → review coordinator
- Decision: Route to review agent → auto-delegates to lua-expert, performance

Result: Comprehensive review without user specifying agents
```

### Example 2: Performance Question
```
User: "Why is my shell slow to start?"

Routing Logic:
- Keywords: "slow", "start" → performance
- Context: shell → config-expert
- Decision: Launch performance + config-expert in parallel

Result: Performance analysis of shell config
```

### Example 3: Security Concern
```
User: "Is this secure?" [shows auth code]

Routing Logic:
- Keyword: "secure" → security
- Code content: auth → security (confirmed)
- File type: .lua → lua-expert (for Lua best practices)
- Decision: Launch security + lua-expert in parallel

Result: Security audit with Lua-specific advice
```

### Example 4: Implementation Request
```
User: "Add a new plugin for session management"

Routing Logic:
- Task: "Add" = implement → test-driven
- Context: plugin → lua-expert
- Decision: test-driven agent (may internally consult lua-expert)

Result: TDD implementation of new plugin
```

### Example 5: Vague Request
```
User: "Something's wrong with my config"

Routing Logic:
- Word: "config" → config-expert
- No specific concern → review agent
- Decision: review agent with focus on config files

Result: Review that auto-delegates to config-expert + others
```

## Parallel Execution Guidelines

Launch agents in parallel when:

1. **Multiple perspectives needed**
   - Review .lua file → lua-expert + performance + security
   - Audit config → config-expert + security

2. **No dependencies between agents**
   - All agents can analyze independently
   - Results can be synthesized afterward

3. **Time savings benefit**
   - Multiple agents worth the parallel overhead
   - Complex analysis that takes time

Don't parallelize when:

1. **Sequential workflow required**
   - Write tests → implement code → review
   - Debug → fix → verify

2. **Single specialist sufficient**
   - Simple Lua question → just lua-expert
   - Pure explanation → just explain

3. **Quick task**
   - Faster to do directly than delegate

## Communication Pattern

When routing automatically, be transparent:

```
User: "Review my telescope config"

OpenCode response:
"I'll review your telescope configuration. This is a Neovim plugin file, 
so I'm analyzing it for:
- Lua code quality (lua-expert)
- Configuration structure (config-expert)  
- Startup performance (performance)

[Launches agents in parallel, then synthesizes results]

Here's the comprehensive review:
..."
```

## Default Behavior

When in doubt:

1. **For reviews**: Always use review agent (it coordinates)
2. **For implementation**: Consider test-driven approach
3. **For questions**: Use explain agent
4. **For fixes**: Use debug agent
5. **For improvement**: Use refactor agent

**Never** make the user specify agents unless they specifically want to.

## Key Principle

**The user should think "what do I want" not "which agent do I need"**

Examples:
- ✅ "Make this faster" (user states goal)
- ❌ "Use the performance agent to optimize" (user does routing)

OpenCode should handle all routing automatically based on context, file types,
keywords, and code content.
