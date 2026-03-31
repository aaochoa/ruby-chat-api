## ADDED Requirements

### Requirement: User has first and last names
The system SHALL support storing and retrieving a user's first name and last name. These fields SHOULD be optional but are recommended for better searchability.

#### Scenario: Update user names
- **WHEN** a user updates their profile with a first name "John" and last name "Doe"
- **THEN** the system stores these values and returns them in subsequent profile requests

### Requirement: Profile includes real names
The user profile API response SHALL include `first_name` and `last_name` fields.

#### Scenario: Retrieve profile with names
- **WHEN** a client requests the profile of a user who has names set
- **THEN** the response includes the `first_name` and `last_name` in the JSON payload
