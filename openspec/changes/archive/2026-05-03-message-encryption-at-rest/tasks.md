## 1. Encryption Configuration

- [x] 1.1 Generate Active Record Encryption keys (primary_key, deterministic_key, key_derivation_salt)
- [x] 1.2 Add encryption keys to `.env` for local development
- [x] 1.3 Create `config/initializers/active_record_encryption.rb` to load keys from environment variables
- [x] 1.4 Enable `support_unencrypted_data = true` for backward compatibility with existing plaintext rows
- [x] 1.5 Update `.env.example` with placeholder entries for the encryption keys

## 2. Model Encryption

- [x] 2.1 Add `encrypts :body` to the `Message` model (non-deterministic AES-256-GCM)
- [x] 2.2 Verify existing plaintext messages remain readable
- [x] 2.3 Verify new messages are stored encrypted in the database
- [x] 2.4 Verify decryption is transparent via `MessageSerializer`

## 3. Test Fixes & Verification

- [x] 3.1 Fix test assertions to match serializer camelCase keys (`name`, `userId`, `content`)
- [x] 3.2 Run full test suite — 82 examples, 0 failures
