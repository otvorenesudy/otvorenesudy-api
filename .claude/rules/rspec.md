---
paths:
  - "spec/**/*.rb"
---

# RSpec

The process is the `acceptance-first` skill: scenarios, an end-to-end spec per scenario that fails first, then code.
This is how to write those specs here. Run them with `bin/test <spec>`; it prepares the test databases and runs
outside the Claude Code sandbox, which plain `bundle exec rspec` can't.

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| An import end to end: source payload → raw record → reconciled Open Courts records | Feature spec driving `import_from!` or the import job, then `perform_enqueued_jobs` | `spec/features/` |
| An API endpoint: status, JSON, the `Link` header, API key checks | Request spec | `spec/requests/` (new; the old `spec/controllers/` are controller specs) |
| Parsing a source document or response with many cases | Spec of the source module against fixtures | `spec/lib/<source>/` |
| A mapping with many cases | Mapper spec against fixture payloads | `spec/mappers/<source>/` |
| Validations, scopes, model logic with branches | Model spec | `spec/models/` |

Don't add a unit spec that repeats what an end-to-end spec proves.

## Fakes

- Real models, both real test databases, real mappers, finders and reconcilers.
- HTTP only at the wire: a VCR cassette (`spec/fixtures/vcr`, `vcr: { cassette_name: ... }` metadata) or WebMock
  `stub_request`. No spec reaches a live site.
- Time: `travel_to` / `freeze_time` (or the existing `Timecop`). Jobs: `perform_enqueued_jobs` and assert the outcome.
- Never `allow_any_instance_of`, and never doubles of this app's own classes in feature or request specs. The
  `spec/jobs/reconcile_*_job_spec.rb` doubles predate this; don't copy them.

## Style

- `require 'rails_helper'`, `RSpec.describe ClassName` or `RSpec.describe 'Import Decrees'`.
- `describe '.class_method'` / `describe '#instance_method'`, `context 'when ...'` / `'with ...'` for situations.
- Example names state the outcome in the present tense, after the scenario: `it 'creates the judge once'`, never
  `it 'should ...'`.
- `let` for setup, FactoryBot factories (`spec/factories`, `create`, `build`), `described_class`, `expect { }.to change`.
- Fixtures: `fixture('obcan_justice_sk/...')` (`spec/support/fixture_helper.rb`) reads `spec/fixtures/`.
- Both databases are cleaned with DatabaseCleaner's deletion strategy after each example; no transactional fixtures.
- No `sleep`, no order dependence: the suite runs in random order.
- Never skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
