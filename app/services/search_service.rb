class SearchService
  THINGS = %w[Question Answer User Comment].freeze

  def self.search_by(search_line, thing = nil)
    return [] if search_line.blank?

    query = Riddle::Query.escape(search_line)

    if THINGS.include?(thing)
      thing.constantize.search(query)
    else
      ThinkingSphinx.search(query)
    end
  end
end
