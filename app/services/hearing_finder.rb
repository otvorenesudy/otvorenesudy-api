class HearingFinder
  def self.find_by(mapper)
    Hearing.find_or_initialize_by(uri: mapper.uri)
  end
end
