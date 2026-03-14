---
name: learn
description: Generate personalized learning roadmaps for technologies, skills, and career development
allowed-tools: WebSearch, Read, Write
---

# Learn Skill

Creates personalized learning roadmaps with structured phases, curated resources, practice projects, and progress tracking.

## Usage

```bash
/learn [topic]                       # Create learning plan
/learn [topic] --weeks=8             # Set duration
/learn [topic] --level=beginner      # Set starting level
/learn [topic] --goal="[goal]"       # Set specific goal
```

## Examples

```bash
/learn kubernetes
/learn "system design" --weeks=12
/learn rust --level=intermediate
/learn typescript --goal="build a full-stack app"
```

## What It Does

1. **Assesses Scope**
   - Understands the topic breadth
   - Identifies prerequisites
   - Sets appropriate depth

2. **Creates Learning Path**
   - Phased curriculum
   - Progressive difficulty
   - Logical concept ordering

3. **Curates Resources**
   - Official documentation
   - Courses and tutorials
   - Books and articles
   - Practice projects

4. **Structures Progress**
   - Weekly goals
   - Milestone checkpoints
   - Skill assessments

## Output Format

```markdown
# Learning Roadmap: [Topic]

## Overview
- **Goal**: [What you'll be able to do]
- **Duration**: [X weeks]
- **Time Commitment**: [Y hours/week]
- **Prerequisites**: [Required knowledge]

---

## Phase 1: Foundation (Weeks 1-2)

### Goals
- Understand core concepts
- Set up environment
- Complete first tutorial

### Topics
- [ ] [Topic 1]
- [ ] [Topic 2]

### Resources
| Type | Resource | Time |
|------|----------|------|
| 📖 Docs | [Link] | 2h |
| 🎥 Video | [Link] | 1h |
| 💻 Practice | [Link] | 3h |

### Milestone
✅ Build: [Simple project]

---

## Phase 2: Core Skills (Weeks 3-4)
[Same structure]

---

## Practice Projects

| Level | Project | Skills |
|-------|---------|--------|
| Beginner | [Project] | [Skills] |
| Intermediate | [Project] | [Skills] |
| Advanced | [Project] | [Skills] |

---

## Progress Tracking

### Weekly Check-in
- What did I learn?
- What am I struggling with?
- Am I on track?

### Skill Self-Assessment (1-5)
| Skill | Week 1 | Week 4 | Week 8 |
|-------|--------|--------|--------|
```

## Flags

| Flag | Description |
|------|-------------|
| `--weeks=N` | Set duration (default: auto) |
| `--level=X` | Starting level (beginner/intermediate/advanced) |
| `--goal="X"` | Specific end goal |
| `--focus=X` | Focus area (theory/practice/projects) |
| `--style=X` | Learning style (video/reading/hands-on) |

## Execute

Spawn the learning-planner agent:

```
subagent_type: learning-planner
prompt: Create a [N-week] learning roadmap for [topic] at [level] level. Goal: [goal]. Include phased curriculum, curated resources (matching [style] preference), practice projects, and progress tracking milestones.
```
