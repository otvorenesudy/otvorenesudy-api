module JusticeGovSk::Decrees
  class Crawler < ActiveJob::Base
    include JusticeGovSk::Crawler

    queue_as :decree

    def self.parser
      JusticeGovSk::Decrees::Parser
    end

    def self.persistor
      JusticeGovSk::Decrees::Persistor
    end
  end
end
