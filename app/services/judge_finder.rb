class JudgeFinder
  def self.find_by(name: name)
    Judge.find_by(name: name)
  end
end
