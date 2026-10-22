---
paths:
  - "spec/**/*.rb"
---

# RSpec

The process is the `acceptance-first` skill: scenarios first, an end-to-end spec per scenario that fails on its
assertion, then the code. This is how to write those specs here, on **rspec-rails, FactoryBot, VCR with WebMock,
Capybara and DatabaseCleaner**, against both real test databases. Run them with `bin/test <spec>`: it lints, prepares
the primary and opencourts test databases and runs outside the Claude Code sandbox, which plain `bundle exec rspec`
can't.

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| An import end to end: source payload → raw record → reconciled Open Courts records | Feature spec driving `import_from!` or the import job, with the enqueued jobs run | `spec/features/` |
| An API endpoint: status, JSON, the `Link` header, API key checks | Request spec | `spec/requests/` (new; the existing `spec/controllers/` are controller specs) |
| The invite form on the welcome page | Feature spec, `js: true` | `spec/features/` |
| Parsing a source's documents or responses, with many cases | Spec of the source module against fixtures | `spec/lib/<source>/` |
| A mapping with many cases | Mapper spec against fixture payloads | `spec/mappers/<source>/` |
| Validations, scopes, model logic with branches | Model spec | `spec/models/` |

Don't add a unit spec that repeats what an end-to-end spec proves. `spec/features/import_*_spec.rb` are still
`pending`: an import scenario fills in the one for its record.

## Fakes

- Real models, both test databases, real mappers, finders and reconcilers, FactoryBot factories (raw source records
  too: `create(:obcan_justice_sk_judge)`).
- HTTP only at the wire: a VCR cassette (`vcr: { cassette_name: '...' }` metadata, recorded in `spec/fixtures/vcr/`) or
  WebMock `stub_request`. No spec reaches a live site. Record a cassette only when the user asks, and check that it
  holds no credentials before committing it.
- Time: `Timecop.freeze` / `Timecop.travel`; the suite doesn't include ActiveSupport's time helpers.
- Jobs: Sidekiq is faked (`Sidekiq::Testing.fake!`). Run ActiveJob work inside `perform_enqueued_jobs { ... }`
  (`spec/support/active_job_helper.rb`), then assert the records it wrote; `active_job: { adapter: :test }` metadata
  swaps the adapter for a spec that checks what was enqueued.
- Never `allow_any_instance_of`, and never doubles of this app's own classes in feature or request specs. The doubles
  in `spec/jobs/reconcile_*_job_spec.rb` and in the mapper specs predate this rule; don't copy them. A new mapper spec
  builds its record with the factory and the fixture payload.

## Writing Them

- `require 'rails_helper'`; `require 'spec_helper'` only for a spec of plain Ruby that doesn't boot Rails.
- `RSpec.describe ClassName` for a class, with `described_class` inside; a string for a flow
  (`RSpec.describe 'Import Decrees'`).
- `describe '.class_method'` / `describe '#instance_method'`; `context 'when ...'` / `'with ...'` / `'without ...'` for
  a situation; no more than three levels of nesting.
- Example names state the outcome in the present tense, after the scenario: `it 'creates the judge once'`, never
  `it 'should ...'`.
- `let` for setup with descriptive names; a subject the examples refer to is named (`subject(:mapper) { ... }`).
- Factories with parentheses: `create(:decree)`, `build(:judge)`. Keep them minimal and realistic in `spec/factories/`.
- Fixtures: `fixture('obcan_justice_sk/...')` (`spec/support/fixture_helper.rb`) reads `spec/fixtures/`. Name a new
  one after the source and what it holds, and keep only what the spec needs.
- One behavior per example; several expectations are fine when they check that one behavior (the records an import
  wrote).
- Parse JSON once (`JSON.parse(response.body, symbolize_names: true)`) and compare whole structures.
- Both databases are cleaned with DatabaseCleaner's deletion strategy after each example; there are no transactional
  fixtures.
- No `sleep`, no order dependence: the suite runs in random order.

## Never

Skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
