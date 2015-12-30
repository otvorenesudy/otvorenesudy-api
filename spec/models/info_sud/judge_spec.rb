require 'spec_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Judge do
  it_behaves_like InfoSud::Importable
end
