## Why

Users want to connect and build a network with people they know. Adding a friends feature allows users to establish mutual connections, making it easier to start conversations and find people to chat with.

## What Changes

- Create a `Friendship` model to represent the relationship between two users.
- Add API endpoints to list friends, send friend requests, accept requests, and remove friends.
- Update the `User` model to include associations for friends and pending friend requests.

## Capabilities

### New Capabilities
- `friendships`: Manage user-to-user friend relationships including requesting, accepting, and removing friends.

### Modified Capabilities

## Impact

- **Models**: New `Friendship` model; updates to the existing `User` model associations.
- **Controllers**: New `FriendshipsController` for handling API requests.
- **Routes**: New nested routes under `/users` or top-level `/friendships` for managing the relationships.
- **Database**: New `friendships` table with foreign keys to the `users` table.
