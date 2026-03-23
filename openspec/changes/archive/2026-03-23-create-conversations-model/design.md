## Context

The system has a `User` model implemented with Devise for authentication. We are adding a `Conversation` model to organize chat sessions per user.

## Goals / Non-Goals

**Goals:**

- Create a `Conversation` model to store the context of interactive chat sessions.
- Relate `Conversation` to `User` (a user has many conversations, a conversation belongs to one user, in the beginning we will only support one-to-one conversations, but the model should be flexible enough to support group chats in the future).
- Provide basic CRUD operations via JSON API for managing conversations.
- Maintain consistent API versioning in the `api/v1` namespace.

**Non-Goals:**

- Implement `Message` or `Content` models.
- Implement group chats or shared conversations.
- Implement complex authorization beyond ensuring a user can only access their own conversations.

## Decisions

- **Database Structure**: Create tables for `conversations`:
  - `user_id`: foreign key referencing `users`, mandatory.
  - `title`: string, optional (can have a default title like "New Conversation").
- **Rails Generator**: Use `rails generate scaffold_controller Api::V1::Conversation` (or just resources in the controller) but we'll focus on the model first. For basic CRUD, a standard Rails controller will work.
- **Controller Location**: `app/controllers/api/v1/conversations_controller.rb`.
- **Model Relationship**:
  - `User`: `has_many :conversations, dependent: :destroy`.
  - `Conversation`: `belongs_to :user`.
- **Testing**: Use RSpec for unit tests (models) and request tests (controllers).
- **Authentication**: Ensure that conversation CRUD is only accessible to authenticated users and that they only access their own conversations.

## Risks / Trade-offs

- Simple one-to-many relationship might need refactoring if group chats are added in the future.
- If no title is provided, it might lead to poor UX; we'll provide a default title or allow blank titles.
