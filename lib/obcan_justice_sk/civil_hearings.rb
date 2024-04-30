module ObcanJusticeSk
  class CivilHearings
    BASE_URL = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/obcianPojednavania'

    LIST_JSON_SCHEMA = {
      type: :object,
      properties: {
        numFound: {
          type: :integer,
          min: 1000
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
        obcianPojednavaniaList: {
          type: :array,
          items: {
            type: :object,
            properties: {
              guid: {
                type: :string
              }
            },
            required: %i[guid]
          }
        }
      },
      required: %i[numFound page size updateDate obcianPojednavaniaList]
    }

    JSON_SCHEMA = {
      type: :object,
      properties: {
        guid: {
          type: :string
        },
        predmet: {
          type: :string
        },
        usek: {
          type: :string,
          enum: %w[S C O]
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
          },
          required: %i[registreGuid nazov]
        },
        sudca: {
          type: :array,
          items: {
            type: :object,
            properties: {
              registreGuid: {
                type: :string
              },
              meno: {
                type: :string
              }
            },
            required: %i[registreGuid meno]
          }
        },
        miestnost: {
          type: :string
        },
        spisovaZnacka: {
          type: :string
        },
        datumPojednavania: {
          type: :string,
          format: :date
        },
        casPojednavania: {
          type: :string,
          format: :time
        },
        identifikacneCislo: {
          type: :string
        },
        formaUkonu: {
          type: :string,
          enum: [
            'Pojednávanie a rozhodnutie',
            'Pojednávanie bez rozhodnutia',
            'Predbežné prejednanie sporu',
            'Verejné vyhlásenie rozsudku',
            'Vyhlásenie rozsudku',
            'Výsluch'
          ]
        },
        navrhovatelia: {
          type: :array,
          items: {
            type: :object,
            properties: {
              meno: {
                type: :string
              },
              adresa: {
                type: :string
              },
              required: %i[meno]
            }
          },
          odporcovia: {
            type: :array,
            items: {
              type: :object,
              properties: {
                meno: {
                  type: :string
                },
                adresa: {
                  type: :string
                },
                required: %i[meno]
              }
            }
          },
          povodnySud: {
            type: :object,
            properties: {
              registreGuid: {
                type: :string
              },
              nazov: {
                type: :string
              }
            },
            required: %i[registreGuid nazov]
          },
          povodnaSpisovaZnacka: {
            type: :string
          },
          updateDate: {
            type: :string
          }
        },
        required: %i[
          guid
          predmet
          usek
          sud
          sudca
          spisovaZnacka
          datumPojednavania
          casPojednavania
          identifikacneCislo
          updateDate
        ]
      }
    }

    def self.import
      response = Curl.get(list_url(size: 1, page: 0))
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_list_json!(json)

      size = 1_000
      pages = (json[:numFound] / size.to_f).ceil

      (0...pages).each do |page|
        url = list_url(size: size, page: page)

        ObcanJusticeSk::ImportCivilHearingsJob.perform_later(url)
      end
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end

    def self.list_url(size:, page:)
      "#{BASE_URL}?size=#{size}&page=#{page}"
    end

    def self.hearing_url(guid)
      "#{BASE_URL}/#{guid}"
    end
  end
end
