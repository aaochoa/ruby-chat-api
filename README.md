# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database initialization

## Testing

This project uses RSpec. To run the full suite:

```bash
bundle exec rspec
```

To run individual tests:

```bash
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/requests/api/v1/auth_spec.rb
```

## API Authentication endpoints

This application uses Devise + JWT for stateless API authentication.

### Authentication Scheme
Use Bearer token in the header of authenticated requests: `Authorization: Bearer <your_jwt_token>`

### Endpoints

- **POST /api/v1/auth/register**
  - Parameters: `{ "email": "user@example.com", "password": "...", "password_confirmation": "..." }`
  - Success Response: 201 Created with `{ "user": { ... }, "token": "..." }`
  
- **POST /api/v1/auth/login**
  - Parameters: `{ "email": "user@example.com", "password": "..." }`
  - Success Response: 200 OK with `{ "user": { ... }, "token": "..." }`

- **GET /api/v1/auth/profile**
  - Headers: `Authorization: Bearer <token>`
  - Success Response: 200 OK with `{ "id": 1, "email": "user@example.com", "created_at": "..." }`

### Error Codes
- 401 Unauthorized: Invalid, expired, or missing JWT, or invalid login credentials.
- 409 Conflict: Email already taken during registration.
- 422 Unprocessable Entity: Validation error during registration.

### Deployment Checklist
- [ ] Set `DEVISE_JWT_SECRET_KEY` in production environment.
- [ ] Ensure HTTPS is enforced in production.
