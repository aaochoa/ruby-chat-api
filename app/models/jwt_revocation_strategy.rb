class JwtRevocationStrategy
  def self.jwt_revoked?(payload, user)
    # For now, we allow all tokens. In production, you might:
    # - Check against a blacklist
    # - Verify expiration time
    # - Store allowed tokens in Redis
    false
  end

  def self.revoke_jwt(payload, user)
    # You could implement token blacklisting here
    # E.g., add the token to a Redis set with expiration
  end
end
