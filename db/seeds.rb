# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

unless Rails.env.development?
  puts "Seed script is only intended for the development environment. Aborting."
  exit
end

puts "Cleaning up existing seed data..."

MessageRecipient.delete_all
Message.delete_all
Conversation.delete_all
Friendship.delete_all
User.delete_all

puts "Seeding 20 users..."

users = 20.times.map do |i|
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

puts "#{users.size} users created."

puts "Seeding friendships..."

friendship_pairs = users.combination(2).to_a.sample(30)

friendship_pairs.each do |user, friend|
  Friendship.create!(user: user, friend: friend, status: :accepted)
end

puts "#{Friendship.count} friendships created (including inverses)."

puts "Seeding conversations and messages..."

conversation_count = 0
message_count = 0

friendship_pairs.sample(15).each do |user, friend|
  conversation = Conversation.create!(
    user: user,
    title: "Chat between #{user.first_name} and #{friend.first_name}"
  )
  conversation_count += 1

  rand(3..8).times do
    sender = [user, friend].sample
    receiver = sender == user ? friend : user

    message = Message.create!(
      conversation: conversation,
      sender: sender,
      body: Faker::Lorem.sentence(word_count: rand(4..15))
    )

    MessageRecipient.create!(message: message, user: receiver)
    message_count += 1
  end
end

puts "#{conversation_count} conversations created."
puts "#{message_count} messages created."
puts "Seeding complete!"
