# Design: Use RSpec for Testing

## Context

The current project uses Rails' default Minitest. While functional, RSpec is the preferred testing framework for this team as it offers more expressive syntax and is better suited for the API-driven development we are doing. We've already implemented a initial JWT authentication system, and migrating those tests to RSpec is a priority.

## Goals / Non-Goals

**Goals:**
- Transition codebase from Minitest to RSpec.
- Establish a clean, scalable testing directory structure (`spec/`).
- Standardize on `FactoryBot` for test data.
- Ensure 1:1 coverage parity for all existing model and controller logic.

**Non-Goals:**
- Adding new feature tests beyond what currently exists in Minitest.
- Refactoring the application logic itself during the migration.

## Decisions

### 1. Test Data Management: FactoryBot
- **Decision**: Use `FactoryBot` instead of YAML fixtures.
- **Rationale**: Factories are more maintainable for complex associations and allow for dynamic data generation in APIs.

### 2. Request Specs vs. Controller Specs
- **Decision**: Use Request Specs over the deprecated Controller Specs pattern.
- **Rationale**: Request specs better simulate real API calls and handle cross-cutting concerns like JWT middleware more accurately.

### 3. Matchers: Shoulda Matchers
- **Decision**: Integrate `shoulda-matchers` for concise model validation and association testing.
- **Rationale**: Reduces boilerplate code in specs and makes model tests highly readable (e.g., `it { is_expected.to validate_presence_of(:email) }`).

## Risks / Trade-offs

- **[Risk] Test results mismatch** → **Mitigation**: Run both suites side-by-side during the transition to ensure identical behavior before deleting `test/`.
- **[Trade-off] Performance** → RSpec can be slightly slower than Minitest due to its heavy DSL and metadata overhead, but the improvement in developer experience outweighs the sub-second speed difference for this project's scale.
