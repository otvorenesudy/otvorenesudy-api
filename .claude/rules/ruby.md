---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "**/*.erb"
  - "Gemfile"
---

# Ruby 4.0 and Rails 8.1

The app runs **Ruby 4.0 and Rails 8.1** (`.ruby-version`, `Gemfile.lock`). Write current Ruby and Rails, and match the
surrounding code before anything here.

## Formatting and Lint

RuboCop formats and checks every Ruby file (`.rubocop.yml`, the same as otvorenesudy's): the community Ruby and Rails
style guides, with the Rails, RSpec, FactoryBot, Capybara and Performance cops on their defaults. The PostToolUse hook
runs `bin/lint --fix` on each file you write and sends back what it couldn't fix; fix that, don't hand-format. What the
configuration settles:

- `# frozen_string_literal: true` opens every Ruby file (`bin/lint --fix` adds it).
- Single quotes, inside interpolation too; lines up to 120 columns.
- Methods up to 20 lines, classes and modules up to 200, ABC size 30, cyclomatic and perceived complexity 10. A method
  over them splits into private methods named after their steps; don't raise a limit or disable the cop.
- Numbers in names are separated by an underscore (`utf_8`, `indicators_2013`).
- No documentation comment is required above a class. A comment says what the code can't: a source's quirk, a
  constraint, an order that matters. Never one that restates the code.
- A `rubocop:disable` carries its reason after `--` on the same line.

## Ruby

- Use what the versions give: shorthand hash and keyword values (`{ court:, judge: }`), endless ranges, `it` in
  one-line blocks, `filter_map`, `sum`, `compact_blank`, and `Data.define` for small value objects.
- Guard clauses and early returns over nested conditionals; a blank line between logical blocks; `unless` only without
  `else`.
- `present?`, `blank?`, `presence` and safe navigation (`&.`) over manual nil and empty checks.
- Enumerable over loops that fill an accumulator: `map`, `filter_map`, `each_with_object`, `reduce`, `group_by`,
  `uniq { }`.
- Stateless code is a module (`extend self` when it has private helpers, as `Legacy::Normalizer`), or a class with only
  class methods, its helpers private under `class << self`.
- Static mappings are frozen constants (`InfoSud::DecreeMapper::FORM_CODE_MAP`, `Legacy::Normalizer::COURT_NAMES`).
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## The Import Pipeline

A source's record becomes an Open Courts record in steps, each with its place:

| Step | Code | Place |
| --- | --- | --- |
| Talk to a source: requests, pagination, JSON schema validation, parsing | `ObcanJusticeSk::Decrees`, `InfoSud::Parser`, `GenproGovSk::ProsecutorsCrawler` | `lib/<source>/` (`ObcanJusticeSk`, `InfoSud`, `GenproGovSk`) |
| Store the record as fetched | `import_from!` / `import_from` (the `Importable` concerns) | `app/models/<source>/`, primary database |
| Turn source values into Open Courts values | `<Source>::<Record>Mapper` | `app/mappers/<source>/` |
| Find the Open Courts record it belongs to | `ObcanJusticeSk::JudgeFinder`, `DecreeFinder`, `HearingFinder` | `app/services/` |
| Write the Open Courts records | `<Record>Reconciler#reconcile!` | `app/reconcilers/` |
| Run the steps in the background | `ObcanJusticeSk::Import*Job`, `Reconcile*Job` | `app/jobs/` |
| Tell otvorenesudy to reindex | `UpdateNotifier.notify(record)` | `app/services/update_notifier.rb` |

- A mapper only maps: it reads the stored payload and returns values, without writing anything.
- A reconciler writes several records together: inside the record's `with_lock`, with the bang methods (`update!`,
  `save!`), so a failure rolls all of it back. It writes the same records for the same payload, so running it twice
  changes nothing.
- `UpdateNotifier` pushes `UpdateRepositoryJob` onto otvorenesudy's `probe` queue (Redis database 0) as a raw payload,
  `[class name, id]`. Its name, queue and arguments are a contract with otvorenesudy: change both sides together.

## Rails

- Two databases. The primary one holds the raw source records (`ApplicationRecord`, `db/structure.sql`). The opencourts
  one holds the Open Courts records (`OpenCourts::ApplicationRecord`, `db/opencourts_structure.sql`); otvorenesudy owns
  its schema, so a change to those tables is made there too, in its own pull request, and this copy follows it.
- Thin controllers: parameters through `params.expect` in private `*_params` methods, logic in models, services or
  reconcilers. The API (`app/controllers/api/`) checks the API key and pages with the `Link` header through
  `Api::Authorizable` and `Api::Syncable`; its JSON comes from serializers in `app/serializers/`
  (ActiveModelSerializers) and must not change by a byte (`spec/fixtures/api/decree.json`).
- Jobs are ActiveJob on Sidekiq (queues and the reconcilers' capsule in `config/sidekiq.yml`). They take ids or
  serializable values, keep `perform` short and are safe to run twice.
- Iterate with `find_each` / `in_batches`: there are millions of decrees. `includes` against N+1 queries, as
  `Api::DecreesController#syncable_repository` does.
- Errors you rescue and still want to hear about go to Sentry (`Sentry.capture_exception`).
- Settings come from ENV, which dotenv loads from `.env` and `.env.test`: git ignores them, and `bin/setup` makes them
  from the committed `.env.example` and `.env.test.example`. Secrets come from Rails credentials
  (`Rails.application.credentials.dig(...)`), never from code. You can't read the dotenv files or the credentials; ask
  the user when a change needs a new secret, and add it to `config/initializers/production_boot_check.rb` when
  production can't run without it.
- Log through `Rails.logger`, prefixed with the class, values in brackets:
  `Rails.logger.info "ObcanJusticeSk::Decrees # Imported page [#{page}]"`. Rake tasks report progress the same way
  with `puts` (`"Deleted [#{ids.size}] orphaned decrees"`).
