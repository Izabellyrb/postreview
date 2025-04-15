require 'httparty'
require 'faker'
require 'parallel'

API_URL = "http://localhost:3000/api/v1"

puts "Creating users..."
users = []
100.times do |i|
  login = Faker::Internet.unique.email
  users << login
end
puts "Created #{users.size} users."

# 50 Unique IPs
ips = Array.new(50) { Faker::Internet.unique.ip_v4_address }

puts "Creating approximately 200k posts (this might take a while)..."
post_ids = []
Parallel.each(1..200_000, in_threads: 100) do |i|
  data = {
    post: {
      title: Faker::Lorem.sentence(word_count: 6),
      body: Faker::Lorem.paragraph(sentence_count: 5),
      ip: ips.sample
    },
    user_login: users.sample
  }

  response = HTTParty.post("#{API_URL}/posts", body: data);nil
  puts "Failed to create post: #{response.parsed_response}" if response.code != 201
  puts "#{i} posts created..." if i % 50_000 == 0
end

post_ids = Post.pluck(:id)
puts "Total of posts on database: #{post_ids.size}."

# (75% of posts rated)
puts "Creating ratings..."
rated_posts = post_ids.sample((post_ids.size * 0.75).to_i)
user_ids = User.pluck(:id)

Parallel.each(1..rated_posts.size, in_threads: 100) do |i|
  data = {
    rating:
    {
      value: rand(1..5),
      post_id: post_ids.sample,
      user_id: user_ids.sample
    }
  }

  response = HTTParty.post("#{API_URL}/ratings", body: data);nil
  puts "Failed to rate post: #{response.parsed_response}" if response.code != 201
  puts "#{i} ratings created..." if i % 10_000 == 0
end

puts "Finished seeding database."
