## ADDED Requirements

### Requirement: Conversations List with Messages
The system SHALL optionally include the latest message or a list of messages when retrieving a conversation to provide context for the user.

#### Scenario: Retrieval with messages
- **WHEN** a user requests a conversation and includes the `messages` parameter
- **THEN** the system SHALL return the conversation details along with its associated messages
