# Messages CRUD

## Purpose
This capability handles the core operations for creating, reading, and listing messages within a conversation, including support for text, media, and recipient identification.

## Requirements

### Requirement: Send Message in Conversation
The system SHALL allow users to send messages within a specific conversation. A message MUST have a body or a media attachment.

#### Scenario: Successfully sending a text message
- **WHEN** a user sends a message with a body to a conversation
- **THEN** the system SHALL create a new message associated with that conversation and the sender

#### Scenario: Successfully sending a media message
- **WHEN** a user sends a message with a media attachment to a conversation
- **THEN** the system SHALL create a new message with the media reference

### Requirement: List Messages in Conversation
The system SHALL provide a way to list all messages belonging to a specific conversation, ordered by creation time.

#### Scenario: Viewing message history
- **WHEN** a user requests the list of messages for a conversation
- **THEN** the system SHALL return all messages associated with that conversation, sorted from oldest to newest

### Requirement: Identify Sender and Receiver
Each message SHALL identify the user who sent it and the user(s) intended to receive it. While initially supporting a single receiver, the system MUST be designed to support multiple receivers.

#### Scenario: Message with sender and single receiver
- **WHEN** a message is sent
- **THEN** the system SHALL store the sender ID and the receiver ID(s)
