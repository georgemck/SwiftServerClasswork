# 8.1 Write a test to update a Poll

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 1

## Extending the OpenAPI specification

First, add `update` and `delete` operations to your `openapi.yaml` file. Add these paths under the existing
`/polls/{pollId}` section:

```yaml
  /polls/{pollId}:
    parameters:
      - $ref: "#/components/parameters/path.pollId"
    get:
      # ... existing get operation
    patch:
      summary: Update an existing poll.
      operationId: updatePoll
      tags:
        - Polls
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UpdatePollRequest"
      responses:
        "200":
          description: The poll was updated successfully.
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Poll"
        "404":
          description: A poll with this id was not found.
        "409":
          description: Conflict - A poll with this question already exists
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/ConflictError"
    delete:
      summary: Delete an existing poll.
      operationId: deletePoll
      tags:
        - Polls
      responses:
        "204":
          description: The poll was deleted successfully.
        "404":
          description: A poll with this id was not found.
```

## Adding the UpdatePollRequest schema

Add this schema to the `components.schemas` section of your `openapi.yaml` file:

```yaml
...
    UpdatePollRequest:
      description: The request data required to update a poll.
      properties:
        question:
          description: The updated question for the poll.
          type: string
      required:
        - question
...
```

## Writing the update test

This step demonstrates comprehensive update operation testing.

Open the `APIHandlerTests.swift` file and add the following test method to the `APIHandlerIntegrationTests` struct:

```swift
@Test("PATCH /api/polls/{pollId} updates existing poll successfully")
func testUpdatePollSuccess() async throws {
    try await TestHelpers.withApplication { application in
        // Create a poll first
        let createRequest = Components.Schemas.CreatePollRequest(question: "Original question?")
        let createResponse = try await application.sendRequest(.POST, "/api/polls", body: createRequest)
        let createdPoll = try createResponse.content.decode(Components.Schemas.Poll.self)

        // Update the poll
        let updateRequest = Components.Schemas.UpdatePollRequest(question: "Updated question?")
        let updateResponse = try await application.sendRequest(.PATCH, "/api/polls/\(createdPoll.id)",
                                                               body: updateRequest)

        #expect(updateResponse.status == .ok)
        #expect(updateResponse.headers.contentType == .json)

        let updatedPoll = try updateResponse.content.decode(Components.Schemas.Poll.self)
        #expect(updatedPoll.id == createdPoll.id)
        #expect(updatedPoll.question == "Updated question?")
    }
}
```

## Running the failing test

After updating the OpenAPI specification, run `swift build` to regenerate the API types. Then execute `swift test` to see
the failing test.

This test establishes the expected behavior for poll updates using TDD principles. The next step implements the update
functionality to make this test pass.
