class Role < ActiveRecord::Base
  include Auditable

  has_many :duties, autosave: true
  has_many :activities, through: :duties , dependent: :nullify

  has_many :groups, autosave: true
  has_many :users, through: :groups , dependent: :nullify
end
