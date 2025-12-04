# OpenCode Agent System - Quick Reference

> **💡 New:** See [MODEL_GUIDE.md](MODEL_GUIDE.md) for choosing between Claude Sonnet (premium) and GPT-4o (cost-effective) models to optimize token usage.

## The Simple Truth

**You don't need to remember which agents to call.**

Just ask for what you want in natural language. OpenCode will automatically:
1. Determine which specialists are needed
2. Launch them in parallel when beneficial
3. Synthesize their findings
4. Give you comprehensive, actionable results

## Just Say These

| What You Want | What You Say | What Happens Automatically |
|---------------|--------------|----------------------------|
| Review code | "review this" | review agent coordinates all needed specialists |
| Check security | "is this secure?" | security + relevant agents launch in parallel |
| Fix slowness | "make this faster" | performance agent analyzes and suggests fixes |
| Understand code | "explain this" | explain agent breaks it down clearly |
| Fix a bug | "debug this" | debug agent systematically finds the issue |
| Clean up code | "refactor this" | refactor agent improves structure safely |
| Add tests | "test this" | test-driven agent writes tests first |
| Add docs | "document this" | document agent creates helpful documentation |

## How It Works Behind the Scenes

### Intelligent Routing

When you say "review this file", OpenCode:

1. **Analyzes Context**
   - File extension (.lua, .toml, etc.)
   - File location (nvim/lua/plugins/, zsh/, etc.)
   - Code content (APIs used, security concerns, etc.)

2. **Determines Specialists Needed**
   - `.lua` file in nvim/plugins/ → lua-expert + performance
   - Config file with secrets → config-expert + security
   - Shell config → config-expert + security + performance

3. **Launches in Parallel**
   - All specialists analyze simultaneously
   - Saves you time (3 agents in parallel = 1x time, not 3x)

4. **Synthesizes Results**
   - Combines findings
   - Removes duplicates
   - Prioritizes by impact
   - Presents unified review

### Automatic Agent Selection

The **review agent** is your coordinator. It automatically delegates based on:

**File Types:**
- `*.lua` → lua-expert
- `*.toml`, `*.yml`, `*.json` → config-expert
- Shell configs → config-expert + security
- Plugin files → lua-expert + config-expert + performance

**Keywords in Your Request:**
- "secure", "safe" → security
- "slow", "fast", "optimize" → performance
- "explain", "understand" → explain
- "bug", "fix", "debug" → debug
- "clean", "refactor" → refactor

**Code Content:**
- Has auth code → security
- Has loops → performance
- Uses vim.api → lua-expert
- Loads on startup → performance

## Your Agent Team

### Core Agents (Direct Use)

**review** - Master coordinator
- Automatically delegates to specialists
- Synthesizes comprehensive reviews
- Your go-to for any review needs

**test-driven** - TDD implementation
- Writes tests first
- Implements minimal code to pass
- Refactors with safety

**debug** - Bug investigation
- Systematic root cause analysis
- Reproduces issues
- Implements targeted fixes

**refactor** - Code improvement
- Improves structure while preserving behavior
- Test-backed changes
- Reduces duplication

**explain** - Code comprehension
- Breaks down complex code
- Uses examples and analogies
- Clear, layered explanations

**document** - Documentation
- Adds helpful comments
- Creates guides and READMEs
- Keeps docs current

### Specialist Agents (Auto-Delegated)

**lua-expert** - Lua & Neovim specialist
- Lua idioms and best practices
- Neovim API expertise
- LazyVim plugin structure
- Auto-triggered for .lua files

**config-expert** - Configuration specialist
- Dotfiles management
- All config formats
- Cross-system compatibility
- Auto-triggered for config files

**performance** - Optimization specialist
- Profiling and benchmarking
- Startup time optimization
- Resource usage optimization
- Auto-triggered by performance keywords

**security** - Security specialist
- Vulnerability detection
- Secrets and credential checks
- Injection prevention
- Auto-triggered by security keywords or sensitive code

## Real-World Examples

### Example 1: Lazy Review
```
You: "review nvim/lua/plugins/telescope.lua"

What Happens:
✓ Review agent sees it's a .lua plugin file
✓ Launches lua-expert, config-expert, performance in parallel
✓ Synthesizes findings into one comprehensive review
✓ You get: Lua correctness + config best practices + perf analysis

You didn't have to: Remember which agents exist or how to invoke them
```

