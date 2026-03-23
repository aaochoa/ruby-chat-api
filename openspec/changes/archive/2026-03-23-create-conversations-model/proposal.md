## Why

To allow users to engage in chat-like interactions, we need a structure that organizes these interactions. A `Conversation` model serves as the primary container for messages (to be added later) and associates them with a `User`.

## What Changes

- Create a `Conversation` model.
- Establish a `has_many` relationship from `User` to `Conversation` (each conversation belongs to one user).
- Implement basic CRUD operations for conversations (Create, Read, Update, Delete).
- No `Message` model will be created at this stage.

## Capabilities

### New Capabilities
- `conversations-crud`: Basic management of conversations, allowing users to create and manage their own list of conversations.

### Modified Capabilities
- None

## Impact

- Database: New `conversations` table.
- Models: `Conversation` model and update `User` model with `has_many`.
- Controllers: `ConversationsController` for CRUD actions.
- Routing: Add resources for conversations.
