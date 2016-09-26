module Auditor
 extend ActiveSupport::Concern

 module ClassMethods
   def audited
     mattr_accessor :audit_class_name
     self.audit_class_name = 'Audit'

     const_set(audit_class_name, Class.new(ActiveRecord::Base))
     audit_class.belongs_to self.to_s.underscore.to_sym

     has_many :audits, class_name: audit_class.to_s
   end

   def audit_class
     const_get audit_class_name
   end

   def audit_table_name
    audit_class.to_s.tableize.gsub('/', '_')
   end

   def audited_class_name
     audit_class.to_s.chomp('::Audit').downcase
   end

   def create_audit_table
     self.connection.create_table(audit_table_name) do |t|
       t.column "#{audited_class_name}_id".to_sym, :integer
       t.column :action, :string
       t.column :audited_changes, :jsonb
       t.column :created_at, :datetime
     end

     self.connection.add_index audit_table_name, "#{audited_class_name}_id"
   end
  end
end

ActiveRecord::Base.send(:include, Auditor)
