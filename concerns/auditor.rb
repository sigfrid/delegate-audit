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
 end
end

ActiveRecord::Base.send(:include, Auditor)
