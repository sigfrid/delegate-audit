class Audited < SimpleDelegator
  delegate :id, :to => :__getobj__

  def initialize(audited_object)
    super(audited_object)
    @auditee_class = audited_object.class
    @auditor_class = "#{audited_object.class}Audit".constantize
  end

  def save
    ActiveRecord::Base.transaction do
      audited_changes = changes
      super
      @auditor_class.create(auditee_id: id, audited_changes: audited_changes)
    end
  end
end
