## ADDED Requirements

### Requirement: Developer can populate database with rich development data
The system SHALL provide a seeding mechanism that populates the database with users, friendships, and conversations when `rake db:seed` is run in development.

#### Scenario: Running db seed in development
- **WHEN** user runs `rake db:seed` in the `development` environment
- **THEN** the system clears the existing records (Users, Friendships, Conversations, Messages) safely
- **THEN** the system generates at least 20 User records
- **THEN** the system creates friendship relations among subset of users
- **THEN** the system creates conversation threads with messages among some of the friends
