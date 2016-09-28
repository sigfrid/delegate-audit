class CreateDuties < ActiveRecord::Migration[5.0]
  def change
    create_table :duties do |t|
      t.references :role
      t.references :activity
    end
  end
end
