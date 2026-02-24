---
name: commit
description: Create a conventional commit with an auto-generated meaningful message. Handles git init and commitizen setup.
allowed-tools: Bash(git status:*), Bash(git init:*), Bash(git add:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Read, Write
---

# Conventional Commit

Create a meaningful git commit with an auto-generated conventional commit message.

> **Note on "not a git repository" errors:** If ANY git command in the steps below fails with a "not a git repository" error, immediately ask the user whether to run `git init`. If they decline, cancel the entire operation. If they agree, run `git init`, then ask whether to add a commitizen config. If yes, write `.cz.yaml` with the commitizen configuration (see the Commitizen config content section below), stage it with `git add .cz.yaml`, and commit it separately with an appropriate message (e.g. `chore: add commitizen config`). Then resume from the step that failed.

## Steps

1. **Understand the repository's purpose**
   - Read `README.md` if it exists, else check `package.json`, `pyproject.toml`, `Cargo.toml`, or similar manifest files to understand what the project does

2. **Check staged/unstaged changes**
   - Run `git status` to see what's staged
   - Run `git diff --staged` and `git diff` to see changes
   - If nothing is staged and there are unstaged changes, ask the user which files to stage (or all)
   - Stage the selected files

3. **Generate the commit message**
   - Analyze the diff to understand the nature of the change
   - Choose the commit type:
     - `feat` — ONLY for a new feature that directly relates to the repository's stated purpose
     - `fix` — bug fix
     - `docs` — documentation changes
     - `refactor` — code restructuring without behavior change
     - `test` — adding/updating tests
     - `chore` — maintenance, tooling, dependencies
     - `style` — formatting, whitespace
     - `perf` — performance improvement
     - `ci` — CI/CD changes
     - `build` — build system changes
   - Include an optional scope in parentheses when it adds clarity
   - Write a concise, imperative description (max ~72 chars total for the first line)
   - **Never** use "Initial commit", "first commit", "init", or similar placeholder messages — even for the very first commit in a repo; make it meaningful based on what's actually being committed

4. **Commit**
   - Run `git commit -m "<message>"`
   - Report the result

## Commitizen Config Content

When the user agrees to add a commitizen config after `git init`, write `.cz.yaml` with the following content:

```yaml
---
commitizen:
  name: cz_conventional_commits
  tag_format: $version
  update_changelog_on_bump: true
  version_scheme: semver
  change_type_map:
    feat: Features
    fix: Bug fixes
```
