FactoryBot.define do
  factory :file do
    attachmentable nil
    file { Rack::Test::UploadedFile.new("#{Rails.root}/README.md") }
  end
end
