# typing-indicators Specification

## Purpose
TBD - created by archiving change websocket-messaging. Update Purpose after archive.
## Requirements
### Requirement: Subscribe to typing indicators channel
The system SHALL allow authenticated conversation participants to subscribe to an `AppearanceChannel` scoped to a specific conversation. Only conversation participants SHALL be allowed to subscribe.

#### Scenario: Participant subscribes to typing channel
- **WHEN** an authenticated user subscribes to `AppearanceChannel` with a valid `conversation_id`
- **THEN** the subscription is confirmed and the user can send and receive typing events for that conversation

#### Scenario: Non-participant is rejected from typing channel
- **WHEN** an authenticated user subscribes to `AppearanceChannel` for a conversation they do not participate in
- **THEN** the subscription is rejected

### Requirement: Broadcast typing status
The system SHALL allow subscribed users to send a "typing" action through the `AppearanceChannel`. The system MUST broadcast the typing status (user_id, username, typing: true/false) to all other subscribers of the same conversation. The sender SHALL NOT receive their own typing broadcast.

#### Scenario: User starts typing
- **WHEN** a subscribed user sends a typing action with `typing: true` to the `AppearanceChannel`
- **THEN** all other subscribers of that conversation receive a broadcast with `{ user_id, username, typing: true }`

#### Scenario: User stops typing
- **WHEN** a subscribed user sends a typing action with `typing: false` to the `AppearanceChannel`
- **THEN** all other subscribers of that conversation receive a broadcast with `{ user_id, username, typing: false }`

