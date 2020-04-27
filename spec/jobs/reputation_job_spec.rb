require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls ReputationServices#calculate' do
    expect(ReputationService).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
