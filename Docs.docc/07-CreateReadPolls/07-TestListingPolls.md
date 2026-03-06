# 7.7 Test listing polls

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 7

## Adding the empty list test

This step demonstrates comprehensive API testing practices.

Open the `APIHandlerTests.swift` file and add the following test method to the `APIHandlerIntegrationTests` struct:

```swift
@Test("GET /api/polls returns empty list when no polls exist")
func testListPollsEmpty() async throws {
    try await TestHelpers.withApplication { application in
        let response = try await application.sendRequest(.GET, "/api/polls")

        #expect(response.status == .ok)
        #expect(response.headers.contentType == .json)

        let pageOfPolls = try response.content.decode(Components.Schemas.PageOfPolls.self)
        #expect(pageOfPolls.polls.isEmpty)
    }
}
```

## Adding populated list test

In the same struct, add the following test method to verify the listing of existing polls:

```swift
@Test("GET /api/polls returns list of polls when polls exist")
func testListPollsWithData() async throws {
    try await TestHelpers.withApplication { application in
        let poll1 = Components.Schemas.CreatePollRequest(question: "First poll question?")
        let poll2 = Components.Schemas.CreatePollRequest(question: "Second poll question?")

        // Create two polls
        _ = try await application.sendRequest(.POST, "/api/polls", body: poll1)
        _ = try await application.sendRequest(.POST, "/api/polls", body: poll2)

        // List polls
        let response = try await application.sendRequest(.GET, "/api/polls")

        #expect(response.status == .ok)
        #expect(response.headers.contentType == .json)

        let pageOfPolls = try response.content.decode(Components.Schemas.PageOfPolls.self)
        #expect(pageOfPolls.polls.count == 2)

        let questions = pageOfPolls.polls.map { $0.question }
        #expect(questions.contains("First poll question?"))
        #expect(questions.contains("Second poll question?"))
    }
}
```

Now run `swift test` and confirm the second one fails.

## Understanding the test scenarios

These tests verify several behaviors:

- The API returns an empty array when no polls exist in the database.
- Created polls appear in the list response with correct data.
- Poll questions are returned correctly.
- Proper HTTP status and content type for all responses.

## Test structure

Both tests follow the same pattern:

1. Create the application with a clean database.
2. Perform a GET request to `/api/polls`.
3. Verify the response status, format, and content match expectations.

## Running the tests

Execute `swift test --filter "testListPolls"` to run both listing tests. The tests will fail because the current
`listPolls` implementation returns an empty array regardless of database contents.

The next step implements the database query logic to make these tests pass.
