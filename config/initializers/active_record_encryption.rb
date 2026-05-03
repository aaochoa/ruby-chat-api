# frozen_string_literal: true

# Configure Active Record Encryption for message body encryption at rest.
# Keys are loaded from environment variables to keep them out of source control.
# In production, set these via your deployment secrets (e.g., Heroku config vars, AWS SSM).

Rails.application.config.active_record.encryption.primary_key         = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
Rails.application.config.active_record.encryption.deterministic_key   = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]
Rails.application.config.active_record.encryption.key_derivation_salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]

# Allow reading existing unencrypted data during transition.
# New writes will be encrypted; old plaintext rows remain readable.
# Once all rows are backfilled, this can be set to false.
Rails.application.config.active_record.encryption.support_unencrypted_data = true
