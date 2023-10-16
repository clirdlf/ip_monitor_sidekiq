require 'curb'

connect_timeout = 10

# https://www.rubydoc.info/github/taf2/curb/Curl/Easy
# these are from http://localhost:3000/grants/93
url = 'https://louisianadigitallibrary.org/islandora/object/amistad-pie%3A41'
url = 'https://louisianadigitallibrary.org/islandora/object/amistad-pie%3A18'
h = Curl::Easy.new(url)
h.set :nobody, true
h.follow_location = true
h.connect_timeout = connect_timeout

puts "Connecting to #{url}"
h.perform

puts h.header_str

puts "Total Time: #{h.total_time}"


