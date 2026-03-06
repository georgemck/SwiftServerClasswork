# 8.3 Write a test to delete a Poll

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 3

## Adding a test for successful deletion

Open the `APIHandlerTests.swift` file and add the following test method to the `APIHandlerIntegrationTests` struct:

```swift
@Test("DELETE /api/polls/{pollId} deletes existing poll successfully")
func testDeletePollSuccess() async throws {
    try await TestHelpers.withApplication { application in
        // Create a poll first
        let createRequest = Components.Schemas.CreatePollRequest(question: "Poll to delete?")
        let createResponse = try await application.sendRequest(.POST, "/api/polls", body: createRequest)
        let createdPoll = try createResponse.content.decode(Components.Schemas.Poll.self)

        // Delete the poll
        let deleteResponse = try await application.sendRequest(.DELETE, "/api/polls/\(createdPoll.id)")

        #expect(deleteResponse.status == .noContent)

        // Verify the poll is actually deleted by trying to fetch it
        let fetchResponse = try await application.sendRequest(.GET, "/api/polls/\(createdPoll.id)")
        #expect(fetchResponse.status == .notFound)
    }
}
```

## Adding a not-found deletion test

In the same struct, add the following test method to verify proper error handling for non-existent polls:

```swift
@Test("DELETE /api/polls/{pollId} returns not found for non-existent poll")
func testDeletePollNotFound() async throws {
    try await TestHelpers.withApplication { application in
        // Attempt to delete a poll that doesn't exist
        let response = try await application.sendRequest(.DELETE, "/api/polls/999")

        #expect(response.status == .notFound)
    }
}
```

## Adding a deletion verification test

Finally, add the following test to ensure that deletion affects the polls list:

```swift
@Test("DELETE /api/polls/{pollId} removes poll from list")
func testDeletePollRemovesFromList() async throws {
    try await TestHelpers.withApplication { application in
        // Create two polls
        let poll1 = Components.Schemas.CreatePollRequest(question: "Keep this poll?")
        let poll2 = Components.Schemas.CreatePollRequest(question: "Delete this poll?")

        let response1 = try await application.sendRequest(.POST, "/api/polls", body: poll1)
        let response2 = try await application.sendRequest(.POST, "/api/polls", body: poll2)

        let createdPoll2 = try response2.content.decode(Components.Schemas.Poll.self)

        // Delete the second poll
        _ = try await application.sendRequest(.DELETE, "/api/polls/\(createdPoll2.id)")

        // Verify only one poll remains in the list
        let listResponse = try await application.sendRequest(.GET, "/api/polls")
        let pageOfPolls = try listResponse.content.decode(Components.Schemas.PageOfPolls.self)

        #expect(pageOfPolls.polls.count == 1)
        #expect(pageOfPolls.polls.first?.question == "Keep this poll?")
    }
}
```

Then, run `swift test` to see the failing tests.

## Understanding the test scenarios

These tests verify several behaviors:

- Existing polls can be deleted and return HTTP 204 No Content.
- The poll is actually removed from the database by attempting to fetch it afterward.
- Proper HTTP 404 response for non-existent poll IDs.
- Deletion removes polls from the complete list.

## HTTP status codes for deletion

DELETE operations use specific status codes:

- HTTP 204 No Content indicates successful deletion with no response body.
- HTTP 404 Not Found signals an attempt to delete a non-existent resource.

## Running the tests

Execute `swift test --filter "testDeletePoll"` to run all deletion tests. The tests fail because the `deletePoll`
method is not yet implemented in the `APIHandler`.

The tests establish the expected behavior for poll deletion using TDD principles. The next step implements the deletion
functionality to make these tests pass.
