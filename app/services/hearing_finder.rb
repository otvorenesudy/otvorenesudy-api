class HearingFinder
  def self.find_by(mapper, relation: Hearing)
    return relation.find_by(uri: mapper.uri) if Hearing.exists?(uri: mapper.uri)

    return if !mapper.file_number || !mapper.date || !mapper.court

    relation.joins(:court, :judges).find_by(
      date: mapper.date,
      file_number: mapper.file_number,
      courts: {
        name: mapper.court
      },
      judges: {
        name: mapper.judges + mapper.chair_judges
      }
    )
  end
end
