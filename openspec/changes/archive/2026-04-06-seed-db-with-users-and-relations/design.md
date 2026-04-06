## Context

The API has friendships, conversations, and users, but setting it all up manually to properly test the client UI is tedious. A good seed script is needed.

## Goals / Non-Goals

**Goals:**
- Clean out the current development dataset on every run.
- Generate at least 20 Users.
- Form Friendships between these users.
- Form Conversations with sample Messages among some users.

**Non-Goals:**
- Seed data for production.
- Generate complex real-world chat histories (a few messages per conversation is enough).

## Decisions

- **Destruction First:** The script will first do `User.destroy_all`, `Friendship.destroy_all`, `Conversation.destroy_all`, etc. (or use `destroy_all` responsibly to clear associations).
- **Faker Gem:** Use the `faker` gem if available to generate realistic user data. Otherwise use simple indexed loops.
- **Random Relationships:** Relationships will be distributed somewhat randomly but assure coverage so the developer has actual relationships to test UI states.

## Risks / Trade-offs

- **Risk:** Accidentally running in production tears down live data.
  → **Mitigation:** Wrap the destruction code in an `if Rails.env.development?` block.
