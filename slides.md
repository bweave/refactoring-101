---
marp: true
theme: default
style: |
  section {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
  }
  section.lead h1 {
    font-size: 2.5em;
  }
  section.lead h2 {
    font-weight: normal;
    font-size: 1.2em;
    color: #666;
  }
  section.lead h3 {
    font-weight: normal;
    font-size: 1em;
    color: #888;
  }
  blockquote {
    border-left: 4px solid #0366d6;
    padding: 0.5em 1em;
    color: #333;
    font-style: italic;
  }
  h1 {
    color: #1a1a2e;
  }
  strong {
    color: #0366d6;
  }
  code {
    background: #f0f0f0;
    padding: 0.1em 0.3em;
    border-radius: 3px;
  }
---

<!-- _class: lead -->

# Refactoring 101

## Planning Center Developer Summit 2026

### Brian Weaver

---

# Why Refactor?

Code that works today still needs to **change tomorrow.**
New features, bug fixes, shifting requirements -- they never stop.

Refactoring is how we keep the cost of change low.
Ignore it long enough and every small change
becomes a big, risky project.

---

# What Refactoring Actually Means

**Refactoring does not change what the code does -- only how it does it.**

Same inputs. Same outputs. Same tests pass.

The code just gets better organized.

---

# Repeat after me...

**Refactoring does not change *what* the code does -- only *how* it does it.**

---

# How do we refactor?

> "Make the change easy, then make the easy change."
> -- Kent Beck

That comma is doing some heavy lifting. These are **two separate steps**:

1. **Refactor** -- restructure the code so the change becomes simple.
2. **Change** -- add the feature or fix the bug.

These are **at least two commits.** Refactoring and features
do not belong in the same commit. Draw that line in the sand.

---

# Repeat after me...

**Make the change easy, *then* make the easy change.**

---

# SOLID

Five principles that guide you toward code that's
**easy to change, easy to extend, and easy to understand.**

You don't have to memorize the formal definitions.
You just have to internalize the instincts.

---

# **S** -- Single Responsibility

A class should have **one reason to change.**

If you're describing what a class does and you use
the word "**and**," it probably does too much.

*"This class handles registration **and** pricing
**and** notifications **and** reporting."*

---

# **O** -- Open/Closed

Open for **extension**. Closed for **modification**.

When you see a `case` statement or `if` farm that keeps growing --
that's the code begging for this principle.

---

# **L** -- Liskov Substitution

If your code has to **check which type** it's dealing with
before it can use it, your types are lying about what they are.

Every subtype should be a **drop-in replacement** for its parent.
No surprises. No special cases. No `nil` where others return arrays.

---

# **I** -- Interface Segregation

Don't hand someone a **Swiss Army knife**
when they only need **scissors**.

Keep interfaces focused. A class that sends emails shouldn't
have to know anything about SMS -- even if they live in the
same notification system today.

---

# **D** -- Dependency Inversion

Don't **hardwire your lamp** to the house.
Use a **plug** so you can swap it.

High-level code shouldn't depend on specific implementations.
Pass your dependencies in, and the code becomes flexible
enough to handle things you haven't thought of yet.

---

# The Workshop

You'll work through six exercises in a single Ruby codebase.
Each exercise maps to one of the principles we just covered.

**Safety-net tests** prove you haven't broken anything.
**Exercise tests** (skipped) tell you what to build next.
Remove `skip`, refactor, make it pass. Repeat.

1. Safety-net tests must **always** pass -- if they break, back up.
2. Work through exercises **in order** -- each builds on the last.
3. No solutions are provided -- **the journey is the point.**

---

# One More Thing

You have this repo.

- Make a branch, do the refactoring, throw the branch away.
- Start a new branch and do it again.
- Practice until the instincts are automatic.

Refactoring is a **skill**, not knowledge.
You build skills through **repetition**, not reading.

---

<!-- _class: lead -->

# Let's go.

TODO: add the repo URL here

```
bundle install
bin/watch
```
