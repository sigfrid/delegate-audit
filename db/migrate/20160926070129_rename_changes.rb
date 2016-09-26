class RenameChanges < ActiveRecord::Migration[5.0]
  def change
    rename_column :role_audits, :changes, :audited_changes
  end
end
