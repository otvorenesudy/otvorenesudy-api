# otvorenesudy-api: Agent Instructions

The importers and HTTP API of [Open Courts](https://otvorenesudy.sk) (Otvorené súdy), a public-interest project that
publishes data about Slovak courts, judges, hearings and decrees. This app crawls the state's public sources
(obcan.justice.sk, api.justice.gov.sk for criminal hearings, InfoSud, genpro.gov.sk), reconciles what they publish
into the Open Courts database, and serves it as JSON at `api.otvorenesudy.sk`. Rails 8.1, Ruby 4.0, PostgreSQL with
pgvector, Sidekiq; the one page, the welcome page with its invite form, is Propshaft, importmap, Turbo, Stimulus and
Bootstrap 5.

| Repository | What It Is | How It Relates |
| --- | --- | --- |
| otvorenesudy | The public website | Owns the opencourts database this app writes into; reindexes records this app reports (`UpdateRepositoryJob`) |
| otvorenesudy-prokuratura | The prosecutors' website | A sibling app on the same server; sends its prosecutor refinements here |
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
| A source's record becoming Open Courts records | The reconcile job, from the record as the import stores it, with the enqueued jobs run; Open Courts records asserted | `spec/jobs/` |
| Talking to a source | The source module, its HTTP faked at the wire | `spec/lib/` |
| The HTTP API | Request specs: status, headers, JSON byte for byte | `spec/requests/` |
| The welcome page and invite form | System specs, headless Chrome when JavaScript is involved | `spec/system/` |
| A rake task | The task itself, `type: :task` | `spec/tasks/` |
| Parsing and mapping with many cases | Specs of the source module or mapper against fixtures | `spec/lib/`, `spec/mappers/` |

Use real collaborators: our code, Rails, both databases. Fake only HTTP to the sources (WebMock, VCR cassettes), Sentry,
the clock and randomness. Never skip, delete or loosen a failing spec to get green; if a spec is wrong, say which
scenario it contradicts. The `rspec` rule has the details.

## Commands

```bash
bin/test                     # lint, every spec with coverage, undercover; must be green before you are done
bin/test spec/requests/api/decrees_spec.rb:12   # lint, then those specs
bin/lint                     # RuboCop and Prettier on the files this branch changed (--all: every file)
bin/lint --fix <file>        # format and autocorrect a file (the edit hook does this for you)
bin/leaks                    # secrets in the files and the history (the git hooks check each commit and push)
bin/brakeman                 # vulnerabilities in the code
bin/bundler-audit            # gems with known vulnerabilities
bin/setup                    # gems, Node packages, git hooks, .env and .env.test from their examples, the databases
bin/dev                      # the app on localhost:3000 and the Dart Sass watcher
bin/vendor                   # copy the browser libraries from node_modules after changing package.json
bundle exec sidekiq -C config/sidekiq.yml
```

`bin/test` needs PostgreSQL with pgvector and Redis on localhost, and the settings in `.env.test` and `.env`, which
`bin/setup` makes; it needs no credentials. It rebuilds the test databases from `db/structure.sql` and
`db/opencourts_structure.sql`, holds a machine-wide lock (otvorenesudy uses the same `opencourts_test` database), and
runs outside the Claude Code sandbox, which hides the local configuration the app reads while it boots. Run specs
through it rather than `bundle exec rspec`, which the sandbox can't boot. A full run fails below 95% of lines or 90% of
branches covered, and undercover fails it for a changed line no spec runs.

## Code Conventions

- **Engineering**: the `engineering` skill. Small reviewable changes, the simplest thing that works, match the
  surrounding code, production-ready only.
- **Naming**: the `naming` skill. Short names in small scopes; descriptive names for methods, parameters, fields
  and anything public; precise nouns and verbs, no filler words.
- **Names people read** (CI workflows, jobs and steps, headings, table columns, English UI labels): title case, the
  `title-case` skill. "Check Out Repository", not "Checkout repository".
- **Rules** in `.claude/rules/` load when you touch the files they cover: `ruby`, `rspec`, `javascript`. Follow them.
- **Formatting is automatic.** After every edit a hook runs `bin/lint --fix` on the file and sends back what it
  couldn't fix. Fix those; don't hand-format, and don't disable a cop or raise a limit to get past one.

  | Files | Tools | Settings |
  | --- | --- | --- |
  | `*.rb`, `*.rake`, `Gemfile` | RuboCop, with the Rails, RSpec, FactoryBot, Capybara and Performance cops | `.rubocop.yml`, the same as otvorenesudy's (120 columns, single quotes) |
  | `app/javascript/**/*.js`, `app/assets/stylesheets/**/*.scss` | Prettier | `.prettierrc.json` |

- **Dependencies**: gems with `bundle add` (commit `Gemfile.lock`). Browser libraries at exact versions in
  `package.json` (`npm install --save-exact`), then `bin/vendor`; commit `package-lock.json` and what `bin/vendor`
  copied.

## Secrets

These files hold credentials. Never read, print, copy or decrypt them, and don't ask to; when a change needs a
secret, ask the user to add it.

| File | What |
| --- | --- |
| `.env`, `.env.test` | dotenv settings for development and the specs: database logins and service settings. Git ignores them; `bin/setup` makes them from the templates below. On the server, Capistrano links the server's own `.env`, with the production settings |
| `.env.local`, `.env.*.local` | dotenv: personal overrides, which git ignores |
| `.env.example`, `.env.test.example`, `.env.ci` | dotenv, committed: the templates of `.env` and `.env.test`, and CI's settings, which CI copies to `.env.test` |
| `config/credentials/*.key` | Keys of the encrypted credentials; `config/credentials/*.yml.enc` are the encrypted files. Production's hold `secret_key_base`, `sentry.dsn`, `sidekiq.password` and `skylight.token` (`config/initializers/production_boot_check.rb` lists them); each developer's own development ones, made from `config/credentials/development.example`, are never committed |

Claude Code denies them to its file tools (`permissions.deny`) and to sandboxed commands
(`sandbox.filesystem.denyRead`), and a hook blocks shell commands that name them. `config/database.yml` and
`config/skylight.yml` only refer to ENV and credentials, and are fine to read.

### Keeping Secrets Out of Git

The history is public, so a secret that reaches it has leaked. `bin/leaks` stops one first: Betterleaks, pinned in
the script and downloaded on first use, for what files say, and a list of names in the script (`config/master.key`,
dotenv files, private keys, database dumps) for what they are called. Of the dotenv files, only the templates
(`.env.example`, `.env.test.example`) and CI's `.env.ci` pass by name; Betterleaks still reads what they say.
`.env` and `.env.test` were committed until 2026, and `.betterleaksignore` lists what their history held.

| Where | When | What It Checks |
| --- | --- | --- |
| `.githooks/pre-commit`, `.githooks/pre-push` | Every commit and push, once `bin/leaks --install` has run (`bin/setup` and every Claude Code session run it) | The staged changes; the commits being pushed |
| `.claude/hooks/scan-for-leaks.sh` | Before every file an agent writes | The new text and the file's name |
| `.github/workflows/security.yml` | Every pull request and push to `main` | The files at HEAD and every commit before it; the ruleset on `main` requires this Secrets check of everyone but repository admins |

When it stops you:

- **A real secret**: take it out, put it in the credentials or `.env`, and tell the user, who revokes it if it was
  pushed.
- **Not a secret** (a test password, a placeholder, a value in a recorded page): `betterleaks:allow` in a comment on
  its line, or, where no comment fits, its fingerprint in `.betterleaksignore` with the reason above it.
- **Never skip the hooks.** `--no-verify`, `git commit -n` and changing `core.hooksPath` are blocked for agents, and
  CI scans the whole history anyway.

## Commits, Branches and Pull Requests

**Nothing deploys to production automatically for now**: the deploy job in `.github/workflows/ci.yml` is off until
the server runs the Rails 8 upgrade; deploy by hand with `bundle exec cap production deploy`. Changes reach `main`
through a pull request, which merges without review, or a push straight to `main` when the user asks for one.
`.github/workflows/ci.yml` runs `bin/test` on every pull request; `.github/workflows/security.yml` runs `bin/leaks`,
Brakeman and bundler-audit. The ruleset on `main` requires a pull request and its Secrets check, and lets repository
admins bypass both.

1. **One worktree per change**, off the latest `main`, on a branch named with the `branch-naming` skill:

   ```bash
   git fetch origin
   git worktree add -b <type>/<short-description> .claude/worktrees/<short-description> origin/main
   ```

   In Claude Code, switch the session into it with `EnterWorktree`. Run `bundle install` and `npm install` there.
   Git doesn't check out `.env` and `.env.test`: `bin/setup` makes them from their examples, or the user copies
   theirs from the main checkout.
2. **Commit** with the `conventional-commit` skill, staging files by name.
3. **Push and open a pull request** when the user asks: `git push -u origin <branch>`, then `gh pr create` with a
   summary and the test plan (the commands you ran and their result).

When the user asks to commit and push in `main`, skip the worktree: commit on `main` in the main checkout and
`git push origin main`. The pre-push hook still runs `bin/leaks`.

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
