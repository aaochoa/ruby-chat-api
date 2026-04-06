## 1. Safety and Cleanup

- [x] 1.1 Add safeguard to ensure seeding only applies in `development` environment if destructive.
- [x] 1.2 Add logic to destroy existing Users, Friendships, Conversations, and Messages.

## 2. Generate Base Records

- [x] 2.1 Use Faker (if available) or generic loops to create at least 20 User records.
- [x] 2.2 Verify Users are created correctly.

## 3. Generate Relations

- [x] 3.1 Randomly pair up users to create Friendships between them.
- [x] 3.2 Create some Conversations between matched friends.
- [x] 3.3 Create a few Messages for each created Conversation to populate thread history.

## 4. Verification

- [x] 4.1 Run `rake db:seed` and ensure it executes without errors.
- [x] 4.2 Validate the database has the expected counts of users, friendships, and conversations.
