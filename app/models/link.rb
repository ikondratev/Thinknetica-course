class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def gist?
    url =~ %r{gist.github.com/\w+/\w+\z}
  end

  def gist_content
    if gist?
      gist = url.match('gist.github.com\/\w+\/(?<hash>\w+)\z')[:hash]
      GistService.new(gist).content
    end
  end
end
