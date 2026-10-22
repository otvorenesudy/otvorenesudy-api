# otvorenesudy-api: Agent Instructions

The importers and HTTP API of [Open Courts](https://otvorenesudy.sk) (Otvorené súdy), a public-interest project that
publishes data about Slovak courts, judges, hearings and decrees. This app crawls the state's public sources
(obcan.justice.sk, InfoSud, justice.gov.sk, genpro.gov.sk, sudnarada.gov.sk), reconciles what they publish into the
Open Courts database, and serves it as JSON at `api.otvorenesudy.sk`. Rails 7.1, Ruby 3.3, PostgreSQL with pgvector,
Sidekiq.

| Repository | What It Is | How It Relates |
| --- | --- | --- |
| otvorenesudy | The public website (Rails 3.2) | Owns the opencourts database this app writes into; reindexes records this app reports (`UpdateRepositoryJob`) |
| otvorenesudy-prokuratura | The prosecutors' website (Rails 7.1) | A sibling app on the same server; links to this API |
| otvorenesudy-data | Static datasets | Checked out here as the `data` submodule |
| otvorenesudy-server | Ansible provisioning of the production server | Runs this app: nginx, Passenger, PostgreSQL, Redis |

## How We Work: Acceptance First

Every feature, behavior change and bug fix starts as an acceptance test. Use the `acceptance-first` skill before
writing code; this is the summary. Tooling, deployment, configuration and refactors that keep behavior get no new
tests: check them by running them and the suite.

1. **Scenarios first**: each scenario the user gave, verbatim, plus edge cases (empty or missing fields, unknown
   values, a payload seen before, a changed payload, a source error). A bug fix starts with the bug as scenario 1.
2. **An end-to-end spec per scenario, red first.** Run it and watch it fail on its assertion.
3. **Implement outside-in** until it passes. Unit specs only for logic with many branches (parsing, mapping).
4. **Done** means every scenario's spec passes and `bin/test` is green, with its output shown.

| Behavior | Tested Through | Where |
| --- | --- | --- |
| Importing from a source | The real entry point (`import_from!` or the import job) with a recorded payload, enqueued jobs run, Open Courts records asserted | `spec/features/` |
| The HTTP API | Request specs: status, headers, JSON | `spec/requests/` |
| Parsing and mapping with many cases | Specs of the source module or mapper against fixtures | `spec/lib/`, `spec/mappers/` |

Use real collaborators: our code, Rails, both databases. Fake only HTTP to the sources (VCR cassettes, WebMock) and
the clock. Never skip, delete or loosen a failing spec to get green; if a spec is wrong, say which scenario it
contradicts.

## Commands

```bash
bin/test                     # lint, then every spec; must be green before you are done
bin/test spec/models/judge_spec.rb:12   # lint, then those specs
bin/lint                     # syntax_tree, RuboCop and Prettier on the files this branch changed
bin/lint --fix <file>        # format and autocorrect a file (the edit hook does this for you)
bin/leaks                    # secrets in the files and the history (the git hooks check each commit and push)
bin/brakeman                 # vulnerabilities in the code
bin/bundler-audit            # gems with known vulnerabilities
bin/rails server             # the app on localhost:3000
bundle exec sidekiq -C config/sidekiq.yml
```

`bin/test` needs PostgreSQL with pgvector on localhost. It rebuilds the test databases from `db/structure.sql` and
`db/opencourts_structure.sql`, holds a machine-wide lock (otvorenesudy uses the same `opencourts_test` database), and
runs outside the Claude Code sandbox because the app reads its local configuration while it boots. Run specs through
it rather than `bundle exec rspec`, which the sandbox can't boot.

## Code Conventions

- **Engineering**: the `engineering` skill. Small reviewable changes, the simplest thing that works, match the
  surrounding code, production-ready only.
- **Naming**: the `naming` skill. Short names in small scopes; descriptive names for methods, parameters, fields
  and anything public; precise nouns and verbs, no filler words.
- **Names people read** (CI workflows, jobs and steps, headings, table columns, English UI labels): title case, the
  `title-case` skill. "Check Out Repository", not "Checkout repository".
- **Rules** in `.claude/rules/` load when you touch the files they cover: `ruby`, `rspec`, `javascript`. Follow them.
- **Formatting is automatic.** After every edit a hook runs `bin/lint --fix` on the file and sends back what it
  couldn't fix. Fix those; don't hand-format.

  | Files | Tools | Settings |
  | --- | --- | --- |
  | `*.rb`, `*.rake`, `Gemfile` | syntax_tree, then RuboCop's Lint and Security cops | `.streerc`, `.rubocop.yml` (120 columns, single quotes) |
  | `*.js`, `*.scss`, `*.css` | Prettier | `.prettierrc` |

  Most code predates the formatters, so `bin/lint` checks the files a branch changes. RuboCop's older offenses are
  listed in `.rubocop_todo.yml`.
- **Dependencies**: gems with `bundle add` (commit `Gemfile.lock`), JavaScript with `yarn add` (commit `yarn.lock`).

## Secrets

These files hold credentials. Never read, print, copy or decrypt them, and don't ask to; when a change needs a
secret, ask the user to add it.

| File | What |
| --- | --- |
| `.env`, `.env.local`, `.env.test`, `.env.ci` | dotenv settings: database logins and service settings per environment |
| `config/credentials/*.yml.enc` and `config/credentials/*.key` | Rails credentials (Sentry, Sidekiq, Skylight) and the keys that decrypt them |

Claude Code denies them to its file tools (`permissions.deny`) and to sandboxed commands
(`sandbox.filesystem.denyRead`), and a hook blocks shell commands that name them. `config/database.yml` and
`config/skylight.yml` only refer to ENV and credentials, and are fine to read.

### Keeping Secrets Out of Git

The history is public, so a secret that reaches it has leaked. `bin/leaks` stops one first: Betterleaks, pinned in
the script and downloaded on first use, for what files say, and a list of names in the script (`config/master.key`,
dotenv files, private keys, database dumps) for what they are called. `.env`, `.env.ci` and `.env.test` have been
committed since 2015, so their names pass; Betterleaks still reads them.

| Where | When | What It Checks |
| --- | --- | --- |
| `.githooks/pre-commit`, `.githooks/pre-push` | Every commit and push, once `bin/leaks --install` has run (`bin/setup` and every Claude Code session run it) | The staged changes; the commits being pushed |
| `.claude/hooks/scan-for-leaks.sh` | Before every file an agent writes | The new text and the file's name |
| `.github/workflows/security.yml` | Every pull request and push to `main` | The files at HEAD and every commit before it; the ruleset on `main` requires this Secrets check |

When it stops you:

- **A real secret**: take it out, put it in the credentials or `.env.local`, and tell the user, who revokes it if it
  was pushed.
- **Not a secret** (a test password, a placeholder, a value in a recorded page): `betterleaks:allow` in a comment on
  its line, or, where no comment fits, its fingerprint in `.betterleaksignore` with the reason above it.
- **Never skip the hooks.** `--no-verify`, `git commit -n` and changing `core.hooksPath` are blocked for agents, and
  CI scans the whole history anyway.

## Commits, Branches and Pull Requests

**Nothing deploys to production automatically for now**: the deploy job in `.github/workflows/main.yml` is off until
the server runs the Rails 8 upgrade; deploy by hand with `bundle exec cap production deploy`. Changes reach `main`
only through a reviewed pull request; never push to `main`. `.github/workflows/security.yml` runs `bin/leaks`,
Brakeman and bundler-audit, and the ruleset on `main` requires a pull request and its Secrets check.

1. **One worktree per change**, off the latest `main`, on a branch named with the `branch-naming` skill:

   ```bash
   git fetch origin
   git worktree add -b <type>/<short-description> .claude/worktrees/<short-description> origin/main
   ```

   In Claude Code, switch the session into it with `EnterWorktree`. Run `bundle install` and `yarn install` there.
2. **Commit** with the `conventional-commit` skill, staging files by name.
3. **Push and open a pull request** when the user asks: `git push -u origin <branch>`, then `gh pr create` with a
   summary and the test plan (the commands you ran and their result).

Keep a pull request to one concern. When it's merged, remove the worktree:
`git worktree remove .claude/worktrees/<short-description>`.

## Agent Setup

Claude Code reads `CLAUDE.md`, which imports this file. Other agents read this file directly.

| What | Lives In |
| --- | --- |
| Instructions | `AGENTS.md` |
| Rules, loaded by path | `.claude/rules/*.md` |
| Skills | `.claude/skills/*/SKILL.md` |
| Permissions, sandbox, hooks | `.claude/settings.json`; personal overrides in `.claude/settings.local.json` (not committed) |
| Hooks | `bin/leaks --install` (at session start); `.claude/hooks/block-sensitive-files.sh` and `block-hook-bypass.sh` (before shell commands); `scan-for-leaks.sh` (before edits); `format.sh` (after edits) |

The settings deny the secrets above, allow `bin/leaks`, `bin/lint` and `bin/test` without asking, ask before `cap`
and pushes to `main`, keep the sandbox's network to package registries, GitHub and the data sources, and run only
`bin/test` outside the sandbox. No test covers the agent setup: when you change it, try it in a session.
