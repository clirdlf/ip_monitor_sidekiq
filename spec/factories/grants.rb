FactoryBot.define do
  factory :grant do
    title { Faker::Book.title }
    contact { Faker::Name.name }
    filename { Faker::File.file_name(ext: 'xlsx') }
    email { Faker::Internet.email }
    grant_number { Faker::Code.imei }
    institution { Faker::University.name }
    program { ["Digitizing Hidden Collections", "Recordings at Risk"].sample }
    submission { Faker::Date.between(from: 2.years.ago, to: Date.today)}
  end
end
