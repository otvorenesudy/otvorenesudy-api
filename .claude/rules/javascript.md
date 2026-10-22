---
paths:
  - "app/javascript/**"
  - "app/assets/**"
  - "app/views/**/*.coffee"
  - "config/webpack/**"
  - "*.js"
  - "package.json"
---

# JavaScript and Styles

The only pages here are the welcome page and its invite form; everything else is the JSON API. Webpacker 6
(`config/webpack/`, release candidate) bundles one pack, `app/javascript/application.js`, with Babel: Rails UJS,
Turbolinks, jQuery and Bootstrap 4's JavaScript. Styles are SCSS on Bootstrap 4 in `app/assets/stylesheets/`, compiled
by Sprockets (`sass-rails`). `@hotwired/stimulus` and `@hotwired/turbo-rails` are in `package.json` but nothing imports
them.

## Formatting

The PostToolUse hook runs `bin/lint --fix`, which formats `*.js`, `*.scss` and `*.css` with Prettier (`.prettierrc`: 120
columns, single quotes, and Prettier 2's defaults otherwise: semicolons, trailing commas where ES5 allows them,
parentheses around arrow parameters). Most files predate it; only the files you touch get formatted. ESLint is in
`package.json` but has no configuration and doesn't run.

## JavaScript

- Keep to what's there: the pack's jQuery handlers and the invite form's UJS responses
  (`form_for ..., remote: true`, answered by `app/views/invites/create.coffee` and `_error.coffee`). Don't add a
  framework for this page.
- `const` by default, `let` when reassigned, never `var`; `===` and `!==` only; optional chaining and `??` over manual
  null checks; template literals.
- A handler that needs the clicked element takes it from the event (`(event) => $(event.currentTarget)`): an arrow
  function has no `this` of its own.
- Code that runs on every page load listens to `turbolinks:load`; `$(() => ...)` runs only on the first one.
- Behavior goes in the pack, bound by `data-*` attributes (`data-track-category`); no inline scripts or `on*`
  attributes in the views. The layout's Google Analytics and cookie consent snippets are the exception.
- Use the libraries already in `package.json` before adding one; add with `yarn add` so `yarn.lock` changes with it.

## Tests

A flow that needs JavaScript is a feature spec with `js: true` on headless Chrome (`Capybara.javascript_driver`),
asserting what the visitor sees, like `spec/features/request_invite_spec.rb`.
