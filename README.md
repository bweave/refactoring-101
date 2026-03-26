# Refactoring 101

An interactive Ruby workshop for Planning Center's 2026 Developer Summit.

Learn SOLID principles through hands-on refactoring of an event registration system.

## Two Big Ideas

1. **Refactoring does not change what code does** -- only how it does it.
2. **Make the change easy, then make the easy change.** -- Kent Beck

## Setup

```bash
git clone https://github.com/bweave/refactoring-101.git
cd refactoring-101
bundle install
```

## How It Works

The starting code lives in `lib/registration_system.rb` -- a single class that
handles event creation, registration, waitlisting, cancellation, pricing,
notifications, and reporting. It works, but it's a mess.

Tests live in `test/` and come in two flavors:

- **`00_registration_system_test.rb`** -- Safety-net tests. Already passing.
  NEVER modify these. They prove behavior doesn't change as you refactor.
- **`01` through `06`** -- Exercise tests, one per SOLID principle. Each test
  is guarded with `skip`. Remove `skip`, refactor the code, make the test pass.

## Running Tests

Run all tests:

```bash
bundle exec rake
```

Run a single test file:

```bash
bundle exec ruby -Ilib test/00_registration_system_test.rb
```

Run a single test by line number -- put your cursor on any test method and
run it directly:

```bash
bundle exec rake test/01_extract_and_simplify_test.rb:38
```

Watch for changes and rerun tests automatically:

```bash
rerun -bcx --no-notify -- bundle exec rake
```

## Debugging

Drop a `debugger` statement anywhere in your code or tests to pause execution
and get an interactive console. The `debug` gem is already loaded.

## Exercises

| # | Exercise | What You'll Do |
|---|----------|---------------|
| 00 | Understand the Code | Read the class, run tests, get oriented |
| 01 | Extract & Simplify | Extract methods, compose `transfer_registration` |
| 02 | Single Responsibility | Extract PriceCalculator, Notifier, ReportGenerator |
| 03 | Open/Closed | Replace case statements with polymorphism, add ConferenceEvent |
| 04 | Liskov Substitution | Fix LSP violations so all event types are substitutable |
| 05 | Interface Segregation | Split Notifier into focused single-channel classes |
| 06 | Dependency Inversion | Initializer injection with sensible defaults |

## Rules

1. Safety-net tests must ALWAYS pass. If they break, your refactoring changed behavior.
2. Work through exercises in order. Each builds on the previous solution.
3. There are no solutions provided. The journey is the point.

## Inspiration

This workshop draws from the teaching philosophy of Sandi Metz (99 Bottles of OOP, POODR) and the Ruby Koans format. Start with the mess. Refactor in small, safe steps. Let the code tell you what it wants to become.

> "Make the change easy, then make the easy change." -- Kent Beck
