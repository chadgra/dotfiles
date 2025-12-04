# OpenCode Cheat Sheet

## The Only Thing You Need to Know

**Just describe what you want in plain English.**

OpenCode will automatically:
- Figure out which specialists to use
- Run them in parallel
- Give you comprehensive results

## Simple Commands

| Say This | Get This |
|----------|----------|
| `review this` | Comprehensive code review |
| `review my changes` | Review recent modifications |
| `check this file` | File analysis |
| `is this secure?` | Security audit |
| `make this faster` | Performance optimization |
| `why is this slow?` | Performance analysis |
| `explain this` | Clear code explanation |
| `what does this do?` | Code walkthrough |
| `fix this bug` | Systematic debugging |
| `debug this error` | Error investigation |
| `clean up this code` | Safe refactoring |
| `refactor this` | Code improvement |
| `add docs` | Documentation |
| `document this` | Add helpful comments |
| `add tests` | Test-driven development |
| `implement [feature]` | TDD feature implementation |

## It Just Works

### Example 1: No Agent Names Needed
```
❌ Old way: "Use lua-expert, config-expert, and performance agents 
             in parallel to review this file"

✅ New way: "review this file"

Result: Same comprehensive review, zero cognitive overhead
```

### Example 2: Natural Questions
```
You: "Why is my Neovim startup slow?"

OpenCode: [Automatically analyzes with performance + lua-expert + config-expert]
          [Gives you bottleneck analysis with specific fixes]
```

### Example 3: Security Concerns
```
You: "Is my .zshrc safe?"

OpenCode: [Automatically runs security + config-expert]
          [Checks for secrets, permissions, vulnerabilities]
```

## Behind The Scenes (You Don't Need to Know This)

When you say "review this .lua file":

1. ✓ Detects it's Lua → considers lua-expert
2. ✓ Sees it's in plugins/ → adds performance
3. ✓ Standard review → includes best practices
4. ✓ Launches all specialists in parallel
5. ✓ Synthesizes into one comprehensive report

**You just said "review this" - OpenCode handled the rest.**

## File-Type Auto-Detection

| File | Auto-Triggers |
|------|--------------|
| `*.lua` | lua-expert + performance |
| `nvim/lua/plugins/*.lua` | lua-expert + config-expert + performance |
| `*.toml`, `*.yml`, `*.json` | config-expert + security |
| `.zshrc`, `.bashrc` | config-expert + security + performance |
| Auth/login code | security + relevant language expert |

## Keyword Auto-Detection

| You Say | Auto-Triggers |
|---------|--------------|
| "slow", "fast", "optimize" | performance |
| "secure", "safe", "vulnerability" | security |
| "review", "check" | review (coordinates all) |
| "explain", "understand" | explain |
| "bug", "fix", "debug" | debug |
| "refactor", "clean up" | refactor |
| "document", "docs" | document |
| "test", "TDD" | test-driven |

## Your Agent Team

### Main Coordinator
- **review** - Routes to specialists automatically

### Direct-Use Agents
- **test-driven** - TDD implementation
- **debug** - Find and fix bugs
- **refactor** - Improve code structure
- **explain** - Understand code
- **document** - Add documentation

### Auto-Delegated Specialists
- **lua-expert** - Lua & Neovim (auto for .lua files)
- **config-expert** - Config files (auto for .toml/.yml/.json)
- **performance** - Optimization (auto for "slow"/"fast" keywords)
- **security** - Security (auto for "secure" or sensitive code)

## Pro Tips

1. **Don't specify agents** - Let OpenCode figure it out
2. **Use natural language** - "make this faster" not "optimize"
3. **Trust the review agent** - It coordinates everything
4. **Be specific about goals** - "review for security" works great
5. **Chain commands naturally** - "review then optimize" just works

## Common Patterns

### Pattern 1: New Code
```
You: "review my new plugin"
→ Comprehensive review with all relevant specialists
```

### Pattern 2: Existing Code
```
You: "make this faster"
→ Performance analysis + optimization suggestions
```

### Pattern 3: Understanding
```
You: "explain how this works"  
→ Clear, layered explanation with examples
```

### Pattern 4: Problem
```
You: "this is broken, help"
→ Systematic debugging + fix suggestions
```

### Pattern 5: Improvement
```
You: "clean this up"
→ Safe refactoring with tests
```

## The Bottom Line

### Remember This
**Just describe what you want.**

### Forget This
- Agent names
- When to use which agent
- How to invoke agents
- Parallel execution syntax
- Coordination logic

**OpenCode is smart. You don't need to be.**

---

## Quick Examples

Try these right now:

1. `review nvim/lua/plugins/telescope.lua`
2. `is my git config secure?`
3. `why is my shell slow to start?`
4. `explain my tmux config`
5. `add a new keybinding for telescope`

Each command will automatically use the right specialists and give you 
comprehensive results. No agent names needed.
