module Voted
  extend ActiveSupport::Concern

  def like
    vote!(:like)
  end

  def dislike
    vote!(:dislike)
  end

  private

  def vote!(type)
    thing_name = controller_name.classify.underscore
    thing = send(thing_name)
    vote = thing.current_vote(current_user)

    if vote
      vote.like! if type == :like
      vote.dislike! if type == :dislike
    end

    render json: { score: thing.score }
  end
end
