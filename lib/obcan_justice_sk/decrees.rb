module ObcanJusticeSk
  module Decrees
    extend ObcanJusticeSk::Infrastructure

    URI = ObcanJusticeSk::URI.new('https://obcan.justice.sk/infosud?p_p_id=isufront_WAR_isufront&p_p_col_id=column-1&p_p_col_count=1&p_p_mode=view&p_p_state=normal&_isufront_WAR_isufront_view=list&_isufront_WAR_isufront_entityType=rozhodnutie&_isufront_WAR_isufront_delta=200&_isufront_WAR_isufront_cur=<page>')

    def self.uri
      URI
    end

    def self.list_crawler
      ObcanJusticeSk::Decrees::ListCrawler
    end
  end
end
