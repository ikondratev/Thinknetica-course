require 'rails_helper'

RSpec.describe Gift, type: :model do
  it { should belong_to :question }
  it { should belong_to(:answer).optional }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :name }

  it 'have one attached image' do
    expect(Gift.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
