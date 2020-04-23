class ReputationJob < ApplicationJob
  queue_as :default

  def perform(obj)
    ReputationService.calculate(obj)
  end
end
