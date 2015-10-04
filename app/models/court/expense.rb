class Court::Expense < ActiveRecord::Base
  belongs_to :source

  belongs_to :court
end
