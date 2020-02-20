module Commented
  extend ActiveSupport::Concern

  included do
    helper_method :comment
  end

  private

  def comment
    Comment.new
  end
end
