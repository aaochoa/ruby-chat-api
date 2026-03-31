## Context

Users are currently identified only by email. To enhance social features, we need to allow users to set their real names and find others by those names or emails. The application already has a `friendships` table in the schema, but the logic for finding and adding friends via an API endpoint is not yet implemented.

## Goals / Non-Goals

**Goals:**
- Add `first_name` and `last_name` to the `Users` table.
- Implement a search endpoint for users.
- Implement an endpoint to create friendships.
- Update the User representation in API responses.

**Non-Goals:**
- Friend request/approval flow (for now, befriending will be immediate if the model supports it, otherwise we'll follow the existing status column).
- Blocking users.
- Profile pictures (out of scope for this task).

## Decisions

- **Database**: Add `first_name` and `last_name` as strings to the `users` table via a migration.
- **Search Logic**: Implementation will use PostgreSQL `ILIKE` for case-insensitive partial matches on `first_name`, `last_name`, and `email`.
  - To prevent befriending existing friends again, friends will be excluded from search results.
  - Search query will be: `User.where("(first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q) AND id != :my_id", q: "%#{params[:query]}%", my_id: current_user.id).where.not(id: current_user.friends.pluck(:id))`
- **Controller**: Use a new `UsersController` for searching and profile updates.
- **Friendships**: Use the existing `Friendship` model. If it has a `status` column (it does, default 0), we will set it to `active` (assuming 1 is active, need to check `friendship.rb`).

## Risks / Trade-offs

- **Privacy**: Searching by email might expose users who don't want to be found. (Mitigation: For now, all users are searchable; in the future, we could add a `searchable` flag).
- **Performance**: ILIKE searches on large tables can be slow without proper indexing. (Mitigation: Add indexes or use full-text search if the user base grows significantly).
