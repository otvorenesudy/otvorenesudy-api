module ObcanJusticeSk
  class CriminalHearings
    BASE_URL = 'https://api.justice.gov.sk/pojednavanie/trestne'

    LIST_JSON_SCHEMA = {
      type: :object,
      properties: {
        filteredCount: {
          type: :integer,
          min: 5000
        },
        data: {
          type: :array,
          items: {
            type: :object,
            properties: {
              id: {
                type: :string
              }
            },
            required: %i[id]
          }
        },
        take: {
          type: :integer
        }
      },
      required: %i[filteredCount data take]
    }

    JSON_SCHEMA = {
      type: :object,
      properties: {
        id: {
          type: :string
        },
        typ: {
          type: :object,
          properties: {
            itemCode: {
              type: :string
            },
            itemName: {
              type: :string
            }
          },
          required: %i[itemCode itemName]
        },
        datumPojednavania: {
          type: :string
        },
        datumZapocatia: {
          type: %i[string null]
        },
        ics: {
          type: :string
        },
        predmet: {
          type: :string
        },
        samosudca: {
          type: :boolean
        },
        spisovaZnacka: {
          type: :string
        },
        sud: {
          type: :object,
          properties: {
            itemCode: {
              type: :string
            },
            itemName: {
              type: :string
            }
          },
          required: %i[itemCode itemName]
        },
        ukonForma: {
          type: :object,
          properties: {
            itemCode: {
              type: :string
            },
            itemName: {
              type: :string,
              enum: [
                'Pojednávanie bez rozhodnutia',
                'Hlavné pojednávanie s rozhodnutím',
                'Verejné zasadnutie bez rozhodnutia',
                'Verejné vyhlásenie rozsudku',
                'Verejné zasadnutie s rozhodnutím',
                'Pojednávanie a rozhodnutie',
                'Hlavné pojednávanie bez rozhodnutia'
              ]
            }
          },
          required: %i[itemCode itemName]
        },
        miestnost: {
          type: %i[string null]
        },
        obzalovani: {
          type: :array,
          items: {
            type: :string
          }
        },
        poznamka: {
          type: %i[string null]
        },
        predsedaSenatu: {
          type: %i[string null]
        },
        sudcovia: {
          type: :array,
          items: {
            type: :string
          }
        },
        usek: {
          type: :string,
          enum: ['Trestný']
        }
      },
      required: %i[id typ datumPojednavania ics predmet samosudca spisovaZnacka sud ukonForma obzalovani usek]
    }

    def self.import
      response = Curl.get(list_url(take: 1, skip: 0))
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_list_json!(json)

      take = 1000
      pages = (json[:filteredCount] / take.to_f).ceil

      (1..pages).each do |page|
        skip = page * take
        url = list_url(take: take, skip: skip)

        ObcanJusticeSk::ImportCriminalHearingsJob.perform_later(url)
      end
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end

    def self.list_url(take:, skip:)
      "#{BASE_URL}?take=#{take}&skip=#{skip}"
    end

    def self.hearing_url(guid)
      "#{BASE_URL}/#{guid}"
    end
  end
end
