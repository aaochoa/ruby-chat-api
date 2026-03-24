## 1. Database and Models

- [x] 1.1 Install Active Storage: `bin/rails active_storage:install`
- [x] 1.2 Create `Message` model with `body:text`, `conversation_id:bigint`, `sender_id:bigint`
- [x] 1.3 Create `MessageRecipient` join table with `message_id:bigint`, `user_id:bigint`
- [x] 1.4 Update `Message` model: `belongs_to :conversation`, `belongs_to :sender, class_name: 'User'`, `has_many :message_recipients`, `has_many :receivers, through: :message_recipients, source: :user`, `has_one_attached :media`
- [x] 1.5 Update `User` model: `has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id`
- [x] 1.6 Update `Conversation` model: `has_many :messages, dependent: :destroy`
- [x] 1.7 Run database migrations: `bin/rails db:migrate`

## 2. API Implementation

- [x] 2.1 Update routes to nest messages under conversations: `resources :conversations do resources :messages, only: [:index, :create, :show] end`
- [x] 2.2 Create `Api::V1::MessagesController` with `index`, `create`, and `show` actions
- [x] 2.3 Implement `create` action: Ensure sender is `current_user`, handle text/media, and create `MessageRecipient` records
- [x] 2.4 Implement `index` action: List messages for a conversation, ordered by `created_at`
- [x] 2.5 Implement `show` action: Return single message details including media attachment link
- [x] 2.6 Update `Api::V1::ConversationsController#show` to include latest messages if requested

## 3. Testing and Verification

- [x] 3.1 Write unit tests for `Message` and `MessageRecipient` models
- [x] 3.2 Write request tests for `Api::V1::MessagesController`
- [x] 3.3 Verify media attachment upload and retrieval
- [x] 3.4 Verify multi-recipient support in `Message` model
