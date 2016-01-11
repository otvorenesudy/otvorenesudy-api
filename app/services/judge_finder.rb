class JudgeFinder
  def self.find_by(name:)
    Judge.find_by(name: name)
  end
end
