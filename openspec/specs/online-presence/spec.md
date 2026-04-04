# online-presence Specification

## Purpose
TBD - created by archiving change websocket-messaging. Update Purpose after archive.
## Requirements
### Requirement: Subscribe to presence channel
The system SHALL allow authenticated users to subscribe to a `PresenceChannel`. Upon successful subscription, the system MUST broadcast an "online" event to the subscribing user's friends (accepted friendships).

#### Scenario: User subscribes to presence channel
- **WHEN** an authenticated user subscribes to `PresenceChannel`
- **THEN** the subscription is confirmed and an `{ user_id, status: "online" }` event is broadcast to all of the user's friends who are subscribed to `PresenceChannel`

### Requirement: Broadcast offline on disconnect
The system SHALL broadcast an "offline" event to the user's friends when the user's `PresenceChannel` subscription ends (explicit unsubscribe or connection drop).

#### Scenario: User disconnects
- **WHEN** a subscribed user's WebSocket connection is closed or the user unsubscribes from `PresenceChannel`
- **THEN** an `{ user_id, status: "offline" }` event is broadcast to all of the user's friends who are subscribed to `PresenceChannel`

### Requirement: Receive friends' presence on subscribe
The system SHALL send the subscribing user a list of their currently online friends when they first subscribe to the `PresenceChannel`.

#### Scenario: User receives online friends list
- **WHEN** an authenticated user subscribes to `PresenceChannel`
- **THEN** the user receives a message containing the list of their friends who are currently online

