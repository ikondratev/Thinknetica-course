# frozen_string_literal: true

module ApplicationHelper
  def personal_collection_cache_key_for(model, user)
    user.present? ? user_id = user.id : user_id = '0'
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-user-#{user_id}-#{max_updated_at}"
  end
end
