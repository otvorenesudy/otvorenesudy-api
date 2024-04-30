module ObcanJusticeSk
  class ImportDecreeJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(guid)
      url = ObcanJusticeSk::Decrees.decree_url(guid)
      response = Curl.get(url)
      decree = JSON.parse(response.body_str)

      ObcanJusticeSk::Decrees.validate_json!(decree)

      ObcanJusticeSk::Decree.import_from!(guid: guid, uri: url, data: decree)
    end
  end
end
