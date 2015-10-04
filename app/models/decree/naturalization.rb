class Decree::Naturalization < ActiveRecord::Base
  belongs_to :decree
  belongs_to :nature, class_name: 'Decree::Nature', foreign_key: :decree_nature_id
end
