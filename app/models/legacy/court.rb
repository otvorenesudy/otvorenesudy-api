module Legacy
  class Court < ActiveRecord::Base
    extend Legacy::Importable
  end
end
