# Conversations CRUD

## Purpose
This capability handles the basic CRUD (Create, Read, Update, Delete) operations for conversations associated with a user.

## Requirements

### Requirement: CRUD operations for Conversations
A User can create, read, update, and delete their own conversations.

#### Scenario: List of conversations
- **WHEN** I request the index of conversations
- **THEN** It should return a list of conversations for the current user

#### Scenario: Create a conversation
- **WHEN** I create a new conversation with a title
- **THEN** It should save the conversation and associate it with the current user

#### Scenario: Read a conversation
- **WHEN** I request a specific conversation by ID
- **THEN** It should return the details of that conversation

#### Scenario: Update a conversation
- **WHEN** I update the title of a conversation
- **THEN** The conversation should be updated in the database

#### Scenario: Delete a conversation
- **WHEN** I delete a conversation
- **THEN** It should be removed from the database

### Requirement: Conversations List with Messages
The system SHALL optionally include the latest message or a list of messages when retrieving a conversation to provide context for the user.

#### Scenario: Retrieval with messages
- **WHEN** a user requests a conversation and includes the `messages` parameter
- **THEN** the system SHALL return the conversation details along with its associated messages

