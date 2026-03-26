## Context

The chat API currently supports basic user registration and messaging. However, there is no formalized way for users to connect with each other. A friend system is a core building block for any social or communication application, allowing users to curate their network and easily start conversations.

## Goals / Non-Goals

**Goals:**
- Allow users to send, accept, and reject friend requests.
- Provide a robust DB schema to represent connections between users.
- Expose RESTful JSON endpoints for the frontend to manage friendships.

**Non-Goals:**
- Social features like "friends of friends" recommendations.
- A user blocking system (this should be a separate architectural capability).

## Decisions

- **Database Schema**: We will introduce a `Friendship` model bridging two `User` models (`user_id` and `friend_id`) along with a `status` enum (e.g., `pending`, `accepted`, `rejected`).
- **Data Querying Approach**: To avoid slow `OR` queries (e.g., `where(user_id: user.id).or(where(friend_id: user.id)))`, we will use Rails associations creatively or store dual records (mutual friendships) when a request is accepted. The dual-record approach simplifies read operations at the cost of slight write overhead. We will use the dual-record approach for `accepted` friendships to make `user.friends` a simple `has_many` association.
- **API Structure**: We will use a dedicated `FriendshipsController` handling `POST /friendships` (create request), `PATCH /friendships/:id/accept`, `DELETE /friendships/:id`, and `GET /friendships` (list friends).

## Risks / Trade-offs

- [Risk] Dual-record synchronization could get out of sync if relationships are deleted manually. → **Mitigation**: Use Rails callbacks (`after_create`, `after_destroy`) and DB constraints to ensure both records are maintained together consistently.
