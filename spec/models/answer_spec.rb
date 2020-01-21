require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'set the best answer' do
    let(:question) { create(:question, :with_answer) }
    let(:answer) { question.answers[0] }
    let(:other_answer) { question.answers[1] }

    context 'set the best answer' do
      before { answer.set_the_best }

      it { expect(answer).to be_the_best }
      it { expect(other_answer).to_not be_the_best }
    end

    context 'set oter answer as the best' do
      before do
        answer.set_the_best
        other_answer.set_the_best
        answer.reload
        other_answer.reload
      end

      it { expect(answer).to_not be_the_best }
      it { expect(other_answer).to be_the_best }
    end
  end
end
