# 8.4 Write code to delete a Poll

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 4

## Adding the deletePoll method

Add this method to your `APIHandler` struct in `APIHandler.swift`, then run `swift test` to see the passing tests.

```swift
func deletePoll(_ input: Operations.DeletePoll.Input) async throws -> Operations.DeletePoll.Output {
    do {
        let pollId = input.path.pollId

        // Find the existing poll
        guard let existingPoll = try await Models.Poll.find(Int32(pollId), on: database) else {
            return .notFound(.init())
        }

        // Delete the poll from the database
        try await existingPoll.delete(on: database)

        return .noContent(.init())
    } catch {
        throw error
    }
}
```

## Understanding the implementation

The `deletePoll` method implements straightforward deletion logic:

- Extracts the poll ID from the URL path parameter.
- Uses Fluent's `find()` to locate the poll to delete.
- Returns HTTP 404 when the poll does not exist.
- Uses Fluent's `delete()` method to remove the poll from the database.
- Provides HTTP 204 No Content indicating successful deletion.

## Fluent deletion operations

The deletion uses Fluent's simple model methods:

- `find()` locates the poll by primary key.
- `delete(on: database)` removes the model from the database.
- The operation is atomic and handles referential integrity.

## HTTP 204 No Content response

DELETE operations typically return HTTP 204 No Content to indicate successful deletion:

- No response body is needed.
- This distinguishes the response from HTTP 200 that would include response data.

## Error handling patterns

The method follows established patterns:

- Uses a guard statement for existence checking.
- Returns early with appropriate error codes.
- Maintains consistent error propagation with `try/catch`.

## Running the tests

Execute `swift test --filter "testDeletePoll"` to verify that all deletion tests now pass. The implementation successfully
deletes existing polls and returns HTTP 204. It returns HTTP 404 for non-existent poll IDs and actually removes polls from
the database as verified by subsequent queries. The method maintains database integrity after deletion.

## Complete CRUD implementation

Full CRUD functionality for the polls API now includes POST /api/polls to create new polls with validation. The GET
/api/polls endpoint lists all polls, and GET /api/polls/{id} fetches specific polls. PATCH /api/polls/{id} modifies
existing polls with validation, and DELETE /api/polls/{id} removes polls. The API provides comprehensive poll management
with proper HTTP semantics, error handling, and data validation throughout all operations.
