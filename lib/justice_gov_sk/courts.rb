module JusticeGovSk
  module Courts
    URI = 'https://obcan.justice.sk/infosud?p_p_id=isufront_WAR_isufront&p_p_col_id=column-1&p_p_col_count=1&p_p_mode=view&p_p_state=normal&_isufront_WAR_isufront_view=list&_isufront_WAR_isufront_entityType=sud&_isufront_WAR_isufront_delta=200'

    def self.crawl
      JusticeGovSk::Courts::ListCrawler.perform_later(URI)
    end
  end
end
