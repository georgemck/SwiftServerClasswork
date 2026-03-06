# 7.9 Test fetching a poll

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 9

## Adding the successful poll fetch test

This step demonstrates comprehensive API endpoint testing.

Open `APIHandlerTests.swift` and add the following test method to the `APIHandlerIntegrationTests` struct:

```swift
@Test("GET /api/polls/{pollId} returns specific poll when it exists")
func testGetPollDetailSuccess() async throws {
    try await TestHelpers.withApplication { application in
        let createRequest = Components.Schemas.CreatePollRequest(question: "Specific poll question?")

        // Create a poll first
        let createResponse = try await application.sendRequest(.POST, "/api/polls", body: createRequest)
        let createdPoll = try createResponse.content.decode(Components.Schemas.Poll.self)

        // Fetch the created poll by ID
        let response = try await application.sendRequest(.GET, "/api/polls/\(createdPoll.id)")

        #expect(response.status == .ok)
        #expect(response.headers.contentType == .json)

        let fetchedPoll = try response.content.decode(Components.Schemas.Poll.self)
        #expect(fetchedPoll.id == createdPoll.id)
        #expect(fetchedPoll.question == "Specific poll question?")
    }
}
```

## Adding the not-found test

In the same struct, add the following test method to verify proper error handling for non-existent polls:

```swift
@Test("GET /api/polls/{pollId} returns not found for non-existent poll")
func testGetPollDetailNotFound() async throws {
    try await TestHelpers.withApplication { application in
        // Request a poll that doesn't exist
        let response = try await application.sendRequest(.GET, "/api/polls/999")

        #expect(response.status == .notFound)
    }
}
```

## Understanding the test scenarios

These tests verify several behaviors:

- Existing polls can be fetched by their database ID.
- The returned poll data matches what was created.
- Proper HTTP 404 response for non-existent poll IDs.
- The poll ID from the URL is correctly processed.

## Test workflow

The success test follows this pattern:

1. Creates a poll with a POST request.
2. Decodes the response to get the generated poll ID.
3. Uses that ID to make a GET request for that specific poll.
4. Confirms the fetched poll matches the created poll.

## Running the tests

Execute `swift test --filter "testGetPollDetail"` to run both tests. The tests will fail because the current
`getPollDetail` implementation always returns HTTP 404 Not Found.

The next step implements the database lookup logic to make these tests pass.
