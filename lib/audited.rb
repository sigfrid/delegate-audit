require 'json'

class Audited < SimpleDelegator
  delegate :id, :to => :__getobj__

  def initialize(audited_object, options={})
    super(audited_object)
    @auditee_class = audited_object.class
    @audited_object = audited_object
    @auditor_class = "#{audited_object.class}Audit".constantize
    @audited_associations = through_associations_without(options[:ignore])
  end

  def save!
    ActiveRecord::Base.transaction do
      audited_changes = changes.merge(associations_changes)
      super
      @auditor_class.create(auditee_id: id, audited_changes: audited_changes)
    end
    self
    rescue StandardError
    false
  end

  def audits
    @auditor_class.where(auditee_id: id)
  end

private

  def through_associations_without(ignored_associations)
    audited_associations = Array(@auditee_class.reflect_on_all_associations(:has_many).reject { |association| Array(ignored_associations).include? association.name })

    audited_associations.map { |association| association.options[:through] }
                        .compact
  end

  def associations_changes
    return {} if @audited_associations.empty?
    associated_collections.each_with_object({}) do |associated_collection, association_changes|
      changes_of(associated_collection).each do |change|
        association_changes.merge!(change) { |k, a, b| a.zip(b).transpose }
      end
    end
  end

  def associated_collections
    @audited_associations.map { |association| @audited_object.send(association) }
  end

  def changes_of(associated_collection)
    Array(associated_collection).map { |association| extract_associated_object_from(association) }
                                .reject { |changes| changes == {} }
  end

  def extract_associated_object_from(association)
    association.changes.slice(other(association))
  end

  def other(association)
   association.class.reflect_on_all_associations(:belongs_to).detect { |a| a.foreign_key !~ Regexp.new(@auditee_class.to_s.downcase) and break a.foreign_key }
  end
end
