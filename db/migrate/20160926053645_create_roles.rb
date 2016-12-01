class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, :state
      t.timestamps
    end

    create_table :role_audits do |t|
      t.integer     :auditee_id
      t.jsonb       :diff
      t.datetime    :created_at
    end

    add_index :role_audits, :auditee_id
  end
end
