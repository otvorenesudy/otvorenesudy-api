class DecreeFinder
  def self.find_by(mapper)
    Decree.find_by(uri: mapper.uri)
  end
end
