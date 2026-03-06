# 7.6 Duplicate question error-handling

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 6

## Updating the createPoll method

Modify the `createPoll` method in `APIHandler.swift` to check for existing polls before creation:

```swift
func createPoll(_ input: Operations.CreatePoll.Input) async throws -> Operations.CreatePoll.Output {
    do {
        switch input.body {
        case .json(let createRequest):

            // Check for existing poll with the same question
            if try await Models.Poll.query(on: database)
                .filter(\.$question == createRequest.question)
                .first() != nil
            {
                let conflictResponse = Components.Schemas.ConflictError(
                    error: true,
                    reason: "A poll with the question '\(createRequest.question)' already exists"
                )
                return .conflict(.init(body: .json(conflictResponse)))
            }

            // Create new poll model
            let newPoll = Models.Poll()
            newPoll.question = createRequest.question
            newPoll.updatedAt = Date()

            // Save to database
            try await newPoll.save(on: database)

            // Convert to API response format
            let pollResponse = Components.Schemas.Poll(
                id: Int(newPoll.id!),
                question: newPoll.question,
            )

            return .created(.init(body: .json(pollResponse)))
        }
    } catch {
        throw error
    }
}
```

Now run `swift test` again and see the tests pass.

## Understanding the duplicate detection

The updated implementation performs several operations:

- Queries existing polls using Fluent's query builder to search for polls with matching questions.
- The `filter(\.$question == createRequest.question)` checks for exact matches.
- The `first()` method returns the first matching poll or nil.
- If a match exists, the method returns HTTP 409 with a descriptive error message.
- If no duplicate exists, it proceeds with normal poll creation.

## Fluent query syntax

The query uses Fluent's type-safe syntax:

- `Models.Poll.query(on: database)` starts a query on the polls table.
- `filter(\.$question == createRequest.question)` adds a WHERE clause for precise matching.
- `first()` returns an optional result that contains nil if no match is found.

## Running the test

Execute `swift test` to verify that the test now passes. The implementation detects the duplicate question from the first
poll creation and returns HTTP 409 Conflict for the second attempt. It provides a meaningful error message in the
response.

The test validates that the API properly enforces the database uniqueness constraint at the application level, providing
clear feedback to API consumers about conflict conditions.

The next step adds tests for listing polls to verify that the read functionality works correctly.
