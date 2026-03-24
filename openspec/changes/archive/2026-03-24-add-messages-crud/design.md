## Context

The system currently manages `Conversations` and `Users`. Conversations are currently owned by a single user. To provide a full chat experience, we need to introduce `Messages`.

Existing architecture:
- Rails 8+ project as an API.
- PostgreSQL database.
- Devise with JWT for authentication.

## Goals / Non-Goals

**Goals:**
- Implement a `Message` model with support for text and media.
- Store the sender and support multiple receivers (for future group chat support).
- Provide basic CRUD via API (create, list, show).
- Associate messages with conversations.

**Non-Goals:**
- Real-time updates (ActionCable/WebSockets) - out of scope for initial CRUD.
- Complex group management (participants) - although the message schema will support multiple recipients.
- Message editing/deleting (soft delete) - keep it simple first.

## Decisions

### 1. Data Model for Messages
We will create a `Message` model that belongs to a `Conversation` and a `Sender` (User).

- **`Message` table**: `body` (text), `conversation_id`, `sender_id`.
- **`MessageRecipient` table**: A join table linking `Message` and `User` to track recipients. This allows a single message to have one or many receivers, fulfilling the "future group chat" requirement without breaking initial 1:1 logic.

### 2. Media Handling
We will use **Active Storage** for media attachments. The `Message` model will `has_one_attached :media`. This provides a consistent way to handle images, videos, or documents.

### 3. API Endpoints
Endpoints will be nested under conversations:
- `POST /api/v1/conversations/:conversation_id/messages`: Create a new message.
- `GET /api/v1/conversations/:conversation_id/messages`: List messages in chronological order.
- `GET /api/v1/messages/:id`: Show a single message.

### 4. Authentication and Permissions
- Users must be authenticated to send/view messages.
- A user can only view messages in conversations they "participate" in. Initially, since conversations belong to an owner, we should ensure the requester is either the owner or identified as a recipient.

## Risks / Trade-offs

- **[Risk] High message volume slowing down conversation loading** → [Mitigation] Implement pagination for the messages index and index the `conversation_id` and `created_at` fields.
- **[Risk] Multiple receivers complexity** → [Mitigation] Even for initial 1:1 chats, using a `MessageRecipient` join table keeps the query logic future-proofed for group chats.
