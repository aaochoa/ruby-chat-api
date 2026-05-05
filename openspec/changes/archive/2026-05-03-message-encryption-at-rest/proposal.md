## Why

Message bodies are currently stored as plaintext in PostgreSQL. If the database is compromised — via a backup leak, unauthorized access, or SQL injection — all message content is immediately readable. Adding encryption at rest ensures that even with raw database access, message content remains protected.

## What Changes

- Enable Rails Active Record Encryption on the `Message` model's `body` field (AES-256-GCM)
- Add an initializer to configure encryption keys from environment variables
- Support reading existing plaintext messages during the transition period
- Update `.env.example` with the required encryption environment variables

## Capabilities

### New Capabilities

- `message-encryption`: Server-side encryption of message bodies at rest using AES-256-GCM via Active Record Encryption

### Modified Capabilities

<!-- No existing capabilities are modified. Serializers, controllers, and ActionCable channels remain unchanged — decryption is transparent. -->

## Impact

- **Code**: One-line model change (`encrypts :body`) and a new initializer file
- **Dependencies**: None — Active Record Encryption ships with Rails 8
- **APIs**: No changes — decryption is transparent at the model layer
- **Infrastructure**: Three new environment variables required for encryption keys
- **Data Migration**: Existing plaintext messages remain readable; new messages are encrypted. Optional backfill via `Message.find_each { |m| m.encrypt }`
