# Design: User Authentication with Devise

## Architecture Overview

```
┌──────────────┐
│ Client (Web) │
└──────┬───────┘
       │ HTTP/JSON
       ▼
┌──────────────────┐
│  Rails API App   │
├──────────────────┤
│ Authentication   │
│ Controller       │
│ (register/login) │
├──────────────────┤
│ User Model       │
│ (Devise)         │
├──────────────────┤
│ PostgreSQL DB    │
└──────────────────┘
```

## Component Design

### 1. User Model

- Devise-enabled model with JWT support
- Attributes: email, encrypted_password, created_at, updated_at
- Associations: (none for MVP)
- Validations: email uniqueness, presence, format
- Scopes: authenticate (verify JWT)

### 2. Authentication Controller

- **POST /api/auth/register** - Create new user account
  - Request: { email, password, password_confirmation }
  - Response: { id, email, token }
  - Errors: 422 (validation), 409 (conflict - email exists)

- **POST /api/auth/login** - Authenticate and get JWT
  - Request: { email, password }
  - Response: { id, email, token }
  - Errors: 401 (unauthorized), 404 (user not found)

- **GET /api/auth/profile** - Get current user (requires authentication)
  - Response: { id, email, created_at }
  - Errors: 401 (unauthorized), 404 (user not found)

### 3. Authentication Middleware

- JWT token verification
- Extract user from token
- Set current_user in request context
- Return 401 if token invalid/expired

### 4. Serializers

- UserSerializer: Present user data in JSON
- AuthenticationSerializer: Present token responses

## Technology Stack

- **Devise**: Authentication gem
- **devise-jwt**: JWT support for Devise
- **JWT**: Token creation and verification
- **PostgreSQL**: User data persistence
- **Rails 7+ API mode**: JSON-only API

## Security Considerations

- Passwords hashed with bcrypt (default Devise)
- JWT tokens with expiration (configurable TTL)
- HTTPS requirement in production
- Prevent timing attacks with constant-time comparison
- CORS configuration for frontend access

## Data Flow

### Registration Flow

1. Client sends email/password to POST /api/auth/register
2. Controller validates input
3. Controller creates User via Devise
4. JWT token generated automatically
5. Response sent with token
6. Client stores token in localStorage/sessionStorage

### Login Flow

1. Client sends email/password to POST /api/auth/login
2. Controller uses Devise.authenticate to verify
3. If valid, JWT token generated
4. Response sent with token
5. Client stores token

### Authenticated Request Flow

1. Client includes Authorization: Bearer <token> header
2. Middleware extracts and verifies JWT token
3. User loaded from token payload
4. Request allowed to proceed if valid
5. Returns 401 if token invalid/expired

## Dependencies

- Devise ~> 4.9
- devise-jwt ~> 0.13
- Rails ~> 7.0
- PostgreSQL adapter
