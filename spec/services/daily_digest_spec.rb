require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest to users' do
    users.each { |user|  expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end
end
