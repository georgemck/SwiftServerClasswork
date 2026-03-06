# 7.5 Write a test for duplicate questions

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 5

## Adding the duplicate question test

This step demonstrates comprehensive testing of error handling.

Add this test method to the `APIHandlerIntegrationTests` struct in `APIHandlerTests.swift`:

```swift
@Test("POST /api/polls returns conflict for duplicate question")
func testCreatePollDuplicateQuestion() async throws {
    try await TestHelpers.withApplication { application in
        let createRequest = Components.Schemas.CreatePollRequest(question: "Duplicate question?")

        // Create the first poll
        _ = try await application.sendRequest(.POST, "/api/polls", body: createRequest)

        // Attempt to create a duplicate poll
        let duplicateResponse = try await application.sendRequest(.POST, "/api/polls", body: createRequest)

        #expect(duplicateResponse.status == .conflict)
        #expect(duplicateResponse.headers.contentType == .json)

        let conflictError = try duplicateResponse.content.decode(Components.Schemas.ConflictError.self)
        #expect(conflictError.error == true)
        #expect(conflictError.reason.contains("Duplicate question?"))
    }
}
```

Then run `swift test` to see the failing test.

```bash
...
􀢄  Test "POST /api/polls returns conflict for duplicate question" recorded an issue at
   APIHandlerTests.swift:43:13: Expectation failed: (duplicateResponse.status → 500 Internal
   Server Error) == (.conflict → 409 Conflict)
...
```

## Understanding the test scenario

This test verifies conflict handling:

- The test creates a poll with a specific question.
- The test attempts to create another poll with the same question.
- The test expects HTTP 409 Conflict with error details explaining why the creation failed.

## Test assertions

The test expects several responses:

- HTTP 409 Conflict as the proper status code for duplicate resource attempts.
- A JSON response containing error information in structured format.
- An error flag indicating that an error occurred.
- A descriptive reason that explains the conflict and includes the duplicate question text.

## Running the failing test

Execute `swift test` to run this test. It will fail because the current implementation does not check for existing polls
with the same question.

The failure demonstrates the "Red" phase of TDD. The test defines the required behavior before implementation exists to
implement it.

The next step implements duplicate detection and conflict response-handling to make this test pass.
