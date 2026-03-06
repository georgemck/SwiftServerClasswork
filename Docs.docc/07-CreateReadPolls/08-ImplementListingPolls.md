# 7.8 Implement listing polls

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 8

## Updating the listPolls method

Modify the `listPolls` method in `APIHandler.swift` to query the database:

```swift
func listPolls(_ input: Operations.ListPolls.Input) async throws -> Operations.ListPolls.Output {
    do {
        // Query all polls from the database
        let polls = try await Models.Poll.query(on: database).all()

        // Convert database models to API response format
        let pollComponents = polls.map { poll in
            Components.Schemas.Poll(
                id: Int(poll.id!),
                question: poll.question,

            )
        }

        // Create paginated response
        let pageOfPolls = Components.Schemas.PageOfPolls(polls: pollComponents)

        return .ok(.init(body: .json(pageOfPolls)))
    } catch {
        throw error
    }
}
```

## Understanding the implementation

The updated implementation queries all polls using `Models.Poll.query(on: database).all()` to retrieve every poll from the
database. It transforms database models to OpenAPI schema objects using the `map` operation, which naturally handles empty
arrays. The method wraps results in the expected `PageOfPolls` structure and provides HTTP 200 OK with the poll data.

## Fluent query operations

The query uses Fluent's simple syntax where `Models.Poll.query(on: database)` starts a query on the polls table. The
`.all()` method returns all records, equivalent to `SELECT * FROM polls`. The result is an array that may be empty if no
polls exist.

## Data transformation

The `map` operation converts each `Models.Poll` to `Components.Schemas.Poll` by casting the `Int32` database ID to `Int`
for the API response. The `question` field maps directly between formats.

## Running the tests

Execute `swift test --filter "testListPolls"` to verify that both listing tests now pass. The implementation returns an
empty array when no polls exist and returns all created polls when data exists. It maintains proper response format and
content type throughout.

The tests confirm that the API correctly handles both empty and populated database states.

The next step adds tests for fetching individual polls by ID.
