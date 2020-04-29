ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body

  # attributes
  has user.id, created_at, updated_at
end
