FactoryBot.define do
  factory :status do

    resource factory: :resource

    response_code { Faker::Internet::HTTP.status_code }
    response_time { Faker::Number.normal(mean: 50, standard_deviation: 3.5) }

    
  end
end
