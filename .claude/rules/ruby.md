---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "Gemfile"
---

# Ruby 3.3 and Rails 7.1

The app runs **Ruby 3.3 and Rails 7.1** (`.ruby-version`, `Gemfile.lock`). Much of the code predates these
conventions: match the surrounding code, and write what you add the way this rule says.

## Formatting and Lint

syntax_tree formats every Ruby file (`.streerc`: 120 columns, single quotes). RuboCop then checks it with only its Lint
and Security cops (`.rubocop.yml`), so no style cop runs: the style below is ours to keep. The PostToolUse hook runs
`bin/lint --fix` on each file you write and sends back what it couldn't fix; fix that, and don't hand-format or fight
the formatter.

- Offenses listed in `.rubocop_todo.yml` predate the setup. Leave them unless the change is about them; when you fix
  one, regenerate the list with `bin/lint --regenerate-todo`.
- A `rubocop:disable` carries its reason after `--` on the same line.
- The files don't start with `# frozen_string_literal: true`; don't add it to one file alone.

## Ruby

- Guard clauses and early returns over nested conditionals; a blank line between logical blocks; `unless` only without
  `else`.
- `present?`, `blank?`, `presence` and safe navigation (`&.`) over manual nil and empty checks.
- Enumerable over loops that fill an accumulator: `map`, `filter_map`, `each_with_object`, `uniq { }`, `group_by`,
  `sum`.
- Stateless code is module or class methods, with the helpers private under `class << self`.
- Static mappings are constants (`InfoSud::DecreeMapper::FORM_CODE_MAP`); freeze the ones you add.
- Use what Ruby 3.3 gives in new code: shorthand hash and keyword values (`{ court:, judge: }`), endless ranges,
  `filter_map`, `Data.define` for small value objects.
- Comments only for the non-obvious: a constraint, a workaround, a source's quirk. Never one that restates the code.
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## The Import Pipeline

A source's record becomes an Open Courts record in steps, each with its place:

| Step | Code | Place |
| --- | --- | --- |
| Talk to a source: requests, pagination, JSON schema validation, parsing | `ObcanJusticeSk::Decrees`, `InfoSud::Parser` | `lib/<source>/` (`ObcanJusticeSk`, `InfoSud`, `GenproGovSk`, `SudnaradaGovSk`) |
| Store the record as fetched | `import_from!` / `import_from` (the `Importable` concerns) | `app/models/<source>/`, primary database |
| Turn source values into Open Courts values | `<Source>::<Record>Mapper` | `app/mappers/<source>/` |
| Find the Open Courts record it belongs to | `JudgeFinder`, `DecreeFinder`, `HearingFinder` | `app/services/*_finder.rb` |
| Write the Open Courts records | `<Record>Reconciler#reconcile!` | `app/reconcilers/` |
| Run the steps in the background | `<Source>::Import*Job`, `Reconcile*Job` | `app/jobs/` |
| Tell otvorenesudy to reindex | `UpdateNotifier.notify(record)` | `app/services/update_notifier.rb` |

- A mapper only maps: it reads the stored payload and returns values, without writing anything.
- A reconciler writes several records together: inside the record's `with_lock`, with the bang methods (`update!`,
  `save!`), so a failure rolls all of it back. It writes the same records for the same payload, so running it twice
  changes nothing.
- `UpdateNotifier` pushes `UpdateRepositoryJob` onto otvorenesudy's `probe` queue as a raw payload,
  `[class name, id]`. Its name, queue and arguments are a contract with otvorenesudy: change both sides together.

## Rails

- Two databases. The primary one holds the raw source records (`ApplicationRecord`, `db/structure.sql`). The opencourts
  one holds the Open Courts records (`OpenCourts::ApplicationRecord`, `db/opencourts_structure.sql`); otvorenesudy owns
  its schema, so a change to those tables is made there too, in its own pull request.
- Thin controllers: strong parameters in private `*_params` methods, logic in models, services or reconcilers. The API
  (`app/controllers/api/`) checks the API key and pages with the `Link` header through `Api::Authorizable` and
  `Api::Syncable`; its JSON comes from serializers in `app/serializers/` (ActiveModelSerializers).
- Jobs are ActiveJob on Sidekiq (queues in `config/sidekiq.yml`). They take ids or serializable values, keep `perform`
  short and are safe to run twice.
- Iterate with `find_each` / `in_batches`: there are millions of decrees. `includes` against N+1 queries, as
  `Api::DecreesController#syncable_repository` does.
- Errors you rescue and still want to hear about go to Sentry (`Sentry.capture_exception`).
- Secrets come from Rails credentials (`Rails.application.credentials.dig(...)`) or ENV, never from code. ENV comes
  from dotenv's `.env` and `.env.test`, which git ignores, made from the committed `.env.example` and
  `.env.test.example`. You can't read any of them; ask the user when a change needs a new one.
- Log through `Rails.logger`, prefixed with the class, values in brackets:
  `Rails.logger.info "ObcanJusticeSk::Decrees # Imported page [#{page}]"`. Rake tasks report progress the same way
  with `puts` (`"Deleted [#{ids.size}] orphaned decrees"`).
