## 1. Action Cable Setup & Authentication

- [x] 1.1 Run `bin/rails solid_cable:install` to generate the solid_cable migration and configuration
- [x] 1.2 Run the solid_cable database migration
- [x] 1.3 Configure Action Cable URL and allowed origins in `config/environments/` and `cable.yml`
- [x] 1.4 Mount Action Cable in `config/routes.rb` if not auto-mounted
- [x] 1.5 Implement `ApplicationCable::Connection` with JWT authentication from `?token=` query parameter — reject unauthorized connections
- [x] 1.6 Add `token` to Rails log filter parameters to prevent JWT leaking into logs
- [x] 1.7 Write connection tests: valid token connects, missing/expired/invalid tokens are rejected

## 2. ChatChannel — Real-time Message Delivery

- [x] 2.1 Create `ChatChannel` that accepts a `conversation_id` param and verifies the user is a conversation participant before subscribing
- [x] 2.2 Stream from `"chat_conversation_#{conversation_id}"` on successful subscription; reject non-participants
- [x] 2.3 Add broadcast logic in `MessagesController#create` — after successful message save, broadcast serialized message to the conversation stream
- [x] 2.4 Write ChatChannel tests: participant subscribes, non-participant rejected, message broadcast received by subscribers

## 3. AppearanceChannel — Typing Indicators

- [x] 3.1 Create `AppearanceChannel` that accepts a `conversation_id` param and verifies participant access
- [x] 3.2 Stream from `"appearance_conversation_#{conversation_id}"` on successful subscription
- [x] 3.3 Implement `typing` action that broadcasts `{ user_id, username, typing }` to the conversation stream (exclude sender)
- [x] 3.4 Write AppearanceChannel tests: subscribe/reject, typing true/false broadcasts to other participants

## 4. PresenceChannel — Online/Offline Status

- [x] 4.1 Create `PresenceChannel` with global presence stream per user's friend group
- [x] 4.2 On subscribe: broadcast `{ user_id, status: "online" }` to the user's friends' presence streams
- [x] 4.3 On subscribe: send the user a list of their currently online friends
- [x] 4.4 On unsubscribe: broadcast `{ user_id, status: "offline" }` to the user's friends' presence streams
- [x] 4.5 Write PresenceChannel tests: online broadcast on subscribe, offline broadcast on unsubscribe, online friends list sent on subscribe

## 5. Integration & Verification

- [ ] 5.1 Verify multiple simultaneous conversation subscriptions work over a single connection
- [ ] 5.2 Verify Action Cable heartbeat and stale connection cleanup with solid_cable
- [ ] 5.3 Run full test suite and ensure no regressions in existing REST API tests
