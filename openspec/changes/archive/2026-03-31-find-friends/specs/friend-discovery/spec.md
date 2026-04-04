## ADDED Requirements

### Requirement: Search users by name or email

The system SHALL provide a search endpoint that takes a name or partial email and returns a list of matching users who are NOT already friends with the current user.

#### Scenario: Search by name excluding existing friends

- **WHEN** user A (who is friends with user C) searches for "John"
- **THEN** system returns all users with "John" in their first or last name except user C

#### Scenario: Search by email excluding existing friends

- **WHEN** user A (who is friends with user B) searches for user B's email
- **THEN** system returns an empty list

### Requirement: Befriending another user

The system SHALL allow a user to add another user as a friend.

#### Scenario: Request friendship

- **WHEN** user A requests to befriend user B
- **THEN** a friendship record is created with a "pending" status (if applicable) or as an active friendship

### Requirement: Prevent duplicate befriending

The system SHALL NOT allow a user to befriend

#### Scenario: Second friendship request

- **WHEN** user A already has a friendship with user B and tries to add them again
- **THEN** the system returns an error message indicating the friendship already exists
