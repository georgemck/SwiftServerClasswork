# 7.10 Implement poll fetching

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 10

## Updating the getPollDetail method

Modify the `getPollDetail` method in `APIHandler.swift` to query for specific polls:

```swift
func getPoll(_ input: Operations.GetPoll.Input) async throws -> Operations.GetPoll.Output {
  do {
    let pollId = input.path.id

    // Find the poll by ID in the database
    guard let poll = try await Models.Poll.find(Int32(pollId), on: database) else {
      let notFoundResponse = Components.Schemas.NotFoundError(
        error: true,
        reason: "A poll with id \(pollId) does not exist"
      )
      return .notFound(.init(body: .json(notFoundResponse)))
    }

    // Convert database model to API response format
    let pollResponse = Components.Schemas.Poll(
      id: Int(poll.id!),
      question: poll.question,
    )

    return .ok(.init(body: .json(pollResponse)))
  } catch {
    throw error
  }
}
```

Now run `swift test` and see the tests pass.

## Understanding the implementation

The updated implementation extracts the poll ID from the URL path parameter and converts the ID type by casting from `Int`
(the URL parameter format) to `Int32` (the database type). Using Fluent's `find()` method, it performs an efficient lookup
by primary key. When no poll exists with that ID, it returns HTTP 404. The method maps the database model to OpenAPI schema
format and provides HTTP 200 OK with the poll data.

## Fluent find operation

The `find()` method provides primary key lookup where `Models.Poll.find(Int32(pollId), on: database)` searches by primary
key. It returns an optional result that contains nil if not found, offering more efficiency than general queries for single
record retrieval.

## Guard statement pattern

The guard statement provides clean error handling by unwrapping the optional poll result. It returns early with HTTP
404 if no poll is found and continues with the unwrapped poll if it exists.

## Running the tests

Execute `swift test --filter "testGetPollDetail"` to verify that both tests now pass. The implementation returns the
correct poll data when a valid ID is provided and returns HTTP 404 Not Found when the poll ID does not exist. It handles
the URL parameter extraction and type conversion correctly.

## Completing Create and Read operations

Complete CRUD functionality for polls now includes POST /api/polls to create new polls with duplicate detection. The GET
/api/polls endpoint lists all polls, and GET /api/polls/{id} fetches specific polls by ID.
