# 6.4 Creating the migration

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 4

## Creating the Migrations file

Create a new file called `Migrations.swift` in the `Sources/PollsApp` directory:

```swift
import Fluent

enum Migrations {
    struct CreatePolls: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Models.Poll.schema)
                .field("id", .int32, .identifier(auto: true))
                .field("question", .string, .required)
                .field("inserted_at", .datetime)
                .field("updated_at", .datetime)
                .unique(on: "question")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(Models.Poll.schema)
                .delete()
        }
    }
}
```

## Understanding the migration

The `CreatePolls` migration defines the database schema:

- `field("id", .int32, .identifier(auto: true))` creates an auto-incrementing primary key.
- `field("question", .string, .required)` creates a required string column for poll questions.
- `field("inserted_at", .datetime)` and `field("updated_at", .datetime)` create timestamp columns.
- `unique(on: "question")` ensures no duplicate poll questions can exist.
- The `revert()` method allows rolling back the migration by dropping the table.

## What is a uniqueness constraint?

A uniqueness constraint prevents duplicate values in specified database columns. In this case:

1. It ensures no two polls can have identical questions.
2. The database rejects attempts to insert duplicate questions.
3. This maintains data integrity at the database level.
4. The constraint supports the API conflict-handling logic.

## Registering the migration

Update the `Database.swift` file to include the migration in the `configureDatabase` function:

1. Find the comment that says "Migrations will be added here".
2. Replace it with the `Migrations.CreatePolls()` call shown below.
3. Add the `autoMigrate()` call so that the migrations are executed.

```swift
application.migrations.add([
    Migrations.CreatePolls()
])
try await application.autoMigrate()
```

Run `swift build` to verify that the migration compiles correctly. When you start the application, Fluent automatically
creates the polls table with the defined schema and constraints.

The next section implements Create and Read operations for polls using test-driven development.
