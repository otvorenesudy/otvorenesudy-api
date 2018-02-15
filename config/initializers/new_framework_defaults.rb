# Be sure to restart your server when you modify this file.
# This file contains all the new default configuration options from
# Rails 5.0.
# Require `belongs_to` associations by default. This is a new Rails 5.0
# default, so it is introduced as a configuration option to ensure that apps
# made on earlier versions of Rails are not affected when upgrading.
Rails.application.config.active_record.belongs_to_required_by_default = true

# Enable per-form CSRF tokens.
Rails.application.config.action_controller.per_form_csrf_tokens = true

# Enable origin-checking CSRF mitigation.
Rails.application.config.action_controller.forgery_protection_origin_check =
  true

# Configure SSL options to enable HSTS with subdomains. This is a new
# Rails 5.0 default, so it is introduced as a configuration option to ensure
# that apps made on earlier versions of Rails are not affected when upgrading.
Rails.application.config.ssl_options = { hsts: { subdomains: true } }

# Preserve the timezone of the receiver when calling to `to_time`.
# Ruby 2.4 will change the behavior of `to_time` to preserve the timezone
# when converting to an instance of `Time` instead of the previous behavior
# of converting to the local system timezone.
#
# Rails 5.0 introduced this config option so that apps made with earlier
# versions of Rails are not affected when upgrading.
ActiveSupport.to_time_preserves_timezone = true
