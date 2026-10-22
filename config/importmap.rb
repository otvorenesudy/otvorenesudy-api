# frozen_string_literal: true

# JavaScript modules, served from app/javascript and vendor/javascript. The libraries come from package.json through
# bin/vendor, which also keeps the version noted on each pin.
pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@popperjs/core', to: '@popperjs--core.js' # @2.11.8
pin 'bootstrap' # @5.3.8
pin 'vanilla-cookieconsent' # @3.1.0
pin 'analytics'
pin 'cookie_consent'
pin 'external_links'
