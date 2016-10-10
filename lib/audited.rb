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
      audited_changes = changes.merge(associations_changes_as_hash)
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

  def associations_changes_as_hash
    if @audited_associations.empty?
      p "EMPTY"
      { }
    else
      #p JSON.parse(associations_changes.join(','))
    #  p JSON.generate(associations_changes)
      JSON.generate(associations_changes)
    end
  end

  def associations_changes
    associated_collections = @audited_associations.map { |association| @audited_object.send(association) }


    p associated_collections

     associated_collections.each_with_object({}) do |associated_collection, associations_changes|
       p association_changes(associated_collection)


       association_changes(associated_collection).each_with_index do |change_hash, i|
         p change_hash

        myhash = Hash[change_hash.map{|k,v| ["#{i}_#{k}",v]}]

        p myhash
        #stringHash = myhash.to_s
        #stringJson = stringHash.gsub("=>", ":").gsub("nil", "null")

      x =   associations_changes.merge(myhash)
      p x
      p " ----"
      x

      end
    end
  end

  def through_associations_without(ignored_associations)
    audited_associations = Array(@auditee_class.reflect_on_all_associations(:has_many).reject { |association| Array(ignored_associations).include? association.name })

    audited_associations.map { |association| association.options[:through] }
                        .compact
  end

  def association_changes(associated_collection)
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
