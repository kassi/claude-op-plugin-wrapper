# conventional-git Plugin

Git workflow skills for Claude Code, starting with intelligent conventional commit creation.

## Skills

### `/commit`

Create a meaningful git commit with an auto-generated conventional commit message.

**Features:**
- Analyzes the diff to understand the nature of changes
- Generates conventional commit messages following the standard format (`type(scope): description`)
- Intelligently selects commit types (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`, `ci`, `build`)
- Only uses `feat` for features that directly relate to the repository's purpose
- Handles first-time git setup with `git init`
- Optionally configures commitizen for version management

**Workflow:**
1. Reads repository documentation to understand its purpose
2. Shows staged/unstaged changes
3. Analyzes the diff and generates a meaningful commit message
4. Creates the commit with the generated message
5. If the repository doesn't exist, offers to initialize it with optional commitizen config

**Error Handling:**
If any git command fails because you're not in a git repository, the skill will:
1. Ask if you want to run `git init`
2. If yes, offer to add a commitizen config (`.cz.yaml`)
3. Resume the commit operation
4. If no, cancel the operation

## License

MIT
