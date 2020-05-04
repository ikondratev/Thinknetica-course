ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body, sortable: true
  indexes user.email
  indexes commentable_type

  has commentable_id
end
