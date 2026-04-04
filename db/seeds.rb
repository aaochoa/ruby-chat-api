# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up existing seed data..."

first_names = %w[Alice Bob Carol Dan Eve Frank Grace Hank Iris Jack]
last_names  = %w[Smith Johnson Williams Brown Jones Garcia Miller Davis Wilson Moore]
seed_emails = (1..10).map { |i| "user#{i}@example.com" }

User.where(email: seed_emails).delete_all

puts "Seeding users..."

seed_emails.each_with_index do |email, i|
  User.create!(
    email: email,
    password: "password123",
    password_confirmation: "password123",
    first_name: first_names[i],
    last_name: last_names[i]
  )
end

puts "#{seed_emails.size} test users seeded!"
