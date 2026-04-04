# CLAUDE.md - Project Rules for ruby-chat-api

## Project Overview

This is a Ruby on Rails API application. All responses are JSON-only.

## Architecture & Conventions

### Controllers

- Each controller handles one domain/resource with RESTful routes
- Keep controllers skinny — move business logic to services, models, or decorators
- Namespace under `Api::V1::` with plural resource names (e.g., `Api::V1::UsersController`)
- Use `before_action :authenticate_user!` for auth
- Always use strong parameters: `params.require(:resource).permit(:attr1, :attr2)`
- Validate in models; check authorization/access in controllers only

### Response Format

Use a consistent response structure:

```ruby
{ data: { ... }, meta: { }, errors: [ ] }
```

- `200 OK` for GET/PUT/PATCH with `{ data: ..., meta: ... }`
- `201 Created` for POST with `render json: @resource, status: :created, location: @resource`
- `204 No Content` for DELETE with `head :no_content`
- Error responses use `{ errors: [{ field: "...", message: "..." }] }` for validation, `{ error: "...", code: "..." }` for operational errors

### HTTP Error Codes

- 400 Bad Request — malformed params
- 401 Unauthorized — missing/invalid credentials
- 403 Forbidden — authenticated but not authorized
- 404 Not Found — resource doesn't exist
- 422 Unprocessable Entity — validation failed
- 500 Internal Server Error — never expose details

### Error Handling

- Use `rescue_from` in base controller for `ActiveRecord::RecordNotFound`, `Pundit::NotAuthorizedError`, and `StandardError`
- Never expose stack traces, secrets, or internal structure in error messages
- Use generic messages: "Invalid credentials" not "User not found"
- Log errors to Sentry, don't log sensitive data

### Authentication

- Bearer tokens via `Authorization: Bearer <token>` header
- JWT-based authentication
- Always scope queries to current user — never return unscoped data

### Pagination

- Default 25-50 items per page
- Always paginate large collections (cap at 100 max)
- Include pagination metadata: `page`, `per_page`, `total_pages`, `total_count`
- Support filtering via query params and sorting via `sort` param

## Models

- Validations: use `validates` with multiple validators (presence, format, uniqueness, length)
- Named scopes for common queries (chainable)
- Associations with proper foreign keys and `dependent: :destroy` where needed
- Keep callbacks minimal — prefer service objects for complex logic
- Use modern PostgreSQL types (JSONB, arrays) when appropriate

### Naming

- Model file: singular snake_case (`user.rb`)
- Class: singular CamelCase (`User`)
- Table: plural snake_case (`users`)
- Foreign key: `singular_id` (`user_id`)
- Boolean methods: `active?`, `verified?`

## Migrations

- Use `foreign_key: true` on references
- Add indexes on foreign keys and frequently filtered columns
- Use `null: false` for required fields
- Use appropriate types: `decimal` for money, `jsonb` for flexible data

## Service Objects

- Encapsulate complex business logic in `app/services/`
- Namespace by domain: `Users::CreateService`, `Orders::FulfillService`
- Single public method: `call`
- Always return a `Result` object (`Result.success(data)` / `Result.failure(errors)`)
- Wrap multi-step operations in `ActiveRecord::Base.transaction`
- One service = one operation (single responsibility)

### File Structure

```
app/services/
  users/
    create_service.rb
    authenticate_service.rb
  orders/
    create_service.rb
    fulfill_service.rb
```

## Serializers

- Use `ActiveModel::Serializer` or JSONAPI serializer
- Never serialize passwords, tokens, or API keys
- Use `scope` (current_user) for permission-based conditional attributes
- Eager load associations in controllers to prevent N+1
- File naming: `user_serializer.rb` in `app/serializers/`

## Testing

- Use RSpec with FactoryBot and Faker
- Use `shoulda-matchers` for model validations/associations
- Use VCR + WebMock for external API mocking
- Use transactional fixtures
- Factories over fixtures

### Test Organization

- One spec file per model/controller/service
- `describe` blocks for methods/endpoints
- `context` blocks for conditions
- `it` blocks for single assertions
- Test both success AND failure paths
- Test authorization and authentication
- Use shared examples for common behaviors (e.g., `requires authentication`)

### Coverage Targets

- Models: 90%+
- Controllers: 85%+
- Services: 90%+

## Security

- Force SSL in production: `config.force_ssl = true`
- Configure CORS properly — never use `*` in production
- Implement rate limiting with `Rack::Attack`
- Use parameterized queries (Rails default) — never build SQL strings
- Never hardcode secrets — use environment variables

## Performance

- Eager load associations (`includes`, `eager_load`) to prevent N+1
- Use `bullet` gem in development for N+1 detection
- Select only needed columns for large result sets
- Use transactions for multi-step operations
- Move slow operations to background jobs (Sidekiq)
- Cache serialized responses with Redis when appropriate

## File Structure

```
app/controllers/api/v1/   # API controllers
app/models/                # Models
app/serializers/           # Serializers
app/services/              # Service objects
spec/                      # Tests
```

## Git Conventions

- Commit message format: `[Type] Description` (under 50 chars)
- Types: API, Fix, Feature, Refactor, Deps, Docs, Test, Perf
- Branch naming: `feature/description`, `fix/description`
- Reference tickets: `Fixes #123`, `Related to #456`
