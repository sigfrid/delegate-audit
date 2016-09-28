class Activity < ActiveRecord::Base
  has_many :duties
  has_many :roles, through: :duties
end
