---
paths:
  - "app/javascript/**"
  - "app/assets/**"
  - "config/webpack/**"
  - "*.js"
---

# JavaScript and Styles

The only pages here are the welcome page and the invite form. JavaScript is bundled by Webpacker 6
(`config/webpack/`, `app/javascript/application.js`) with Turbo and Stimulus; styles are SCSS on Bootstrap 4
(`app/assets/stylesheets/`).

- The PostToolUse hook runs `bin/lint --fix`, which formats `*.js`, `*.scss` and `*.css` with Prettier
  (`.prettierrc`: 120 columns, single quotes). Most existing files predate it; only files you touch get formatted.
- Behavior goes in Stimulus controllers bound with `data-controller` / `data-action`; no inline scripts or styles.
- Use the libraries already in `package.json` before adding one, and add dependencies with `yarn add` so `yarn.lock`
  changes with them.
- A user flow that needs JavaScript is tested with a feature spec on the headless Chrome driver
  (`Capybara.javascript_driver`).
