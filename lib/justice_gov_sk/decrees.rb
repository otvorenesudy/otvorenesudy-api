module JusticeGovSk
  module Decrees
    extend ActiveSupport::Autoload
    extend JusticeGovSk::Infrastructure

    autoload :ListCrawler
    autoload :ResourceParser
    autoload :ResourceCrawler

    def self.uri
      URI
    end

    class URI
      TEMPLATE = 'https://obcan.justice.sk/infosud?p_p_id=isufront_WAR_isufront&p_p_col_id=column-1&p_p_col_count=1&p_p_mode=view&p_p_state=normal&_isufront_WAR_isufront_view=list&_isufront_WAR_isufront_entityType=rozhodnutie&_isufront_WAR_isufront_delta=200&_isufront_WAR_isufront_cur=<page>'

      def self.build_for(page:)
        TEMPLATE.gsub(/<page>/, page.to_s)
      end
    end
  end
end