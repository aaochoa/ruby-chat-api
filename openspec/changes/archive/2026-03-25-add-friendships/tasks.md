## 1. Database Schema

- [x] 1.1 Generate `Friendship` model with `user_id` (integer), `friend_id` (integer), and `status` (integer/enum)
- [x] 1.2 Update migration to add foreign keys, null constraints, and a unique composite index on `[user_id, friend_id]`
- [x] 1.3 Run database migrations

## 2. Models & Associations

- [x] 2.1 Update `Friendship` model: add `belongs_to :user` and `belongs_to :friend, class_name: 'User'`
- [x] 2.2 Update `Friendship` model: add `status` enum (`pending`, `accepted`, `rejected`)
- [x] 2.3 Update `Friendship` model: add callback logic for creating/destroying the mirror dual-record when status changes to/from `accepted`
- [x] 2.4 Update `User` model: add `has_many :friendships` and `has_many :friends, through: :friendships, source: :friend`

## 3. Controllers & Routes

- [x] 3.1 Update `config/routes.rb` to add nested or top-level resources for `friendships` (`create`, `update`, `destroy`, `index`)
- [x] 3.2 Create `FriendshipsController`
- [x] 3.3 Implement `#create` action to send a friend request (status `pending`)
- [x] 3.4 Implement `#update` action to accept a friend request (status `accepted`)
- [x] 3.5 Implement `#destroy` action to reject/remove a friend relationship
- [x] 3.6 Implement `#index` action to list accepted friends of the current user

## 4. Testing

- [x] 4.1 Write unit tests for `Friendship` model validations and callbacks
- [x] 4.2 Write request specs for `FriendshipsController` actions
