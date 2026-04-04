## 1. Database & Model Updates

- [x] 1.1 Create migration to add `first_name` and `last_name` to `users` table
- [x] 1.2 Run migration: `bundle exec rails db:migrate`
- [x] 1.3 Add validations and indexing for real name fields in `User` model

## 2. Searching Functionality

- [x] 2.1 Create `Api::V1::UsersController` with a `search` action
- [x] 2.2 Implement case-insensitive search logic for email, first name, and last name
- [x] 2.3 Add update profile action to `Api::V1::UsersController`
- [x] 2.4 Update routes in `config/routes.rb` to include user search and profile update

## 3. Profile Representation

- [x] 3.1 Update `UserSerializer` to include `first_name` and `last_name`

## 4. Befriending API Enhancement

- [x] 4.1 Ensure `Api::V1::FriendshipsController` allows adding friends and returns appropriate errors for duplicates
- [x] 4.2 Verify friendship endpoints in routes

## 5. Testing & Verification

- [x] 5.1 Add model specs for new User fields and search logic
- [x] 5.2 Add request specs for user search endpoint
- [x] 5.3 Add request specs for befriending endpoint
