## ADDED Requirements

### Requirement: Message bodies are encrypted at rest
The system SHALL encrypt message body content before storing it in the database using AES-256-GCM encryption via Active Record Encryption. The system SHALL transparently decrypt message bodies when reading from the database. Encryption keys SHALL be configured via environment variables.

#### Scenario: New message is stored encrypted
- **WHEN** a user creates a new message with body content
- **THEN** the message body is stored as AES-256-GCM ciphertext in the database
- **AND** reading the message via the API returns the decrypted plaintext

#### Scenario: Existing plaintext messages remain readable
- **WHEN** the system reads a message that was stored before encryption was enabled
- **THEN** the plaintext body is returned without error

#### Scenario: Encryption keys are missing
- **WHEN** the application starts without the required encryption environment variables
- **THEN** the system fails to encrypt/decrypt and raises an appropriate error
