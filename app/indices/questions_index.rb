ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes user.email

  # attributes
  has user.id, created_at, updated_at
end
