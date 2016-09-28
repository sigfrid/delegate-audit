class User < ActiveRecord::Base
  has_many :groups#, autosave: true
  has_many :roles, through: :groups# , dependent: :nullify
end
