module AnswersHelper
  def urls(files)
    files.map do |file|
      { id: file.id,
        name: file.filename.to_s,
        url: url_for(file) }
    end
  end

  def links(links)
    links.map do |link|
      { id: link.id,
        name: link.name,
        url: link.url,
        gist_content: link.gist? ? link.gist_content : '' }
    end
  end
end
