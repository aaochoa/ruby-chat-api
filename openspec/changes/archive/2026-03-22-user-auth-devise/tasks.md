# Implementation Tasks: User Authentication with Devise

## Phase 1: Setup & Configuration (Est: 1.5 hours)

### Task 1.1: Add Devise and JWT gems

- [x] Add devise and devise-jwt to Gemfile
- [x] Run bundle install
- [x] Run generator: `rails generate devise:install`
- [x] Verify Devise initializer created at config/initializers/devise.rb

### Task 1.2: Configure devise-jwt

- [x] Update Devise config to include :jwt strategies
- [x] Set JWT secret in config/initializers/devise.rb
- [x] Configure token expiration time (e.g., 24 hours)
- [x] Add JWT dispatch strategy to Devise config
- [x] Configure revocation/dispatch strategy

### Task 1.3: Configure CORS (if needed)

- [x] Add rack-cors gem if not present
- [x] Configure CORS middleware in config/initializers/cors.rb
- [x] Allow credentials and authorization header

## Phase 2: User Model (Est: 1 hour)

### Task 2.1: Generate User model with Devise

- [x] Run: `rails generate devise User`
- [x] Review generated migration
- [x] Add any additional fields if needed (optional for MVP)
- [x] Run `rails db:migrate`

### Task 2.2: Add User model validations

- [x] Open app/models/user.rb
- [x] Ensure Devise modules included: :database_authenticatable, :registerable, :validatable, :jwt_authenticatable
- [x] Add email validation (presence, uniqueness, format)
- [x] Add password validation (presence on create, length)
- [x] Add any custom validations

### Task 2.3: Add JWT configuration to User model

- [x] Configure jwt_payload method to include user id and email in token
- [x] Verify Devise JWT gem installed and configured properly

## Phase 3: Authentication Controller (Est: 1.5 hours)

### Task 3.1: Generate Authentication controller

- [x] Create app/controllers/api/v1/auth_controller.rb (or appropriate namespace)
- [x] Inherit from ApplicationController
- [x] Skip CSRF protection if needed (API endpoint)

### Task 3.2: Implement registration endpoint (POST /api/auth/register)

- [x] Create register action
- [x] Accept email, password, password_confirmation in request body
- [x] Use Devise to create user (User.create_with_password)
- [x] Handle validation errors (return 422)
- [x] Return user with JWT token on success (200)
- [x] Handle email conflict (return 409)

### Task 3.3: Implement login endpoint (POST /api/auth/login)

- [x] Create login action
- [x] Accept email and password
- [x] Use Devise.authenticate_user! or similar
- [x] Return user with JWT token on success (200)
- [x] Return 401 if credentials invalid
- [x] Return 404 if user not found (or generic 401 for security)

### Task 3.4: Implement profile endpoint (GET /api/auth/profile)

- [x] Create profile action
- [x] Require authentication (before_action :authenticate_user!)
- [x] Return current user with basic info
- [x] Return 401 if not authenticated

## Phase 4: Authentication Middleware & Routing (Est: 1 hour)

### Task 4.1: Set up authentication in ApplicationController

- [x] Add current_user method using Warden/JWT context
- [x] Add authenticate_user! method to check authentication
- [x] Add helper methods for checking authorization

### Task 4.2: Configure routes

- [x] Add API namespace routes (config/routes.rb)
- [x] POST /api/auth/register → auth#register
- [x] POST /api/auth/login → auth#login
- [x] GET /api/auth/profile → auth#profile (protected)

### Task 4.3: Add error handling middleware

- [x] Create custom JWT error handler
- [x] Handle invalid JWT (return 401)
- [x] Handle expired JWT (return 401)
- [x] Handle missing JWT (return 401)

## Phase 5: Serializers & Response Formatting (Est: 0.75 hours)

### Task 5.1: Create serializers

- [x] Create app/serializers/user_serializer.rb
- [x] Define fields to return: id, email, created_at
- [x] Create app/serializers/auth_response_serializer.rb
- [x] Define fields: user, token

### Task 5.2: Update controller responses

- [x] Update register action to use AuthenticationResponseSerializer
- [x] Update login action to use AuthenticationResponseSerializer
- [x] Update profile action to use UserSerializer
- [x] Ensure consistent JSON response format

## Phase 6: Testing (Est: 1.25 hours)

### Task 6.1: Unit tests for User model

- [x] Test user creation with valid attributes
- [x] Test validation failures (missing email, invalid password)
- [x] Test email uniqueness validation
- [x] Test password encryption

### Task 6.2: Request tests for authentication endpoints

- [x] Test POST /api/auth/register success (201)
- [x] Test POST /api/auth/register validation error (422)
- [x] Test POST /api/auth/register email conflict (409)
- [x] Test POST /api/auth/login success (200 with token)
- [x] Test POST /api/auth/login invalid credentials (401)
- [x] Test GET /api/auth/profile with valid token (200)
- [x] Test GET /api/auth/profile without token (401)
- [x] Test GET /api/auth/profile with invalid token (401)

### Task 6.3: Authentication flow integration tests

- [x] Register user → get token
- [x] Use token to access protected endpoint
- [x] Verify token expiration behavior
- [x] Test token refresh (if implemented)

## Phase 7: Documentation (Est: 0.5 hours)

### Task 7.1: API documentation

- [x] Document endpoints in README or API docs
- [x] Include request/response examples
- [x] Document authentication scheme (Bearer token)
- [x] Document error codes and messages

### Task 7.2: Deployment checklist

- [x] Verify JWT secret configured in production ENV
- [x] Set token expiration appropriate for production
- [x] Ensure HTTPS enforced in production
- [x] Document environment variables needed

## Summary

- **Total estimated effort**: 6-7 hours
- **Dependencies completed**: All phases sequential with minimal parallel work
- **Testing strategy**: Unit tests on models, request tests on controllers
- **Ready for**: OAuth integration, password reset, 2FA enhancements
