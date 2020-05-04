ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body, sortable: true
  indexes user.email

  has user_id, created_at, updated_at
end
