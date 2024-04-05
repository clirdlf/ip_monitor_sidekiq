FactoryBot.define do
  factory :resource do
    grant
    access_filename { Faker::File.file_name }
    access_url { Faker::Internet.url }
    checksum { Faker::Crypto.md5 }
    restricted { Faker::Boolean.boolean }
    restricted_comments { Faker::Lorem.paragraph(sentence_count: 2) }
    # statuses_count { 0 }

  end

  factory :invalid_resource do 
    grant
    access_filename { Faker::File.file_name }
    access_url {"c:/foo/bar"}
    checksum { Faker::Crypto.md5 }
    restricted { Faker::Boolean.boolean }
    restricted_comments { Faker::Lorem.paragraph(sentence_count: 2) }
    statuses_count { 0 }
  end
end
