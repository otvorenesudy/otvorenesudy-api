require 'rails_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Court do
  it_behaves_like InfoSud::Importable
end
