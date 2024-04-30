module ObcanJusticeSk
  module Courts
    BASE_URL = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud'

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
        sudList: {
          type: :array,
          minItems: 50,
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
      required: %i[numFound page size updateDate sudList]
    }

    JSON_SCHEMA = {
      type: :object,
      properties: {
        registreGuid: {
          type: :string
        },
        nazov: {
          type: :string
        },
        adresaString: {
          type: :string
        },
        suradnice: {
          type: :object,
          properties: {
            zemepisnaDlzka: {
              type: :string
            },
            zemepisnaSirka: {
              type: :string
            }
          },
          required: %i[zemepisnaDlzka zemepisnaSirka]
        },
        ico: {
          type: :string
        },
        typSudu: {
          type: :string,
          enum: [
            'Správny súd',
            'Okresný súd',
            'Krajský súd',
            'Mestský súd',
            'Špecializovaný trestný súd',
            'Najvyšší súd SR'
          ]
        },
        foto: {
          type: :string
        },
        predseda: {
          type: :object,
          properties: {
            sudcovia: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: {
                    type: :string
                  },
                  meno: {
                    type: :string
                  }
                },
                required: %i[id meno]
              }
            }
          },
          required: [:sudcovia]
        },
        podpredseda: {
          type: :object,
          properties: {
            sudcovia: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: {
                    type: :string
                  },
                  meno: {
                    type: :string
                  }
                },
                required: %i[id meno]
              }
            }
          },
          required: ['sudcovia']
        },
        srPredseda: {
          type: :object,
          properties: {
            sudcovia: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: {
                    type: :string
                  },
                  meno: {
                    type: :string
                  }
                },
                required: %i[id meno]
              }
            }
          },
          required: ['sudcovia']
        },
        srClen: {
          type: :object,
          properties: {
            sudcovia: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: {
                    type: :string
                  },
                  meno: {
                    type: :string
                  }
                },
                required: %i[id meno]
              }
            }
          },
          required: ['sudcovia']
        },
        telKontakty: {
          type: :array,
          items: {
            type: :object,
            properties: {
              cislo: {
                type: :string
              },
              typ: {
                type: :string
              }
            },
            required: ['cislo']
          }
        },
        ochranaOsobnychUdajov: {
          type: :object,
          properties: {
            email: {
              type: :string
            }
          },
          required: ['email']
        },
        adresa: {
          type: :object,
          properties: {
            obec: {
              type: :string
            },
            ulica: {
              type: :string
            },
            psc: {
              type: :string
            },
            krajina: {
              type: :string
            }
          },
          required: %i[obec ulica psc]
        },
        infoCentrum: {
          type: :object,
          properties: {
            telKontakty: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  cislo: {
                    type: :string
                  },
                  typ: {
                    type: :string
                  }
                },
                required: ['cislo']
              }
            },
            otvaracieHodiny: {
              type: :array,
              items: {
                type: :string
              }
            },
            internetovaAdresa: {
              type: :object,
              properties: {
                email: {
                  type: :array,
                  items: {
                    type: :string
                  }
                },
                www: {
                  type: :array,
                  items: {
                    type: :string
                  }
                }
              },
              required: %i[email www]
            }
          },
          required: %i[otvaracieHodiny]
        },
        podatelna: {
          type: :object,
          properties: {
            telKontakty: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  cislo: {
                    type: :string
                  },
                  typ: {
                    type: :string
                  }
                },
                required: [:cislo]
              }
            },
            otvaracieHodiny: {
              type: :array,
              items: {
                type: :string
              }
            },
            internetovaAdresa: {
              type: :object,
              properties: {
                email: {
                  type: :array,
                  items: {
                    type: :string
                  }
                },
                www: {
                  type: :array,
                  items: {
                    type: :string
                  }
                }
              },
              required: %i[email www]
            }
          },
          required: %i[telKontakty otvaracieHodiny internetovaAdresa]
        },
        orsr: {
          type: :object,
          properties: {
            otvaracieHodiny: {
              type: :array,
              items: {
                type: :string
              }
            }
          },
          required: [:otvaracieHodiny]
        },
        kontaktneMiesta: {
          type: :array,
          items: {
            type: :object,
            properties: {
              otvaracieHodiny: {
                type: :array,
                items: {
                  type: :string
                }
              }
            },
            required: []
          }
        },
        media: {
          type: :object,
          properties: {
            telKontakty: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  cislo: {
                    type: :string
                  },
                  typ: {
                    type: :string
                  }
                },
                required: [:cislo]
              }
            },
            net: {
              type: :object,
              properties: {
                email: {
                  type: :array,
                  items: {
                    type: :string
                  }
                },
                www: {
                  type: :array,
                  items: {
                    type: :string
                  }
                }
              },
              required: %i[email www]
            },
            osoba: {
              type: :string
            }
          }
        },
        ukonceny_string: {
          type: :string
        },
        skratka_string: {
          type: :string
        }
      },
      required: %i[
        registreGuid
        nazov
        adresaString
        suradnice
        ico
        typSudu
        ochranaOsobnychUdajov
        adresa
        infoCentrum
        podatelna
        media
        ukonceny_string
        skratka_string
      ]
    }

    def self.import
      response = Curl.get(list_url)
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_list_json!(json)

      json[:sudList].each { |court| import_court(court[:registreGuid]) }
    end

    def self.import_court(guid)
      url = court_url(guid)
      response = Curl.get(url)
      json = JSON.parse(response.body_str, symbolize_names: true)

      validate_json!(json)

      ObcanJusticeSk::Court.import_from!(guid: guid, uri: url, data: json)
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end

    def self.list_url
      "#{BASE_URL}?size=1000"
    end

    def self.court_url(guid)
      "#{BASE_URL}/#{guid}"
    end
  end
end
