## ADDED Requirements

### Requirement: Friend Request Creation
The system SHALL allow an authenticated user to send a friend request to another registered user.

#### Scenario: Valid friend request
- **WHEN** an authenticated user creates a friendship with another user's ID
- **THEN** the system creates a pending friendship record and returns it

#### Scenario: Duplicate friend request
- **WHEN** a user requests a friendship with someone they already requested or are friends with
- **THEN** the system returns a validation error

### Requirement: Accept Friend Request
The system SHALL allow a user to accept a pending friend request directed at them.

#### Scenario: Successful acceptance
- **WHEN** a user accepts a pending friendship where they are the target
- **THEN** the system updates the friendship status to accepted and establishes the mutual connection

### Requirement: List accepted friends
The system SHALL allow a user to retrieve a list of their accepted friends.

#### Scenario: Fetching friends list
- **WHEN** a user requests their friends list
- **THEN** the system returns a serialized list of users with "accepted" friendship status

### Requirement: Remove or Reject Friend
The system SHALL allow a user to reject a pending request or remove an existing friend.

#### Scenario: Removing a friend
- **WHEN** a user deletes an existing friendship
- **THEN** the system removes the connection entirely for both users
