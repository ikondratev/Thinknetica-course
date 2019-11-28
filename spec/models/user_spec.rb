require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  it { should validate_presence_of :u_name }
  it { should validate_presence_of :u_email }
end
