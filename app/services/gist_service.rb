class GistService
  def initialize(gist, client: default_client)
    @gist = gist
    @client = client
  end

  def content
    result = @client.gist(@gist)
    result.files.first[1].content if result.html_url.present?
  rescue StandardError
    nil
  end

  private

  def default_client
    Octokit::Client.new
  end
end
