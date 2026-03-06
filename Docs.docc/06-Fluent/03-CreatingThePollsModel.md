# 6.3 Creating the Poll model

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 3

## Creating the Models file

Create a new file called `Models.swift` in the `Sources/PollsApp` directory. This file will contain all database
models for the application.

```swift
import Fluent
import Foundation

enum Models {
    final class Poll: Model, @unchecked Sendable {
        static let schema = "polls"

        @ID(custom: "id", generatedBy: .database)
        var id: Int32?

        @Field(key: "question")
        var question: String

        @Timestamp(key: "inserted_at", on: .create)
        var insertedAt: Date?

        @Timestamp(key: "updated_at", on: .update)
        var updatedAt: Date?

        init() { }

        init(question: String) {
            self.question = question
        }
    }
}
```

## Understanding the Poll model

The `Poll` model uses several Fluent property wrappers:

- `@ID(custom: "id", generatedBy: .database)` creates an auto-incrementing primary key using `Int32` to match the OpenAPI
  specification.
- `@Field(key: "question")` maps the `question` property to the database column.
- `@Timestamp(key: "inserted_at", on: .create)` automatically sets the timestamp when creating records.
- `@Timestamp(key: "updated_at", on: .update)` automatically updates the timestamp when modifying records.

## Why use @unchecked Sendable?

Fluent models must implement `@unchecked Sendable` because:

- Database models are shared across concurrent operations.
- Fluent property wrappers are not inherently `Sendable`.
- The `@unchecked` annotation tells Swift that you guarantee thread-safe usage.
- Fluent manages concurrency internally, making this safe when you use proper Fluent APIs.

The model schema matches the OpenAPI specification, ensuring consistency between the API contract and database structure.

The next step creates the database migration to set up the polls table.
