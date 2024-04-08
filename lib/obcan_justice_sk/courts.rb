module ObcanJusticeSk
  module Courts
    BASE_URL = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud'

    LIST_JSON_SCHEMA = {
      'type' => 'object',
      'properties' => {
        'numFound' => {
          'type' => 'integer'
        },
        'page' => {
          'type' => 'integer'
        },
        'size' => {
          'type' => 'integer'
        },
        'updateDate' => {
          'type' => 'string',
          'format' => 'date'
        },
        'filterList' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'filterName' => {
                'type' => 'string'
              },
              'facetValueList' => {
                'type' => 'array',
                'items' => {
                  'type' => 'object',
                  'properties' => {
                    'text' => {
                      'type' => 'string'
                    },
                    'count' => {
                      'type' => 'integer'
                    }
                  },
                  'required' => %w[text count]
                }
              }
            },
            'required' => %w[filterName facetValueList]
          }
        },
        'sudMapList' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'registreGuid' => {
                'type' => 'string'
              },
              'nazov' => {
                'type' => 'string'
              },
              'adresaString' => {
                'type' => 'string'
              },
              'suradnice' => {
                'type' => 'object',
                'properties' => {
                  'zemepisnaDlzka' => {
                    'type' => 'string'
                  },
                  'zemepisnaSirka' => {
                    'type' => 'string'
                  }
                },
                'required' => %w[zemepisnaDlzka zemepisnaSirka]
              }
            },
            'required' => %w[registreGuid nazov adresaString suradnice]
          }
        },
        'sudList' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'registreGuid' => {
                'type' => 'string'
              },
              'nazov' => {
                'type' => 'string'
              },
              'adresaString' => {
                'type' => 'string'
              },
              'suradnice' => {
                'type' => 'object',
                'properties' => {
                  'zemepisnaDlzka' => {
                    'type' => 'string'
                  },
                  'zemepisnaSirka' => {
                    'type' => 'string'
                  }
                },
                'required' => %w[zemepisnaDlzka zemepisnaSirka]
              }
            },
            'required' => %w[registreGuid nazov adresaString suradnice]
          }
        }
      },
      'required' => %w[numFound page size updateDate filterList sudMapList sudList]
    }

    JSON_SCHEMA = {
      'type' => 'object',
      'properties' => {
        'registreGuid' => {
          'type' => 'string'
        },
        'nazov' => {
          'type' => 'string'
        },
        'adresaString' => {
          'type' => 'string'
        },
        'suradnice' => {
          'type' => 'object',
          'properties' => {
            'zemepisnaDlzka' => {
              'type' => 'string'
            },
            'zemepisnaSirka' => {
              'type' => 'string'
            }
          },
          'required' => %w[zemepisnaDlzka zemepisnaSirka]
        },
        'ico' => {
          'type' => 'string'
        },
        'typSudu' => {
          'type' => 'string'
        },
        'foto' => {
          'type' => 'string'
        },
        'predseda' => {
          'type' => 'object',
          'properties' => {
            'sudcovia' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'id' => {
                    'type' => 'string'
                  },
                  'meno' => {
                    'type' => 'string'
                  }
                },
                'required' => %w[id meno]
              }
            }
          },
          'required' => ['sudcovia']
        },
        'podpredseda' => {
          'type' => 'object',
          'properties' => {
            'sudcovia' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'id' => {
                    'type' => 'string'
                  },
                  'meno' => {
                    'type' => 'string'
                  }
                },
                'required' => %w[id meno]
              }
            }
          },
          'required' => ['sudcovia']
        },
        'telKontakty' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'cislo' => {
                'type' => 'string'
              },
              'typ' => {
                'type' => 'string'
              }
            },
            'required' => ['cislo']
          }
        },
        'ochranaOsobnychUdajov' => {
          'type' => 'object',
          'properties' => {
            'email' => {
              'type' => 'string'
            }
          },
          'required' => ['email']
        },
        'adresa' => {
          'type' => 'object',
          'properties' => {
            'obec' => {
              'type' => 'string'
            },
            'ulica' => {
              'type' => 'string'
            },
            'psc' => {
              'type' => 'string'
            },
            'krajina' => {
              'type' => 'string'
            }
          },
          'required' => %w[obec ulica psc]
        },
        'infoCentrum' => {
          'type' => 'object',
          'properties' => {
            'telKontakty' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'cislo' => {
                    'type' => 'string'
                  },
                  'typ' => {
                    'type' => 'string'
                  }
                },
                'required' => ['cislo']
              }
            },
            'otvaracieHodiny' => {
              'type' => 'array',
              'items' => {
                'type' => 'string'
              }
            },
            'internetovaAdresa' => {
              'type' => 'object',
              'properties' => {
                'email' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                },
                'www' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                }
              },
              'required' => %w[email www]
            }
          },
          'required' => %w[otvaracieHodiny]
        },
        'podatelna' => {
          'type' => 'object',
          'properties' => {
            'telKontakty' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'cislo' => {
                    'type' => 'string'
                  },
                  'typ' => {
                    'type' => 'string'
                  }
                },
                'required' => ['cislo']
              }
            },
            'otvaracieHodiny' => {
              'type' => 'array',
              'items' => {
                'type' => 'string'
              }
            },
            'internetovaAdresa' => {
              'type' => 'object',
              'properties' => {
                'email' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                },
                'www' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                }
              },
              'required' => %w[email www]
            }
          },
          'required' => %w[telKontakty otvaracieHodiny internetovaAdresa]
        },
        'orsr' => {
          'type' => 'object',
          'properties' => {
            'otvaracieHodiny' => {
              'type' => 'array',
              'items' => {
                'type' => 'string'
              }
            }
          },
          'required' => ['otvaracieHodiny']
        },
        'kontaktneMiesta' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'properties' => {
              'otvaracieHodiny' => {
                'type' => 'array',
                'items' => {
                  'type' => 'string'
                }
              }
            },
            'required' => []
          }
        },
        'media' => {
          'type' => 'object',
          'properties' => {
            'telKontakty' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'cislo' => {
                    'type' => 'string'
                  },
                  'typ' => {
                    'type' => 'string'
                  }
                },
                'required' => ['cislo']
              }
            },
            'net' => {
              'type' => 'object',
              'properties' => {
                'email' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                },
                'www' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                }
              },
              'required' => %w[email www]
            },
            'osoba' => {
              'type' => 'string'
            }
          },
          'required' => %w[]
        },
        'ukonceny_string' => {
          'type' => 'string'
        },
        'skratka_string' => {
          'type' => 'string'
        }
      },
      'required' => %w[
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
      response = Curl.get("#{BASE_URL}?size=1000&page=1")
      json = JSON.parse(response.body_str)

      validate_list_json!(json)

      json['sudList'].each { |court| import_court(court['registreGuid']) }
    end

    def self.import_court(id)
      uri = "#{BASE_URL}/#{id}"
      response = Curl.get(uri)
      json = JSON.parse(response.body_str)

      validate_court_json!(json)

      ObcanJusticeSk::Court.import_from!(guid: id, uri: uri, data: json)
    end

    def self.validate_list_json!(json)
      JSON::Validator.validate!(LIST_JSON_SCHEMA, json)
    end

    def self.validate_court_json!(json)
      JSON::Validator.validate!(JSON_SCHEMA, json)
    end
  end
end
