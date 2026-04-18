---
marp: true
theme: default
style: |
  :root {
    --accent-color: #4a90e2;
  }
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
    border-left: 4px solid var(--accent-color);
    padding: 0.5em 1em;
    color: #333;
    font-style: italic;
  }
  h1 {
    color: #1a1a2e;
  }
  strong {
    color: var(--accent-color);
  }
  code {
    background: #f0f0f0;
    padding: 0.1em 0.3em;
    border-radius: 3px;
  }
  ul {
    padding-left: 1rem;
  }
---

<!-- _class: lead -->

# Refactoring 101

## Planning Center Developer Summit 2026

---

<!-- _class: lead -->

# 👋 Hi, I'm Brian.

---

# What is refactoring?

---

# Refactoring is...

**Improving the structure of existing code without changing what it does.**

Think: rearranging the furniture.
Same room, same purpose -- easier to live in.

---

# The important part

Refactoring does not change ***what*** the code does -- only ***how*** it does it.

---

<!-- _class: lead -->

# Repeat after me...

## Refactoring does not change ***what*** the code does -- only ***how*** it does it.

---

# When we refactor

- We use the same inputs.
- We get the same outputs.
- The same tests pass.
- We get **better** code organization.

---

# What does **better** code organization mean?

> "Your application needs to work right now just once;
> it must be easy to change forever."
> -- Sandi Metz

New features, bug fixes, shifting requirements -- they never stop.

Refactoring is how we keep the cost of change low.
Ignore it long enough and every small change becomes a big, risky project.

---

# How do we refactor?

> "Make the change easy, then make the easy change."
> -- Kent Beck

Pay attention to the comma. These are two separate steps:

1. **Refactor** -- restructure the code so the change becomes simple.
2. **Change** -- add the feature or fix the bug.

Refactoring and features/fixes **do not belong in the same commit**.

---

<!-- _class: lead -->

# Repeat after me...

## Make the change easy, ***then*** make the easy change.

---

<!-- class: lead -->

# For real, tho, how do we refactor?

- The Flocking Rules
- SOLID design principles

---

# The Flocking Rules

Small, mechanical steps that guide a refactor
without needing a grand plan up front.

1. Select the things that are **most alike**.
2. Find the **smallest difference** between them.
3. Make the **simplest change** that will remove that difference.

If a change introduces an inconsistency or breaks a test,
back up and find a better starting point.

---

# SOLID

Five principles that guide you toward code that's
easy to **change**, easy to **extend**, and easy to **understand**.

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

**Polymorphism** is the tool. Instead of adding another `case` branch,
add a new type that answers the same message.
The existing code stays closed; the system becomes open.

---

# **L** -- Liskov Substitution

Every subtype should be a **drop-in replacement** for its parent.

If your code has to **check which type** it's dealing with
before it can use it, that's your code begging for this principle.

**O** says "prefer polymorphism over conditionals."

**L** says "when you do, subtypes had better actually behave like their parent."

They're a working pair.

---

# **I** -- Interface Segregation

Keep interfaces focused.

Don't hand someone a **Swiss Army knife** when they only need **scissors**.

 A class that sends emails shouldn't have to know anything about SMS,
 even if they live in the same notification system today.

---

# **D** -- Dependency Inversion

High-level code shouldn't depend on specific implementations.

Pass your dependencies in, and the code becomes flexible
enough to handle things you haven't thought of yet.

Don't **hardwire your lamp** to the house. Use a **plug** so you can swap it.

---

# The workshop

You'll work through six exercises in a single Ruby codebase.
The exercises map to the principles we just covered.

**Safety-net tests** prove you haven't broken anything.
**Exercise tests** (skipped) tell you what to build next.
Remove `skip`, refactor, make it pass. Repeat.

1. Safety-net tests must **always** pass -- if they break, back up.
2. Work through exercises **in order** -- each builds on the last.
3. No solutions are provided -- **the journey is the point.**

---

# One more thing

You have this repo.

- Make a branch, do the refactoring, throw the branch away.
- Start a new branch and do it again.
- Practice until the instincts are automatic.

Refactoring is a **skill**, not knowledge.
You build skills through **repetition**, not reading.

---

<!-- _class: lead -->

# Let's go!

**Pair up** -- or form a group of three.
You'll learn more from talking through the refactors than doing them alone.

```
git clone https://github.com/bweave/refactoring-101
cd refactoring-101
bundle install
bin/watch
```
