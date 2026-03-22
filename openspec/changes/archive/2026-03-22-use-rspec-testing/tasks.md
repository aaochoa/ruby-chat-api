# Implementation Tasks: Use RSpec for Testing

## 1. Setup & Configuration

- [x] 1.1 Add rspec-rails, factory_bot_rails, faker, shoulda-matchers to Gemfile
- [x] 1.2 Run bundle install
- [x] 1.3 Run generator: `rails generate rspec:install`
- [x] 1.4 Configure spec/rails_helper.rb (DatabaseCleaner, FactoryBot inclusion, ShouldaMatchers)

## 2. Model Specs

- [x] 2.1 Create factory for User model in spec/factories/users.rb
- [x] 2.2 Migrate User model tests to spec/models/user_spec.rb (validations, email format)
- [x] 2.3 Verify User model specs pass: `bundle exec rspec spec/models`

## 3. Request Specs

- [x] 3.1 Create spec/support/auth_helpers.rb for JWT token generation in tests
- [x] 3.2 Migrate AuthController tests to spec/requests/api/v1/auth_spec.rb (register, login, profile)
- [x] 3.3 Verify Request specs pass: `bundle exec rspec spec/requests`

## 4. Cleanup & Finalization

- [x] 4.1 Remove existing test/ directory and its files
- [x] 4.2 Update README with RSpec execution instructions
- [x] 4.3 Run full test suite: `bundle exec rspec`
