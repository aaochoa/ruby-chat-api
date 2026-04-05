## Why

The chat API currently only supports sending and retrieving messages via REST endpoints, requiring clients to poll for new messages. Adding WebSocket support via Action Cable enables real-time message delivery, typing indicators, and online presence — essential for a responsive chat experience.

## What Changes

- Introduce an Action Cable `ChatChannel` that authenticates users via JWT and streams messages within conversations in real time
- Introduce a `PresenceChannel` for online/offline status tracking across connected users
- Add an `AppearanceChannel` for typing indicators within conversations
- Broadcast new messages from the existing message creation flow to conversation subscribers
- Configure Action Cable authentication to reuse the existing JWT-based auth system
- Mount the Action Cable server alongside the existing Rails API

## Capabilities

### New Capabilities

- `realtime-messaging`: WebSocket channel for real-time message delivery within conversations, including JWT authentication for cable connections
- `typing-indicators`: WebSocket channel for broadcasting typing status to conversation participants
- `online-presence`: WebSocket channel for tracking and broadcasting user online/offline status

### Modified Capabilities

<!-- No existing spec-level requirements are changing. The REST API remains unchanged. -->

## Impact

- **Code**: New Action Cable channels (`ChatChannel`, `PresenceChannel`, `AppearanceChannel`), connection authentication class, and broadcast hooks in message creation flow
- **Dependencies**: Already satisfied — `solid_cable` is in the Gemfile as the Action Cable adapter
- **APIs**: New WebSocket endpoint at `/cable`; existing REST API is unchanged
- **Infrastructure**: Requires `solid_cable` database migration for cable message storage; Puma already supports concurrent WebSocket connections
