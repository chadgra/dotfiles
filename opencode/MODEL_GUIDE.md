# OpenCode Model Selection Guide

Quick reference for choosing between Claude Sonnet (premium) and GPT-4o (cost-effective) models.

## TL;DR Cost Optimization Strategy

**🔴 Always Premium (Claude Sonnet):**
- `security` - Security cannot be compromised
- `review` - Complex architectural analysis
- `debug` - Root cause analysis requires deep reasoning
- `performance` - Bottleneck identification is nuanced
- `lua-expert` - Specialized domain knowledge

**🟢 Usually Cost-Effective (GPT-4o):**
- `explain` - Primarily descriptive work
- `document` - Text generation with patterns

**🟡 Flexible (Start GPT-4o, Escalate if Needed):**
- `config-expert` - Simple edits → GPT-4o, Complex systems → Sonnet
- `test-driven` - Basic tests → GPT-4o, Complex TDD → Sonnet
- `refactor` - Simple renames → GPT-4o, Design patterns → Sonnet

---

## Detailed Agent Breakdown

### 🔴 PREMIUM REQUIRED

#### `security.md`
**Model:** Claude Sonnet (Premium) - **REQUIRED**

**Why:**
- Security vulnerabilities require expert-level analysis
- Attack vector identification needs sophisticated reasoning
- Cost of missing a vulnerability >> cost of premium tokens
- **NO EXCEPTIONS** - always use premium for security

**Never Use GPT-4o For:** Any security-related work

---

#### `review.md`
**Model:** Claude Sonnet (Premium)

**Why:**
- Complex architectural analysis
- Coordinates multiple specialist agents
- Security and design pattern recognition
- Nuanced, context-aware feedback

**Token Optimization:**
- Review specific files, not entire codebase
- Let specialist agents handle targeted analysis
- Use GPT-4o only for simple style checks

---

#### `debug.md`
**Model:** Claude Sonnet (Premium)

**Why:**
- Root cause analysis requires deep logical reasoning
- Complex execution path tracing
- Distinguishing symptoms from causes
- Hypothesis testing needs strong reasoning

**Use GPT-4o Only For:**
- Simple syntax errors or typos
- Basic stack trace interpretation
- Straightforward variable inspection

---

#### `performance.md`
**Model:** Claude Sonnet (Premium)

**Why:**
- Bottleneck identification requires deep analysis
- Algorithm complexity analysis
- Optimization tradeoffs are nuanced
- Caching and lazy loading strategy design

**Use GPT-4o Only For:**
- Running profiling commands
- Basic timing measurements
- Simple cache additions

---

#### `lua-expert.md`
**Model:** Claude Sonnet (Premium)

**Why:**
- Lua is less common - requires deeper knowledge
- Neovim API and LazyVim are specialized domains
- Plugin architecture needs strong reasoning
- Performance optimization in Lua/Neovim context

**Use GPT-4o Only For:**
- Simple Lua syntax questions
- Basic table manipulation
- Straightforward config edits

---

### 🟢 COST-EFFECTIVE PREFERRED

#### `explain.md`
**Model:** GPT-4o (Cost-Effective)

**Why:**
- Primarily descriptive work
- Less complex reasoning required
- High-quality explanations at lower cost
- Good at breaking down concepts

**Use Claude Sonnet For:**
- Highly complex architectural patterns
- Deep system design analysis
- Subtle interaction explanations

---

#### `document.md`
**Model:** GPT-4o (Cost-Effective)

**Why:**
- Documentation is generative text
- Structure matters more than deep reasoning
- Excellent at following patterns
- High output quality at lower cost

**Use Claude Sonnet For:**
- Complex algorithm documentation
- API docs requiring deep understanding
- Architecture Decision Records (ADRs)

---

### 🟡 FLEXIBLE / HYBRID

#### `config-expert.md`
**Model:** GPT-4o (Start) → Claude Sonnet (If Needed)

**GPT-4o Suitable For:**
- Simple config file edits
- Adding/modifying straightforward settings
- Syntax corrections (TOML/YAML/JSON)
- Basic configuration docs

**Claude Sonnet For:**
- Complex multi-file systems
- Performance-critical optimization
- Cross-tool integration analysis
- Dotfiles architecture design

**Strategy:** Start with GPT-4o, escalate if complex.

---

#### `test-driven.md`
**Model:** Claude Sonnet (Default), GPT-4o (Simple Cases)

**Claude Sonnet For:**
- Comprehensive test suite design
- Edge case analysis
- Complex test coverage decisions
- TDD refactoring

**GPT-4o For:**
- Simple test additions
- Straightforward happy-path tests
- Basic test fixture setup

**Strategy:** Use premium for new feature TDD, cost-effective for simple test additions.

---

#### `refactor.md`
**Model:** Claude Sonnet (Default), GPT-4o (Simple Cases)

**Claude Sonnet For:**
- Complex code restructuring
- Design pattern application
- Behavior preservation analysis
- Multi-factor quality balancing

**GPT-4o For:**
- Simple variable renames
- Basic extract function refactorings
- Straightforward formatting

