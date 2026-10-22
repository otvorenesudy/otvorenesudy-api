# frozen_string_literal: true

# Active Record models put their name around their attributes in JSON ({"invite": {...}}), as they always have here.
ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = true
end
