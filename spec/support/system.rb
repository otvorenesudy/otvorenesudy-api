# frozen_string_literal: true

# System specs drive the welcome page through the rendered page: rack_test by default, headless Chrome when a scenario
# needs JavaScript (`js: true`). Chrome resolves only localhost, so third-party scripts (analytics, fonts) never load.
# Selenium Manager fetches the chromedriver matching the installed Chrome, which updates itself; a chromedriver on the
# PATH (Homebrew's) falls behind it and fails to start.
ENV['SE_SKIP_DRIVER_IN_PATH'] ||= 'true'

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :rack_test
  end

  # vanilla-cookieconsent hides its banner from browsers that say they're automated (navigator.webdriver): the
  # :cookie_banner examples get a Chrome that doesn't, in a session of its own.
  config.before(type: :system, js: true) do |example|
    visitor = example.metadata[:cookie_banner]

    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000],
                         options: { name: visitor ? :selenium_visitor : :selenium } do |options|
      options.add_argument('--host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1, EXCLUDE localhost')
      options.add_argument('--disable-blink-features=AutomationControlled') if visitor
      options.add_option('goog:loggingPrefs', { browser: 'ALL' })
    end
  end

  # A failed example in the browser reports what the page's console said, where a script error shows.
  config.after(type: :system, js: true) do |example|
    next unless example.exception

    entries = page.driver.browser.logs.get(:browser).reject { |entry| entry.level == 'INFO' }
    warn "\nBrowser console of \"#{example.full_description}\":\n#{entries.join("\n")}" if entries.any?
  end
end

Capybara.default_max_wait_time = 5

# Where the browser drew an element ('top', 'bottom', 'height'...), for scenarios about scrolling (`js: true`).
module LayoutHelpers
  def bounds(element)
    page.evaluate_script('arguments[0].getBoundingClientRect().toJSON()', element)
  end

  def viewport_height
    page.evaluate_script('window.innerHeight')
  end

  # Waits until the block is true, as Capybara's matchers wait for the page; a script may still be loading.
  def eventually
    page.document.synchronize { yield || raise(Capybara::ExpectationNotMet, 'not yet') }
  end

  # Waits for a smooth scroll to end with the element's top where the block wants it.
  def scrolled_to?(element)
    page.document.synchronize do
      top = bounds(element)['top']
      raise Capybara::ExpectationNotMet, "#{element.tag_name} is #{top}px from the top" unless yield(top)
    end

    true
  end
end

RSpec.configure do |config|
  config.include LayoutHelpers, type: :system
end
