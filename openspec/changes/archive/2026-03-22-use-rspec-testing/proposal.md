# Proposal: Use RSpec for Testing

## Why

We current use Minitest, but we want to switch to RSpec to leverage its expressive DSL, rich ecosystem of extensions (like `shoulda-matchers`), and better alignment with modern Rails API testing patterns. This will improve developer productivity and test readability across the codebase.

## What Changes

- **Add RSpec dependencies**: Include `rspec-rails`, `factory_bot_rails`, `faker`, `shoulda-matchers`, `database_cleaner-active_record`, and `vcr`.
- **Initialize RSpec**: Run `rails generate rspec:install` and configure `spec_helper.rb` and `rails_helper.rb`.
- **Migrate existing tests**: Convert current Minitest files to RSpec equivalents.
- **Configure test environment**: Ensure factory bot and matchers are properly included in the test suite.
- **Update CI/scripts**: Point any test runners to `bundle exec rspec` instead of `bin/rails test`.

## Capabilities

### New Capabilities
- `testing-framework`: Configuration and patterns for RSpec testing suite.

### Modified Capabilities
- (None) - This is an infrastructure change focusing on implementation of tests.

## Impact

- **Test Suite**: Complete replacement of Minitest with RSpec.
- **Dependencies**: New gems added to `Gemfile`.
- **Developer Workflow**: Command for running tests changes to `rspec`.
- **Existing Tests**: `test/` directory will be deprecated/removed in favor of `spec/`.
