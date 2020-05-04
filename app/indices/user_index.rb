ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email, sortable: true

  has created_at, updated_at
end
