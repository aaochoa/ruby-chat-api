## Why

During development and testing, it is crucial to have a rich set of data. The current database lacks a robust initial state, making it harder to test features like friend management and conversations. Updating the seed data to include at least 20 users with pre-established friendships and conversations provides a much better development environment.

## What Changes

- Modify `db/seeds.rb` to first clean the database.
- Create 20 distinct users.
- Create friendships among a subset of these users.
- Create conversations with messages between some of these users.

## Capabilities

### New Capabilities
- `database-seeding`: Establishing robust seed data for development and testing.

### Modified Capabilities

## Impact

- **Database:** Only affects data generation via `db/seeds.rb`. Clean sweep could be dangerous for production, so it must ensure it only runs in development or handles data destruction safely.
- **Developer Experience:** Significantly improves local testing.
