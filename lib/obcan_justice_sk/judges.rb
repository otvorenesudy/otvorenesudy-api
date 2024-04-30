module ObcanJusticeSk
  module Judges
    BASE_URL = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca'

    LIST_JSON_SCHEMA = {
      type: :object,
      properties: {
        numFound: {
          type: :integer
        },
        page: {
          type: :integer
        },
        size: {
          type: :integer
        },
        updateDate: {
          type: :string,
          format: :date
        },
        sudcaList: {
          type: :array,
          minItems: 2_000,
          items: {
            type: :object,
            properties: {
              registreGuid: {
                type: :string
              }
            },
            required: %i[registreGuid]
          }
        }
      },
      required: %i[numFound page size updateDate sudcaList]
    }

    JSON_SCHEMA = {
      type: :object,
      properties: {
        registreGuid: {
          type: :string
        },
        meno: {
          type: :string
        },
        funkcia: {
          type: %w[string],
          enum: ['Sudca', 'Predseda', 'Hosťujúci sudca', 'Podpredseda']
        },
        stav: {
          type: %i[string],
          enum: [
            'label.sudca.aktivny',
            'label.sudca.odvolany',
            'label.sudca.prerusenie vykonu - poberatel',
            'label.sudca.prerusenie vykonu - ina funkce',
            'label.sudca.prerusenie vykonu'
          ]
        },
        sud: {
          type: :object,
          properties: {
            registreGuid: {
              type: :string
            },
            nazov: {
              type: :string
            }
          }
        },
        docasnePridelenySud: {
          type: :object,
          properties: {
            registreGuid: {
              type: :string
            },
            nazov: {
              type: :string
            }
          }
        }
      },
      required: %i[registreGuid meno sud docasnePridelenySud]
    }

    def self.import
      response = Curl.get(list_url)
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_list_json!(json)

      json[:sudcaList].each { |court| import_judge(court[:registreGuid]) }
    end

    def self.import_judge(id)
      ObcanJusticeSk::ImportJudgeJob.perform_later(id)
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end

    def self.list_url
      "#{BASE_URL}?size=10000"
    end

    def self.judge_url(guid)
      "#{BASE_URL}/#{guid}"
    end
  end
end
