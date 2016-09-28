class Audited < SimpleDelegator
  delegate :id, :to => :__getobj__

  def initialize(audited_object, options={})
    super(audited_object)
    @auditee_class = audited_object.class
    @audited_object = audited_object
    @auditor_class = "#{audited_object.class}Audit".constantize
    @audited_associations = Array(options[:associations])
  end

  def save
    ActiveRecord::Base.transaction do
      audited_changes = changes.merge(associations_changes_as_hash)
      super
      @auditor_class.create(auditee_id: id, audited_changes: audited_changes)
    end
  end

  def revisions
    @auditor_class.where(auditee_id: id)
  end

  private

  def associations_changes_as_hash
    if @audited_associations.empty?
      { }
    else
      { "associations" => associations_changes.flatten }
    end
  end

  def associations_changes
    associated_collections = through_associations.map { |association| @audited_object.send(association) }

    associated_collections.each_with_object([]) do |associated_collection, associations_changes|
      associations_changes << association_changes(associated_collection)
    end
  end

  def through_associations
    @audited_associations.map { |association| String(@auditee_class.reflections[association].options[:through]) }
  end

  def association_changes(associated_collection)
    Array(associated_collection).map { |association| extract_associated_object_from(association) }
                                .reject{ |changes| changes == {} }
  end

  def extract_associated_object_from(association)
    association.changes.slice(other(association))
  end

  def other(association)
   association.class.reflect_on_all_associations(:belongs_to).detect { |a| a.foreign_key !~ /@auditee_class.to_s.downcase/ and break a.foreign_key }
  end
end
