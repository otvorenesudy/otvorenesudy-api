module Legacy
  class Decree < ActiveRecord::Base
    extend Legacy::Importable
  end
end
