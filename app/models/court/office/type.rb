class Court::Office::Type < ActiveRecord::Base
  has_many :offices, class_name: 'Court::Office'
end
