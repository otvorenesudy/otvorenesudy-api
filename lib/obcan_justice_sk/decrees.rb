module ObcanJusticeSk
  module Decrees
    BASE_URL = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie'

    LIST_JSON_SCHEMA = {
      type: :object,
      properties: {
        numFound: {
          type: :integer,
          min: 4_000_000
        },
        page: {
          type: :integer
        },
        size: {
          type: :integer
        },
        updateDate: {
          type: :string
        },
        rozhodnutieList: {
          type: :array,
          items: {
            type: :object,
            properties: {
              guid: {
                type: :string
              }
            }
          }
        }
      }
    }

    JSON_SCHEMA = {
      type: :object,
      properties: {
        guid: {
          type: :string
        },
        formaRozhodnutia: {
          type: :string,
          enum: [
            'Čiastočný rozsudok',
            'Dopĺňací rozsudok',
            'Dopĺňacie uznesenie',
            'Európsky platobný rozkaz',
            'Medzitýmny rozsudok',
            'Opatrenie bez poučenia',
            'Opatrenie',
            'Opravné uznesenie',
            'Osvedčenie',
            'Platobný rozkaz',
            'Príkaz',
            'Rozhodnutie',
            'Rozkaz na plnenie',
            'Rozsudok bez odôvodnenia',
            'Rozsudok pre uznanie',
            'Rozsudok pre vzdanie',
            'Rozsudok pre zmeškanie',
            'Rozsudok',
            'Šekový platobný rozkaz',
            'Trestný rozkaz',
            'Uznesenie bez odôvodnenia',
            'Uznesenie',
            'Výzva',
            'Zmenkový platobný rozkaz'
          ]
        },
        povaha: {
          type: :array,
          items: {
            type: :string,
            enum: [
              'Iná povaha rozhodnutia',
              'Odmietajúce odvolanie',
              'Odmietajúce podanie',
              'Potvrdené',
              'Potvrdzujúce',
              'Pripúštajúce spätvzatie návrhu, zrušujúce rozsudok a zastavujúce konanie',
              'Prvostupňové nenapadnuté opravnými prostriedkami',
              'Zastavujúce odvolacie konanie',
              'Zmenené',
              'Zmeňujúce',
              'Zrušené',
              'Zrušujúce'
            ]
          }
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
          type: :object,
          properties: {
            registreGuid: {
              type: :string
            },
            meno: {
              type: :string
            }
          }
        },
        identifikacneCislo: {
          type: :string
        },
        spisovaZnacka: {
          type: :string
        },
        datumVydania: {
          type: :string
        },
        ecli: {
          type: :string
        },
        oblast: {
          type: :array,
          items: {
            type: :string,
            enum: ['Obchodné právo', 'Občianske právo', 'Rodinné právo', 'Správne právo', 'Trestné právo']
          }
        },
        podOblast: {
          type: :array,
          items: {
            type: :string
          }
        },
        odkazovanePredpisy: {
          type: :array,
          items: {
            type: :object,
            properties: {
              nazov: {
                type: :string
              },
              url: {
                type: :string
              }
            },
            required: %i[nazov url]
          }
        },
        dokument: {
          type: :object,
          properties: {
            name: {
              type: :string
            },
            fileExtension: {
              type: :string
            },
            size: {
              type: :integer
            },
            url: {
              type: :string
            }
          },
          required: %i[name fileExtension size url]
        },
        updateDate: {
          type: :string
        }
      },
      required: %i[guid formaRozhodnutia sud sudca spisovaZnacka datumVydania dokument updateDate]
    }

    def self.import(since: nil)
      response = Curl.get(list_url(since: since, size: 1, page: 0))
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_list_json!(json)

      size = 1_000
      pages = (json[:numFound] / size.to_f).ceil

      (1..pages).each do |page|
        url = list_url(since: since, size: size, page: page)

        ObcanJusticeSk::ImportDecreesJob.perform_later(url)
      end
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end

    def self.list_url(size:, page:, since: nil)
      url = "#{BASE_URL}?size=#{size}&page=#{page}"
      url = "#{url}&indexDatumOd=#{since.strftime('%Y-%m-%d')}" if since

      url
    end

    def self.decree_url(guid)
      "#{BASE_URL}/#{guid}"
    end
  end
end
