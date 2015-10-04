class Court::Type < ActiveRecord::Base
  has_many :offices, class_name: 'Court::Office'
end
