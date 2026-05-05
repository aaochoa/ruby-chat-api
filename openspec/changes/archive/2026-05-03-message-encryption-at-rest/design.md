## Context

The ruby-chat-api stores message content in the `messages.body` column as plain `text` in PostgreSQL. Authentication uses JWT (Devise + devise-jwt), transport is encrypted via HTTPS/WSS, but data at rest is unprotected. The primary threat model is database leaks — stolen backups, unauthorized DB access, or SQL injection exposing raw message content.

## Goals / Non-Goals

**Goals:**
- Encrypt message bodies at rest so raw database access doesn't expose plaintext content
- Zero frontend changes — encryption/decryption is transparent at the model layer
- Support reading existing plaintext messages during the migration period
- Use environment variables for key management (matching existing project conventions)

**Non-Goals:**
- End-to-end encryption (client-side) — the server remains trusted
- Encrypting media attachments (ActiveStorage blobs) — future enhancement
- Encrypting other model fields (conversation titles, user names)
- Deterministic encryption for search — plaintext search will be handled via a dedicated search index later

## Decisions

### 1. Rails Active Record Encryption

**Choice**: Use Rails' built-in `encrypts` directive with AES-256-GCM (non-deterministic mode).

**Why**: Ships with Rails 8, requires no additional dependencies, and integrates transparently with the existing model/serializer/controller stack. Non-deterministic mode provides stronger security (same plaintext produces different ciphertext each time).

**Alternative considered**: Application-level encryption with `attr_encrypted` gem or manual OpenSSL usage. Rejected because Active Record Encryption is the Rails-native solution with better lifecycle management, key rotation support, and zero additional dependencies.

### 2. Environment variable key management

**Choice**: Configure encryption keys via `ENV` vars in an initializer, rather than Rails credentials.

**Why**: The project already uses `.env` for secrets (e.g., `DEVISE_JWT_SECRET_KEY`). Keeping keys in the same mechanism is consistent and avoids requiring `master.key` management.

### 3. Support unencrypted data during transition

**Choice**: Set `support_unencrypted_data = true` so existing plaintext rows remain readable alongside newly encrypted rows.

**Why**: Avoids a breaking migration. Existing messages continue to work; new messages are encrypted. After an optional backfill (`Message.find_each { |m| m.encrypt }`), this flag can be disabled.

## Risks / Trade-offs

- **[Server trust]** → The server can decrypt all messages. This is acceptable for the team chat threat model (protecting against DB leaks, not server compromise).
- **[Key management]** → Losing the encryption keys means losing access to encrypted messages. Mitigation: document key backup procedures for production.
- **[No search on encrypted data]** → Non-deterministic encryption means `WHERE body LIKE '%term%'` won't work. Mitigation: planned search index (Elasticsearch or similar) will handle full-text search at the application layer.
- **[Backfill required]** → Existing messages remain plaintext until explicitly backfilled. Mitigation: `support_unencrypted_data = true` handles the mixed state gracefully.
