# Smart Commands for OpenCode

This file documents simple commands that automatically use the right agents
without you having to remember which ones to invoke.

## Just Say These Simple Commands

### Code Review Commands

**"review this"** or **"review my changes"**
→ Automatically uses review agent (which delegates to specialists)

**"check this file"** or **"check my code"**
→ Automatically analyzes and routes to appropriate agents

**"is this secure?"**
→ Automatically uses security agent + relevant specialists

**"make this faster"** or **"optimize this"**
→ Automatically uses performance agent + relevant specialists

### Development Commands

**"implement [feature]"**
→ Automatically uses test-driven agent

**"fix this bug"** or **"debug this"**
→ Automatically uses debug agent

**"clean up this code"** or **"refactor this"**
→ Automatically uses refactor agent

**"explain this code"** or **"what does this do?"**
→ Automatically uses explain agent

**"document this"** or **"add docs"**
→ Automatically uses document agent

### Smart Context Detection

OpenCode's main agent should automatically detect:

- **Lua files** → Invoke lua-expert automatically
- **Config files** → Invoke config-expert automatically  
- **Slow startup** → Invoke performance automatically
- **Auth/secrets** → Invoke security automatically

## How It Works

The review agent now acts as a coordinator. When you say "review this", it:

1. Looks at what you're reviewing
2. Determines which specialists are needed
3. Launches them in parallel
4. Synthesizes their reports
5. Gives you one comprehensive review

You just say simple commands, OpenCode handles the complexity.

## Examples

### Example 1: Simple Review Command
```
You: "Review my telescope plugin"

OpenCode:
- Detects: nvim/lua/plugins/telescope.lua
- Launches: lua-expert + config-expert + performance (parallel)
- Returns: Unified comprehensive review
```

### Example 2: Simple Question
```
You: "Is my .zshrc secure?"

OpenCode:
- Detects: Shell config file with potential secrets
- Launches: config-expert + security (parallel)
- Returns: Security analysis with recommendations
```

### Example 3: Performance Request
```
You: "Why is Neovim slow to start?"

OpenCode:
- Detects: Neovim performance issue
- Launches: performance + lua-expert + config-expert (parallel)
- Returns: Bottleneck analysis with fixes
```

### Example 4: General Development
```
You: "Add a new session manager plugin"

OpenCode:
- Detects: New Neovim feature needed
- Uses: test-driven agent (which may call lua-expert)
- Returns: Tested, working plugin implementation
```

## Pro Tips

### 1. Trust the Defaults
Don't specify agents unless you have a specific reason. The main OpenCode agent
and the review coordinator will automatically use the right specialists.

### 2. Be Specific About What, Not How
✅ "Review this Lua file for performance issues"
❌ "Use the lua-expert and performance agents to review this"

### 3. Use Natural Language
✅ "Make this faster"
✅ "Is this secure?"
✅ "Explain how this works"
❌ "Invoke performance optimization specialist agent"

### 4. Context Matters
OpenCode automatically knows:
- File extensions (.lua, .toml, .yml, etc.)
- File locations (nvim/lua/plugins/, zsh/, etc.)
- Your project structure (from AGENTS.md)
- Common patterns in your dotfiles

### 5. Chain Commands Naturally
```
You: "Review my changes, then optimize the slow parts"

OpenCode:
1. Reviews (using review coordinator)
2. Identifies slow parts (performance agent)
3. Suggests optimizations
4. You approve
5. Implements optimizations (lua-expert + performance)
```

## Mental Model

Think of OpenCode like talking to a senior developer:

**Old way (micromanaging)**:
"Use your knowledge of Lua, then check the Neovim API usage, then analyze 
performance, then check security, then synthesize it all into a report"

**New way (delegating)**:
"Review this file"

The senior developer (OpenCode) knows which specialists to consult and 
handles all the coordination for you.

## Bottom Line

**You should almost never need to explicitly invoke specific agents.**

Just describe what you want in natural language:
- "review this"
- "make it faster"  
- "is this secure?"
- "explain this"
- "fix this bug"

OpenCode will automatically figure out which specialists to use and run them
in parallel when beneficial.
