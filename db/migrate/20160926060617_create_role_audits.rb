class CreateRoleAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :role_audits do |t|
       t.references :role
       t.string :action
       t.jsonb :changes, null: false, default: '{}'
       t.datetime :created_at
    end
  end
end
