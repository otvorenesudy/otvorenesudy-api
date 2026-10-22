# frozen_string_literal: true

# The API's JSON puts each record under its name: {"decree": {...}}, {"decrees": [...]}.
ActiveModel::Serializer.config.adapter = ActiveModelSerializers::Adapter::Json
