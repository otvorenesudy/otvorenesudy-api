---
paths:
  - "spec/**/*"
---

# RSpec

The process is the `acceptance-first` skill: scenarios first, an end-to-end spec per scenario that fails on its
assertion, then the code. This is how to write those specs here, on **rspec-rails 8, FactoryBot, Capybara (rack_test
and headless Chrome through Selenium), WebMock and VCR**, against both real PostgreSQL databases. Run them with
`bin/test <spec>`: it lints, prepares the primary and opencourts test databases and runs outside the Claude Code
sandbox, which plain `bundle exec rspec` can't.

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| A source's record becoming Open Courts records: a court, judge, hearing or decree written, updated, reindexed | The reconcile job, from the record as the import stores it (`import_from!` inside `perform_enqueued_jobs`) | `spec/jobs/` |
| Talking to a source: requests, pages, validation, what gets stored | The source module, with the source's HTTP faked at the wire | `spec/lib/<source>/`, `spec/lib/<source>_spec.rb` |
| An API endpoint: status, headers, the JSON byte for byte, the `Link` header, API keys | Request spec | `spec/requests/` |
| The welcome page and its invite form | System spec; rack_test by default, `js: true` (headless Chrome) when it needs JavaScript | `spec/system/` |
| A rake task: exports, consolidation | The task, with `perform_enqueued_jobs`; `type: :task` | `spec/tasks/` |
| The handoff to otvorenesudy (`UpdateNotifier`) | What lands in otvorenesudy's `probe` queue in Redis | `spec/services/update_notifier_spec.rb` |
| Logic with many branches: mappers, normalizers, finders | Mapper, library or service spec against fixture payloads | `spec/mappers/<source>/`, `spec/lib/`, `spec/services/` |

Don't add a mapper, model or service spec that repeats what a job or request spec already proves.

## Fakes

- Real models, both databases, real mappers, finders and reconcilers, FactoryBot factories (the stored source records
  too: `create(:obcan_justice_sk_judge)`). `create_lookups` (`spec/support/open_courts_lookups.rb`) adds the sources,
  court and hearing types and decree forms a reconciler looks up.
- Fake only what we don't own, at the edge:
  - The sources' HTTP: `stub_request` (WebMock), or `stub_json(url, body)` and `source_fixture(name)`
    (`spec/support/sources.rb`). The VCR cassettes in `spec/fixtures/vcr/` hold recorded pages; record a new one only
    when the user asks, and check it holds no credentials. No spec reaches the network, and Chrome resolves only
    localhost.
  - Sentry: a spy, `allow(Sentry).to receive(:capture_exception)`, then `expect(Sentry).to have_received(...)`.
  - The clock: `travel_to` / `freeze_time`. Randomness: stub the call that draws it (`SecureRandom.hex`).
  - Jobs: run them with `perform_enqueued_jobs` and assert the records they wrote; `have_enqueued_job` only when
    enqueueing is the behavior. Sidekiq is faked (`Sidekiq.testing!(:fake)`): read raw pushes from
    `Sidekiq::Queues['probe']`, cleared before every example.
- Never `allow_any_instance_of`, and never doubles or stubs of this app's own classes. A double of something we don't
  own is verified (`instance_double`, `class_double`). RuboCop enforces both.

## Writing Them

RuboCop runs the RSpec, FactoryBot and Capybara cops on every spec; these rules match them.

- `require 'rails_helper'`. `RSpec.describe ClassName` for a class, with `described_class` inside; a string for a page
  or flow (`RSpec.describe 'Decrees API'`). The directory sets the type.
- `describe` names a method (`'.import'`, `'#judges'`) or an endpoint (`'GET /decrees/sync.json'`); `context` names a
  situation and starts with `when`, `with` or `without`. At most three levels of nesting.
- Example names state the outcome in the present tense, after the scenario:
  `it 'updates the same decree when the record changes, dropping what it no longer lists'`, never `it 'should ...'`.
- A subject the examples refer to is named: `subject(:mapper) { described_class.new(record) }`. At most five `let`s in
  a group; `let!` only for a record that must exist before the example runs.
- Factories with parentheses: `create(:decree)`, `build(:obcan_justice_sk_decree, data:)`. They live in
  `spec/factories/`, minimal and realistic. Shared examples live in `spec/support/shared_examples/`.
- Fixtures are read with `file_fixture('obcan_justice_sk/mappers/decree.json')` from `spec/fixtures/`. Name a new one
  after the source and what it holds, and keep only what the spec needs.
- A spec checks a small cluster of outcomes of one behavior (at most 5 expectations, 15 lines); compare whole
  structures (`eq([[...], [...]])`, `have_attributes`) over many single checks. A system spec walks one scenario through
  the page and has no such limit.
- Examples run in a transaction on both databases; `after_commit` callbacks still run, so storing a record enqueues its
  reconciliation.
- No `sleep`, no dependence on order or on the time of day.

## System Specs

- rack_test by default; `js: true` for headless Chrome when the flow needs JavaScript. `bounds(element)` returns where
  the browser drew an element, for scenarios about scrolling.
- Drive the page like a visitor: `visit`, `fill_in`, `click_on`, by the visible label or text. Assert what they see with
  Capybara's waiting matchers (`have_text`, `have_css`).
- The cookie banner hides from browsers that say they're automated: `cookie_banner: true` gets a Chrome that doesn't.
- `:error_pages` shows what callers see when something fails instead of raising into the spec.
- A `js: true` example that fails prints the browser's console: read it before guessing.

## Never

- Skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
- Filter application code out of coverage. A full `bin/test` fails below 95% of lines or 90% of branches, and
  undercover reports every changed line no spec runs: cover them with specs.