### Example 2: Performance Question
```
You: "neovim is slow to start"

What Happens:
✓ Keyword "slow" triggers performance agent
✓ Context "neovim" adds lua-expert and config-expert
✓ All three analyze in parallel
✓ You get: Bottleneck identification + specific optimizations

You didn't have to: Know that performance analysis needs multiple perspectives
```

### Example 3: Security Concern
```
You: "is my .zshrc safe?"

What Happens:
✓ File type (.zshrc) triggers config-expert
✓ Keyword "safe" triggers security agent
✓ Both analyze in parallel
✓ You get: Security audit + config best practices

You didn't have to: Specify which aspects of safety to check
```

### Example 4: Implementation Request
```
You: "add a session manager plugin"

What Happens:
✓ Task type (implement) uses test-driven agent
✓ Context (plugin) makes it consult lua-expert
✓ TDD workflow: tests → implementation → review
✓ You get: Fully tested, working plugin

You didn't have to: Remember TDD workflow or Lua plugin structure
```

## Pro Tips

### 1. Trust the Automation
Don't overthink it. Just describe what you want:
- ✅ "review this"
- ✅ "make it faster"
- ✅ "is this secure?"
- ❌ "use lua-expert and performance agents in parallel to analyze"

### 2. Be Specific About Goals, Not Methods
- ✅ "review for security issues" (goal)
- ❌ "use security agent" (method)

### 3. The Review Agent Is Your Friend
When in doubt, just say "review this". The review agent will figure out 
what specialists are needed and coordinate everything.

### 4. Context Is Automatic
OpenCode already knows:
- Your project structure (from AGENTS.md)
- File types and locations
- Common patterns in dotfiles
- When to use which agent

### 5. Chain Commands Naturally
```
You: "review my changes, then optimize anything slow"

OpenCode:
1. Reviews (auto-delegates to specialists)
2. Identifies slow parts
3. Applies optimizations
4. Verifies changes
```

## Mental Model

Think of OpenCode like a senior developer with a team:

**You (Junior Dev):** "Can you review this?"

**OpenCode (Senior Dev):** 
- "Sure, let me get our Lua expert, config specialist, and performance engineer to look at it"
- [Consults team in parallel]
- "Here's what we found..." [Unified report]

**You don't:**
- Schedule meetings with each specialist
- Remember who does what
- Coordinate between them
- Synthesize their reports

**OpenCode does all that automatically.**

## File Structure

Your OpenCode setup now includes:

```
opencode/
├── agent/
│   ├── review.md           # Main coordinator (updated)
│   ├── test-driven.md      # TDD implementation
│   ├── debug.md            # Bug fixing
│   ├── refactor.md         # Code improvement
│   ├── explain.md          # Code comprehension
│   ├── document.md         # Documentation
│   ├── security.md         # Security audits
│   ├── lua-expert.md       # Lua specialist
│   ├── config-expert.md    # Config specialist
│   └── performance.md      # Performance specialist
├── opencode.json           # Smart routing config
├── SMART_COMMANDS.md       # Simple command reference
├── ROUTING.md              # Auto-routing logic (for OpenCode)
└── README.md               # This file
```

## Bottom Line

### What You Need to Remember
- "review this" → comprehensive review
- "make it faster" → performance optimization  
- "is this secure?" → security audit
- "explain this" → clear explanation
- "fix this" → systematic debugging
- "clean this up" → safe refactoring
- "document this" → helpful docs

### What You Don't Need to Remember
- Which agents exist
- When to use which agent
- How to invoke agents
- How to run agents in parallel
- How to synthesize results

**OpenCode handles all the complexity. You just describe what you want.**

---

## Quick Start

Try these commands:

1. **Review any file:** `review nvim/lua/config/options.lua`
2. **Check security:** `is my .zshrc secure?`
3. **Optimize performance:** `why is neovim slow to start?`
4. **Understand code:** `explain how lazy loading works`
5. **Fix a bug:** `debug why this function fails`

OpenCode will automatically do the right thing every time.
