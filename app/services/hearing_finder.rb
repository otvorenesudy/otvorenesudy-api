class HearingFinder
  def self.find_by(attributes, relation: Hearing)
    return relation.find_by(uri: attributes.uri) if Hearing.exists?(uri: attributes.uri)

    relation.joins(:judges).find_by(
      date: attributes.date,
      file_number: attributes.file_number,
      judges: {
        name: attributes.judges + attributes.chair_judges
      }
    )
  end
end
