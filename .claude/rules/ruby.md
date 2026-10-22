---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "Gemfile"
---

# Ruby and Rails

Ruby 3.3 (`.ruby-version`), Rails 7.1. Follow what the surrounding code does before anything here.

## Formatting and Lint

The PostToolUse hook runs `bin/lint --fix` on every Ruby file you write: syntax_tree formats it (`.streerc`: 120
columns, single quotes), then RuboCop's Lint and Security cops check it (`.rubocop.yml`). Fix what it reports; don't
format by hand or fight the formatter. Offenses listed in `.rubocop_todo.yml` predate the setup: leave them unless the
change is about them.

## Style

- No comments that restate the code. Comment only the non-obvious: a constraint, a workaround, a source quirk.
- Guard clauses and early returns over nested conditionals; a blank line between logical blocks.
- `unless` only without `else`. Safe navigation (`&.`) over chains of nil checks. `present?`, `blank?`, `presence`.
- Enumerable over loops with accumulators: `map`, `filter_map`, `each_with_object`, `uniq { }`, `group_by`, `sum`.
- Stateless code is module or class methods, helpers private under `class << self`.
- Constants for static mappings (the mappers' `FORM_CODE_MAP`).
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## Logging

Prefix messages with the class and put values in brackets:

```ruby
Rails.logger.info "ObcanJusticeSk::Decrees # Imported page [#{page}] with [#{guids.size}] decrees"
```

## Where Code Goes

| Code | Place |
| --- | --- |
| Talking to a source: requests, pagination, schema validation, parsing | `lib/<source>/` (`ObcanJusticeSk`, `InfoSud`, `GenproGovSk`, `SudnaradaGovSk`) |
| Raw source records, stored as fetched | `app/models/<source>/`, primary database |
| Open Courts records (Court, Judge, Hearing, Decree, ...) | `app/models/*.rb`, `OpenCourts::ApplicationRecord`, opencourts database |
| Source value → Open Courts value | `app/mappers/<source>/` |
| Writing Open Courts records from a mapper | `app/reconcilers/` |
| Finding the Open Courts record a source record belongs to | `app/services/*_finder.rb` |
| Background work | `app/jobs/`, ActiveJob on Sidekiq; queues in `config/sidekiq.yml` |
| JSON for API consumers | `app/serializers/` (ActiveModelSerializers) |

## Rails

- Thin controllers: strong parameters in private `*_params` methods, logic in models, services or reconcilers.
- Jobs take IDs or serializable values, keep `perform` short, and are safe to run twice.
- Batch over large tables with `find_each` / `in_batches`; this database has millions of decrees.
- `includes` to avoid N+1 queries, as `Api::DecreesController#syncable_repository` does.
- Secrets come from Rails credentials (`Rails.application.credentials.dig(...)`) or ENV, never from code. You can't
  read the credentials; ask the user when a change needs a new one.
