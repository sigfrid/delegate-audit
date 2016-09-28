class Role < ActiveRecord::Base
  has_many :duties, autosave: true
  has_many :activities, through: :duties , dependent: :nullify
end
