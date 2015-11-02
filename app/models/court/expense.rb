class Court::Expense < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :source
  belongs_to :court
end
