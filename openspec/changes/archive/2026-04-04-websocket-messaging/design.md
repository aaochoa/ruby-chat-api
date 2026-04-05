## Context

The ruby-chat-api is a Rails 8.1 JSON API with JWT authentication (Devise + devise-jwt), conversations, messages with sender/recipient relationships, and friendships. Messages are currently created and fetched via REST endpoints only. The Gemfile already includes `solid_cable` (Rails 8's database-backed Action Cable adapter), but no Action Cable channels or connection class exist yet. Puma is the web server and natively supports WebSocket connections.

## Goals / Non-Goals

**Goals:**
- Enable real-time message delivery over WebSockets so clients receive messages instantly without polling
- Provide typing indicators so conversation participants see when someone is typing
- Track and broadcast online/offline presence for connected users
- Authenticate WebSocket connections using the existing JWT token system
- Leverage Action Cable with solid_cable — no additional infrastructure (Redis, etc.) required

**Non-Goals:**
- Replacing the REST API for message creation — messages are still created via POST; WebSockets handle delivery
- End-to-end encryption at the transport layer (rely on WSS in production)
- Read receipts or message delivery confirmations (future enhancement)
- Group presence beyond simple online/offline (e.g., "last seen" timestamps)
- Push notifications for offline users

## Decisions

### 1. Action Cable with solid_cable adapter

**Choice**: Use Rails Action Cable with the `solid_cable` adapter already in the Gemfile.

**Why**: solid_cable stores pub/sub messages in the database, eliminating the need for Redis in smaller deployments. It ships with Rails 8 and is already a dependency. For this chat app's scale, database-backed pub/sub is sufficient.

**Alternative considered**: Adding Redis as the Action Cable adapter. Rejected because it introduces an infrastructure dependency that isn't needed yet. Migration to Redis is straightforward later if needed.

### 2. JWT authentication on WebSocket connection

**Choice**: Authenticate the cable connection by extracting the JWT from a query parameter (`?token=<jwt>`) during the `connect` phase in `ApplicationCable::Connection`.

**Why**: WebSocket connections cannot send custom HTTP headers (like `Authorization: Bearer`) during the handshake. The standard approach is to pass the token as a query parameter. The token is validated once at connection time; individual channel subscriptions inherit the authenticated identity.

**Alternative considered**: Cookie-based authentication. Rejected because this is an API-only app with no cookie sessions — JWT is the established auth mechanism.

### 3. Channel architecture — three separate channels

**Choice**: Three distinct channels: `ChatChannel` (message delivery), `AppearanceChannel` (typing indicators), `PresenceChannel` (online/offline status).

**Why**: Separation of concerns — each channel has different streaming granularity:
- `ChatChannel` streams per-conversation (subscribe to a conversation, receive its messages)
- `AppearanceChannel` streams per-conversation (typing events scoped to a conversation)
- `PresenceChannel` streams globally for the user's contacts (any friend comes online/offline)

**Alternative considered**: A single multiplex channel with message types. Rejected because Action Cable's channel model already provides clean multiplexing, and separate channels are easier to test and evolve independently.

### 4. Broadcasting from the service/controller layer

**Choice**: Broadcast to Action Cable after a message is successfully created in `MessagesController#create` (or a future service object). The broadcast sends the serialized message to the conversation's stream.

**Why**: Keeps the broadcast close to the creation logic and ensures only persisted messages are broadcast. Avoids model callbacks which are harder to test and can fire unexpectedly.

**Alternative considered**: Using an Active Record callback (`after_create_commit`). Rejected to keep models thin per project conventions and to allow easier testing of broadcast behavior.

### 5. Presence tracking via in-memory channel state

**Choice**: Track online users by maintaining subscription state in `PresenceChannel` — broadcast "online" on subscribe, "offline" on unsubscribe. Use Action Cable's built-in connection tracking.

**Why**: Simple and sufficient for the initial implementation. No external state store needed. When a connection drops, Action Cable automatically triggers unsubscribe.

**Alternative considered**: Persistent presence in the database or Redis. Rejected as premature — the in-memory approach handles the core use case. Can be revisited if presence needs to survive server restarts.

## Risks / Trade-offs

- **[Single-server limitation]** → solid_cable's database adapter works well for single-server or small-cluster deployments. For horizontal scaling, migration to Redis adapter is a config change.
- **[Token in query string]** → JWT in URL could appear in server logs. Mitigation: filter the `token` parameter in Rails log filters; use WSS (TLS) in production.
- **[Connection lifecycle]** → If the client disconnects ungracefully, presence may lag until the server detects the dead connection. Mitigation: Action Cable's built-in heartbeat (default 3s ping) handles stale connection detection.
- **[No offline delivery]** → Messages sent while a user is disconnected are only available via REST polling when they reconnect. Mitigation: acceptable for MVP; push notifications are a planned future enhancement.
