## ADDED Requirements

### Requirement: WebSocket connection authentication
The system SHALL authenticate Action Cable connections using a JWT token passed as a query parameter (`?token=<jwt>`). The connection MUST identify the `current_user` from the decoded token. Connections with missing, expired, or invalid tokens SHALL be rejected.

#### Scenario: Valid JWT token connects successfully
- **WHEN** a client opens a WebSocket connection to `/cable?token=<valid_jwt>`
- **THEN** the connection is established and the user is identified as `current_user`

#### Scenario: Missing token rejects connection
- **WHEN** a client opens a WebSocket connection to `/cable` without a token parameter
- **THEN** the connection is rejected with an unauthorized status

#### Scenario: Expired token rejects connection
- **WHEN** a client opens a WebSocket connection with an expired JWT
- **THEN** the connection is rejected with an unauthorized status

#### Scenario: Invalid token rejects connection
- **WHEN** a client opens a WebSocket connection with a malformed or tampered JWT
- **THEN** the connection is rejected with an unauthorized status

### Requirement: Subscribe to conversation stream
The system SHALL allow authenticated users to subscribe to a `ChatChannel` for a specific conversation. The user MUST be a participant of the conversation (owner or message recipient) to subscribe. Unauthorized subscription attempts SHALL be rejected.

#### Scenario: Conversation participant subscribes successfully
- **WHEN** an authenticated user subscribes to `ChatChannel` with a `conversation_id` they participate in
- **THEN** the subscription is confirmed and the user receives messages streamed to that conversation

#### Scenario: Non-participant is rejected
- **WHEN** an authenticated user subscribes to `ChatChannel` with a `conversation_id` they do not participate in
- **THEN** the subscription is rejected

### Requirement: Real-time message broadcast
The system SHALL broadcast new messages to all subscribers of the conversation's `ChatChannel` stream when a message is successfully created. The broadcast payload MUST include the serialized message data (id, body, sender, created_at, media URL if present).

#### Scenario: New message is broadcast to conversation subscribers
- **WHEN** a message is created in a conversation via the REST API
- **THEN** all users subscribed to that conversation's `ChatChannel` receive the serialized message in real time

#### Scenario: Message with media is broadcast with media URL
- **WHEN** a message with an attached media file is created in a conversation
- **THEN** the broadcast payload includes the media URL alongside the message body

### Requirement: Multiple conversation subscriptions
The system SHALL allow a single user to subscribe to multiple conversations simultaneously over the same WebSocket connection.

#### Scenario: User subscribes to multiple conversations
- **WHEN** an authenticated user subscribes to `ChatChannel` for conversation A and conversation B
- **THEN** the user receives messages from both conversations independently
