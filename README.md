# Open Courts API

[![CI](https://github.com/otvorenesudy/otvorenesudy-api/actions/workflows/ci.yml/badge.svg)](https://github.com/otvorenesudy/otvorenesudy-api/actions/workflows/ci.yml)

[![View performance data on Skylight](https://badges.skylight.io/status/YcoHMS8aa1P1.svg?token=VKdR-1FwByL-YIC2ld-L6ZYwQeoIasGRIW7YtQYFsaY)](https://www.skylight.io/app/applications/YcoHMS8aa1P1)
[![View performance data on Skylight](https://badges.skylight.io/rpm/YcoHMS8aa1P1.svg?token=VKdR-1FwByL-YIC2ld-L6ZYwQeoIasGRIW7YtQYFsaY)](https://www.skylight.io/app/applications/YcoHMS8aa1P1)
[![View performance data on Skylight](https://badges.skylight.io/typical/YcoHMS8aa1P1.svg?token=VKdR-1FwByL-YIC2ld-L6ZYwQeoIasGRIW7YtQYFsaY)](https://www.skylight.io/app/applications/YcoHMS8aa1P1)
[![View performance data on Skylight](https://badges.skylight.io/problem/YcoHMS8aa1P1.svg?token=VKdR-1FwByL-YIC2ld-L6ZYwQeoIasGRIW7YtQYFsaY)](https://www.skylight.io/app/applications/YcoHMS8aa1P1)

The importers and JSON API of [Open Courts](https://github.com/otvorenesudy) (Otvorené súdy). It crawls the state's
public sources (obcan.justice.sk, api.justice.gov.sk for criminal hearings, InfoSud, genpro.gov.sk), reconciles what
they publish into the Open Courts database that [otvorenesudy](https://github.com/otvorenesudy/otvorenesudy) shows,
asks otvorenesudy to reindex what changed, and serves the decrees as JSON at `api.otvorenesudy.sk`.

## Requirements

- Ruby 4.0 and Node 24 (`.tool-versions`; Node runs Prettier and `bin/vendor`, the welcome page's JavaScript needs no
  build)
- PostgreSQL 17 with the pgvector extension
- Redis (Sidekiq, and otvorenesudy's queue) and Memcached (cache, in production)
- Chrome, for the specs that need JavaScript

## Setup

```sh
git clone --recursive git@github.com:otvorenesudy/otvorenesudy-api.git
cd otvorenesudy-api
bin/setup
```

`bin/setup` installs the gems and the Node packages, copies the dotenv files from their examples, creates both
databases from `db/structure.sql` and `db/opencourts_structure.sql`, then starts `bin/dev` (the app on port 3000 and the
Dart Sass watcher). Run the jobs with `bundle exec sidekiq -C config/sidekiq.yml`.

## Configuration

The settings come from the environment and [dotenv](https://github.com/bkeepers/dotenv) files, which git ignores
except for their templates. `bin/setup` copies `.env.example` to `.env` (development) and `.env.test.example` to
`.env.test` (tests) when they are missing, and never overwrites them: put your own database logins there. `.env.local`
and `.env.*.local` hold personal overrides. CI uses the committed `.env.ci` as `.env.test`. On the server the settings
come from the deploy user's `~/.env` and the app's own `.env`, which Capistrano links into each release.

The database logins are `OPENCOURTS_API_DATABASE_USER` and `OPENCOURTS_API_DATABASE_PASSWORD` (and
`OPENCOURTS_API_DATABASE_HOST`) for this app's database, and `OPENCOURTS_DATABASE_USER` and
`OPENCOURTS_DATABASE_PASSWORD` (and `OPENCOURTS_DATABASE_HOST`) for the Open Courts one, shared with otvorenesudy.
Without them PostgreSQL's defaults apply. `INFO_SUD_IMPORT_ALL_DECREES` makes the InfoSud import read every dump, not
the six latest; `RAILS_LOG_LEVEL` sets the log level in production.

The other secrets live only in Rails' encrypted credentials: `config/credentials/production.yml.enc`, with its key in
`config/credentials/production.key` (on the server, linked by Capistrano; never committed). Production doesn't boot
without them and names the ones missing (`config/initializers/production_boot_check.rb`):

```yaml
secret_key_base: ...       # signs sessions and cookies
sentry:
  dsn: ...
  traces_sample_rate: 0.1  # optional
sidekiq:
  password: ...            # the Sidekiq dashboard's, at /sidekiq
skylight:
  token: ...
```

Edit them with `bin/rails credentials:edit --environment production`. Development and the tests need none of them; to
try Sentry, Skylight or the Sidekiq dashboard locally, make your own from `config/credentials/development.example`
with `bin/rails credentials:edit --environment development` (git ignores them).

## Imports

The sources are read on a schedule (`config/schedule.rb`, installed by `whenever` on deploy): obcan.justice.sk's
courts, judges and hearings every night, its decrees of the last six months on weekdays and all of them on Saturdays.
Each stored record enqueues its reconciliation into the Open Courts database, and each reconciled record is pushed to
otvorenesudy's `probe` queue (`UpdateRepositoryJob`) to be reindexed. By hand:

```sh
bin/rails info_sud:import_hearings                      # also info_sud:import_decrees
bin/rails genpro_gov_sk:export_property_declarations    # the prosecutors' property declarations, to tmp/
bin/rails obcan_justice_sk:consolidate_decrees          # delete the decrees obcan.justice.sk withdrew
STORE=<directory> bin/rails export:decrees              # the decrees as the API gives them, in batches
```

## API

`GET /decrees/:id.json`, `GET /decrees/sync.json` (100 decrees at a time by when they changed, from `since` and
`last_id`, with a `Link` header to the next page) and `GET /decrees/health.json` take an `api_key` parameter; keys are
`Api::Key` records. The JSON doesn't change between releases: `spec/fixtures/api/decree.json` pins it byte for byte.

## Browser Libraries

Bootstrap, Popper, Font Awesome and the cookie consent banner of the welcome page are listed in `package.json` at exact
versions, and `bin/vendor` copies them from `node_modules` into `vendor/`, bundling Popper into one module with esbuild.
importmap serves them without a build step. Don't edit those files: to update a library, change its version in
`package.json` (Dependabot proposes updates weekly), then run `npm install` and `bin/vendor` and commit what changed.
Bootstrap's SCSS comes from the bootstrap gem, which must be the same version. `bin/test` runs `bin/vendor --check`,
which fails when the files aren't what `package.json`'s versions make.

## Testing

```sh
bin/test                                     # lint, every spec with coverage, undercover
bin/test spec/requests/api/decrees_spec.rb   # lint, then those specs
bin/lint --fix                               # RuboCop and Prettier on what the branch changed
```

`bin/test` needs PostgreSQL with pgvector and Redis running locally, and the settings in `.env.test` and `.env`, which
`bin/setup` makes; it needs no credentials. CI runs it on every pull request. A full run fails below 95% of lines or
90% of branches covered, or when a line the branch changed isn't covered.

## Deployment

A maintainer deploys `main` with Capistrano: `bundle exec cap production deploy`. Nothing deploys automatically for
now: the deploy job in `.github/workflows/ci.yml` is off. The server is provisioned by
[otvorenesudy-server](https://github.com/otvorenesudy/otvorenesudy-server); it needs Ruby 4.0.7 (rbenv) and runs
Sidekiq as the `otvorenesudy-api.sidekiq` systemd service (`bundle exec cap production sidekiq:install` sets it up).

## License

[Educational Community License 1.0](http://opensource.org/licenses/ecl1.php)
