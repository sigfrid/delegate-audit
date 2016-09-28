class Duty < ActiveRecord::Base
  belongs_to :activity
  belongs_to :role
end
