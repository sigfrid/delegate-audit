module Auditable
  extend ActiveSupport::Concern

  def build_for_audit(params)
    associations, attributes = params.to_h.partition { |key, _| key.last(4) == "_ids" }.map(&:to_h)

    attributes.each do |attribute, value|
      self.write_attribute(attribute, value)
    end

    associations.each do |key, values|
      association = key.chomp('_ids')
      associated_class = association.classify.constantize
      association_name = association.pluralize.to_sym
      through_association_name = self.class.reflect_on_all_associations(:has_many).detect { |association| association.name == association_name }.options[:through]

      current_association_ids = self.send(key)
      new_association_ids = values.map { |value| value.to_i }

      association_ids_to_add = new_association_ids - current_association_ids
      association_ids_to_remove = current_association_ids - new_association_ids

      association_ids_to_add.each do |id|
        self.association(association_name).send(:build_through_record, associated_class.find(id))
      end

      association_ids_to_remove.each do |id|
        singularized_key = key.singularize
        self.send(through_association_name).detect { |through| through.send(singularized_key) == id }.send("#{singularized_key}=", nil)
      end
    end
  end
end
