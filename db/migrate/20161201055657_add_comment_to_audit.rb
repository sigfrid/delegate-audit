class AddCommentToAudit < ActiveRecord::Migration[5.0]
  def change
    add_column :role_audits, :comment, :text
  end
end