**Strategy:** Use premium for architectural refactoring, cost-effective for simple cleanups.

---

## Cost Optimization Strategies

### 1. **Start Cheap, Escalate Smart**
```
User asks for config help
→ Try GPT-4o first
→ If response lacks depth or misses complexity
→ Retry with Claude Sonnet
```

### 2. **Scope Reduction**
```
Instead of: "Review my entire Neovim config"
Do: "Review this specific plugin file" (smaller context = lower cost)
```

### 3. **Sequential Task Breakdown**
```
GPT-4o: Generate documentation draft
Claude Sonnet: Review for technical accuracy
(Use cheaper model for bulk work, premium for verification)
```

### 4. **Agent Specialization**
```
Use review agent (premium) to coordinate
→ Spawns specialist agents for targeted analysis
→ More efficient than monolithic review
```

### 5. **Manual Model Switching**
OpenCode allows manual model selection:
- Use keyboard shortcut to switch models
- Before calling agent, switch to appropriate model
- Check your OpenCode settings for model selection keybinds

### 6. **Task Batching**
```
Instead of: Multiple small agent calls
Do: Batch similar tasks into one agent invocation
(Reduces overhead, context loading costs)
```

---

## Quick Decision Tree

```
Is it security-related?
├─ YES → Claude Sonnet (ALWAYS)
└─ NO → Continue

Is it explanation or documentation?
├─ YES → GPT-4o
└─ NO → Continue

Is it complex reasoning? (debugging, architecture, performance)
├─ YES → Claude Sonnet
└─ NO → Continue

Is it simple and straightforward?
├─ YES → GPT-4o
└─ NO → Claude Sonnet (when in doubt, use premium)
```

---

## Monthly Token Budget Planning

### Example Budget Distribution

Assuming 100 agent calls per month:

**High-Impact Premium Tasks (60 calls):**
- 20 code reviews (critical quality gate)
- 15 debugging sessions (save development time)
- 10 security audits (prevent vulnerabilities)
- 10 performance optimizations (user experience)
- 5 complex Lua/Neovim work (specialized knowledge)

**Cost-Effective Tasks (40 calls):**
- 20 explanations (learning and comprehension)
- 15 documentation writing (maintain docs)
- 5 simple config edits (routine maintenance)

### Cost Tracking Tips

1. **Monitor Usage:**
   - Track which agents you use most
   - Identify patterns in your workflow
   - Adjust strategy based on actual usage

2. **Weekly Check-ins:**
   - Review token consumption weekly
   - Adjust model selection if over budget
   - Identify tasks that could use cheaper model

3. **Quality vs Cost:**
   - If GPT-4o output requires rework → use premium next time
   - If Claude Sonnet output was overkill → use GPT-4o next time
   - Learn from each interaction

---

## Common Scenarios

### Scenario 1: Adding New Neovim Plugin
```
Step 1: Explain plugin (GPT-4o) - understand what it does
Step 2: Write config (lua-expert with Sonnet) - specialized work
Step 3: Document config (GPT-4o) - write comments
Step 4: Review integration (review with Sonnet) - check quality
```
**Cost:** 2 premium, 2 cost-effective

---

### Scenario 2: Fixing Shell Performance
```
Step 1: Profile startup (GPT-4o can run commands)
Step 2: Analyze bottlenecks (performance with Sonnet)
Step 3: Implement fixes (config-expert with Sonnet for complex, GPT-4o for simple)
Step 4: Document changes (GPT-4o)
```
**Cost:** 1-2 premium, 2 cost-effective

---

### Scenario 3: Writing New Feature
```
Step 1: Design tests (test-driven with Sonnet)
Step 2: Implement code (test-driven with Sonnet)
Step 3: Review code (review with Sonnet)
Step 4: Document feature (GPT-4o)
```
**Cost:** 3 premium, 1 cost-effective

---

### Scenario 4: Daily Maintenance
```
Step 1: Update simple config (GPT-4o)
Step 2: Fix typo in docs (GPT-4o)
Step 3: Explain code snippet (GPT-4o)
Step 4: Add comment (GPT-4o)
```
**Cost:** 0 premium, 4 cost-effective ✅ Big savings!

---

## Pro Tips

1. **Read Agent Headers:** Each agent file now has model guidance in the header
2. **Don't Cheap Out on Security:** Always use premium for security work
3. **Batch Documentation:** Write all docs in one GPT-4o session
4. **Review Patterns:** If you review same type of code often, consider creating a specialized agent
5. **Cache Responses:** If asking similar questions, refer back to previous responses
6. **Use CHEATSHEET.md:** Many simple questions answered without agents

---

## Questions?

- Check individual agent files for detailed model guidance
- Each agent has a `# ⚡ Recommended Model` section in its header
- When in doubt: premium models are safer, cost-effective are faster/cheaper
- Security = always premium, no exceptions

**Remember:** The goal is to optimize cost WITHOUT sacrificing quality where it matters. Security, complex reasoning, and architectural decisions deserve premium tokens. Documentation and explanations can usually use cost-effective models.
