module InfoSud
  class Parser
    def self.parse(content)
      json = Oj.load(content, symbol_keys: true, mode: :strict)

      json[:data]
    end
  end
end
