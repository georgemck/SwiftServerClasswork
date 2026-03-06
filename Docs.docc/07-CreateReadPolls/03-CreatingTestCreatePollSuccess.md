# 7.3 Creating testCreatePollSuccess

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 3

## Add the Create endpoint to OpenAPI.yaml

You are following spec-driven development, which means you start by describing what you want your API to do before you
write any implementation code. This approach forces you to think clearly about your API contract with the outside world.

Begin by adding the following create endpoint to the `openapi.yaml` file:

```yaml
...
paths:
    ...
   post:
      summary: Create a new poll.
      operationId: createPoll
      tags:
        - Polls
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreatePollRequest"
      responses:
        "201":
          description: The poll was created successfully.
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Poll"
        "401":
          description: Unauthorized
        "409":
          description: Conflict - A poll with this question already exists
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/ConflictError"
components:
    schemas:
        ...
        CreatePollRequest:
          description: The request data required to create a poll.
          properties:
            question:
              description: The question asked by the poll.
              type: string
          required:
              - question
        ConflictError:
          description: Error response for conflicts.
          properties:
              error:
                type: boolean
                example: true
              reason:
                type: string
                example: "A poll with the question 'What is your favorite Swift feature?' already exists"
          required:
              - error
              - reason
```

## Creating the test file

Now you are ready to write the test that guides your implementation. This is the heart of test-driven development: the
test comes first, defining exactly what success looks like.

Create a new file named `APIHandlerTests.swift` in the `Tests/PollsAppTests` directory and add the following code:

```swift
import Fluent
import FluentSQLiteDriver
import Foundation
import OpenAPIVapor
import Testing
import Vapor
import VaporTesting

@testable import PollsApp

@Suite("API Handler Integration Tests")
struct APIHandlerIntegrationTests {

    @Test("POST /api/polls creates a new poll successfully")
    func testCreatePollSuccess() async throws {
        try await TestHelpers.withApplication { application in
            let createRequest = Components.Schemas.CreatePollRequest(
                question: "What is your favorite programming language?"
            )

            let response = try await application.sendRequest(.POST, "/api/polls", body: createRequest)

            #expect(response.status == .created)
            #expect(response.headers.contentType == .json)

            let createdPoll = try response.content.decode(Components.Schemas.Poll.self)
            #expect(createdPoll.question == "What is your favorite programming language?")
            #expect(createdPoll.id > 0)
        }
    }
}
```

> In the code checkpoints, you mark failing tests as disabled to keep the build green while you work toward a solution.

## Creating a stub handler implementation

You need your code to build, but you have not implemented the feature yet. Swift OpenAPI provides a solution with the
`.undocumented` method, which lets you mark handler endpoints as work in progress. This approach ensures that `swift build`
succeeds while you are still developing.

In the `APIHandler.swift` file add the following:

```swift
import OpenAPIRuntime
...
struct APIHandler: APIProtocol {
    ...
    func createPoll(_ input: Operations.CreatePoll.Input) async throws -> Operations.CreatePoll.Output {
        .undocumented(statusCode: 500, UndocumentedPayload())
    }
    ...
}
```

## Updating the APIHandler

Before you move forward, there is one more crucial piece: the `APIHandler` needs access to the database. After all, you
cannot save polls without somewhere to save them. Update the code to accept a database as a parameter:

```swift
import Fluent
...
struct APIHandler: APIProtocol {
    let database: Database
    init(database: Database) {
        self.database = database
    }
    ...
}
```

Also edit the `Sources/PollsApp/ServerService.swift` file to initialize `APIHandler` with the database:

```swift
...
  let handler = APIHandler(database: application.db)
...
```
