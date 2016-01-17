class DecreeFinder
  def self.find_by(mapper)
    return Decree.find_by(uri: mapper.uri) if Decree.exists?(uri: mapper.uri)
    return Decree.find_by(ecli: mapper.ecli) if mapper.ecli && Decree.exists?(ecli: mapper.ecli)
  end
end
