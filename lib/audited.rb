class Audited < SimpleDelegator
  delegate :id, :to => :__getobj__

  def initialize(audited_object)
    super(audited_object)
    @auditee_class = audited_object.class
    @audited_object = audited_object
    @auditor_class = "#{audited_object.class}Audit".constantize
    @audited_associations = ["duties"]
  end

  def save
    ActiveRecord::Base.transaction do
      audited_changes = changes.merge(associciations_changes)
      super
      @auditor_class.create(auditee_id: id, audited_changes: audited_changes)
    end
  end

  def revisions
    @auditor_class.where(auditee_id: id)
  end

  private



   #[{"activity_id"=>[1, nil]}, {"activity_id"=>[nil, 3]}].flatten.reduce(:merge)

  def associciations_changes
    associated_collections = @audited_associations.map { |association| @audited_object.send(association) }

    x = associated_collections.each_with_object([]) do |associated_collection, associations_changes|
      associations_changes << association_changes(associated_collection)
    end

    { "associations" => x.flatten }
  end

  def association_changes(associated_collection)
    Array(associated_collection).map { |association| extract_associated_object_from(association) }
  end

  def extract_associated_object_from(association)
  #  p association.changes
  #  p association.changes.slice(other(association))
  #  sleep 3


    association.changes.slice(other(association))
  end

  def other(association)
   association.class.reflect_on_all_associations(:belongs_to).detect { |a| a.foreign_key !~ /@auditee_class.to_s.downcase/ and break a.foreign_key }
  end
end

# => [[{"activity_id"=>[1, nil]}, {"activity_id"=>[nil, 3]}]]
