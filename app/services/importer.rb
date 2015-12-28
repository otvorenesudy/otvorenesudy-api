module Importer
  def self.import_or_update(dispatcher, attributes:)
    dispatcher.attributes = attributes

    return unless dispatcher.changed?

    dispatcher.update_attributes!(attributes)
  end
end
