## Why

The application currently supports conversations but lacks the ability to send and receive messages within those conversations. This change introduces the core message functionality, allowing users to communicate.

## What Changes

- Introduction of a `Message` model to store the content and metadata of a message.
- A one-to-many relationship between `Conversation` and `Message`.
- Support for message bodies, media attachments, and identification of sender and receiver(s).
- Basic CRUD operations for messages (create, read, and list) within the context of a conversation.

## Capabilities

### New Capabilities
- `messages-crud`: Core operations for creating, reading, and listing messages within a conversation. This includes support for text bodies, media, and sender/receiver definitions.

### Modified Capabilities
- `conversations-crud`: Ensure conversations can correctly reference and list their associated messages.

## Impact

- **Database**: New `messages` table and migration to link it to `conversations`.
- **API**: New endpoints under `/api/v1/conversations/:conversation_id/messages` for CRUD operations.
- **Models**: `Message` model added; `Conversation` model updated to include `has_many :messages`.
- **Dependencies**: Potential new gems for handling media attachments (e.g., Active Storage) if not already present.
