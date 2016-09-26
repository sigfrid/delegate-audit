class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, :state
      t.timestamps
    end

    Role.create_audit_table
  end
end
