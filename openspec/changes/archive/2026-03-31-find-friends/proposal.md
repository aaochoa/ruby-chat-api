## Why

Currently, users can only be identified by their email address, which makes it difficult for people to find each other in the chat. By adding real names and a search functionality, users can easily discover and connect with friends, enhancing the social aspect of the application.

## What Changes

- **User Model**: Add `first_name` and `last_name` attributes (string, optional).
- **Search API**: Introduce a new search endpoint that allows finding users by email or full name (case-insensitive).
- **Befriending**: Create a way for users to request friendship with another user and accept it. (If `friendships` already exists, make sure the flow is complete).
- **User Profile API**: Update profile response to include first and last name.

## Capabilities

### New Capabilities
- `user-profile`: Profile details including real names and searchability.
- `friend-discovery`: Endpoint and logic to find users to befriend.

### Modified Capabilities
- (No existing spec-level capabilities to modify)

## Impact

- **Database**: New columns `first_name` and `last_name` for `users`.
- **API**: New endpoints for searching and managing friendships.
- **Service Layer**: Search logic for multi-field user lookup.
