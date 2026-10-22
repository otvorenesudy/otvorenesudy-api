---
paths:
  - "app/javascript/**"
  - "app/assets/**"
  - "app/views/**"
  - "config/importmap.rb"
  - "package.json"
---

# JavaScript and Styles

The only pages here are the welcome page and its invite form; everything else is the JSON API. The browser code is
plain JavaScript modules, served without a build step: Importmap (`config/importmap.rb`) maps each import to a file in
`app/javascript/` or `vendor/javascript/`, and Propshaft serves it as written. Turbo drives the navigation and the
invite form's answer (a Turbo Stream), Stimulus the behavior and Bootstrap 5.3 the components. Styles are SCSS
compiled by Dart Sass (`bin/dev` watches them).

Nothing transpiles the code, so write only what current browsers run natively: class fields, optional chaining, `??`,
dynamic `import()` and the rest of modern JavaScript, but no TypeScript, JSX or anything else that needs a compiler.

## Formatting

Prettier formats `app/javascript/**/*.js` and `app/assets/stylesheets/**/*.scss` (`.prettierrc.json`: 120 columns,
single quotes, and Prettier 3's defaults otherwise: semicolons, trailing commas, parentheses around arrow parameters).
The PostToolUse hook runs `bin/lint --fix` on each file you write; don't hand-format. `vendor/` and
`app/assets/stylesheets/vendor/` are third-party code, kept as published.

## Stimulus Controllers

- One controller per behavior, in `app/javascript/controllers/<behavior>_controller.js`. `controllers/index.js` loads
  every file there, so there is nothing to register. The file name is the identifier in the markup:
  `scroll_controller.js` is `data-controller="scroll"`.
- `import { Controller } from '@hotwired/stimulus'` and `export default class extends Controller`: Stimulus's
  convention, and the only default export here.
- Declare `static targets` and `static values` (`static values = { selector: String, offset: Number }`) and use them
  (`this.offsetValue`); don't read `data-*` attributes by hand.
- Undo in `disconnect()` what `connect()` set up. Turbo restores pages from its cache, so a controller connects more
  than once.
- A comment above the class says what the controller does for the visitor, in a sentence or two.

## JavaScript

- `const` by default, `let` when reassigned, never `var`; `===` and `!==` only.
- Optional chaining and `??` over manual null checks; destructuring, template literals, arrow functions for callbacks.
- Guard clauses and early returns; short functions named after what they do.
- Code that runs on every visit listens to `turbo:load`, not `DOMContentLoaded` (`external_links.js`). A module that
  isn't a controller gets a pin in `config/importmap.rb` and an import in `application.js`.
- No inline scripts, `on*` attributes or inline styles in the views. Bootstrap's components work through their
  `data-bs-*` attributes. Google Analytics' tags in the layout are `type="text/plain"` with
  `data-category="analytics"`: the cookie banner (`cookie_consent.js`) runs them only once the visitor accepts.
- Text the visitor reads comes from the page, through `t(...)`, not from strings in the JavaScript. The cookie banner's
  translations in `cookie_consent.js` are the one exception.

## Libraries

Browser libraries are listed in `package.json` at exact versions, copied into `vendor/` by `bin/vendor` and pinned in
`config/importmap.rb`; never edit the copies. To add or update one, change `package.json`, run `npm install` and
`bin/vendor`; `bin/test` fails while the copies don't match. Bootstrap's SCSS comes from the bootstrap gem, which must
be the same version. Use what's there before adding a library.

## Styles

SCSS in `app/assets/stylesheets/`: `application.scss` imports Bootstrap's partials, then the page's own files; shared
values in `variables.scss` and `mixins.scss`. Use Bootstrap's utilities and variables before writing new rules.

## Tests

There are no JavaScript unit tests. A flow that needs JavaScript is a system spec with `js: true` (headless Chrome)
that asserts what the visitor sees; see the `rspec` rule.
