## 1. Database and Models

- [x] 1.1 Generate the `Conversation` migration: `rails generate model Conversation user:references title:string`
- [x] 1.2 Update the `User` model to establish the `has_many` relationship.
- [x] 1.3 Update the `Conversation` model to include basic validations.
- [x] 1.4 Execute the migration: `rails db:migrate`

## 2. API Implementation

- [x] 2.1 Add resources for `:conversations` in `config/routes.rb` within the `api/v1` namespace.
- [x] 2.2 Create the `Api::V1::ConversationsController` with CRUD actions: `index`, `show`, `create`, `update`, `destroy`. On destroy action we are soft deleting the conversation, so we need to add a `deleted_at` and `deleted_by` columns to the `conversations` table.
- [x] 2.3 Implement authentication and authorization to ensure users can only access their own conversations.

## 3. Testing and Verification

- [x] 3.1 Write model specs in `spec/models/conversation_spec.rb` to verify relationships and validations.
- [x] 3.2 Write request specs in `spec/requests/api/v1/conversations_spec.rb` for CRUD operations and ownership enforcement.
- [x] 3.3 Verify that all tests pass: `bundle exec rspec`
