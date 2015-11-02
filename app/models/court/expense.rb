class Court::Expense < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source
  belongs_to :court
end
