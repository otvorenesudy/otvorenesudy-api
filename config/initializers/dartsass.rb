# frozen_string_literal: true

# The welcome page's stylesheet, built from app/assets/stylesheets into app/assets/builds.
Rails.application.config.dartsass.builds = { 'application.scss' => 'application.css' }

# Bootstrap 5.3 needs @import, global functions (map-get) and color functions (darken), which Dart Sass deprecates:
# --quiet-deps silences them inside Bootstrap, the rest in our stylesheets. dartsass-rails splits each option on
# whitespace.
Rails.application.config.dartsass.build_options += [
  "--load-path #{Bootstrap.stylesheets_path}",
  '--quiet-deps',
  '--silence-deprecation import',
  '--silence-deprecation global-builtin',
  '--silence-deprecation color-functions'
]
