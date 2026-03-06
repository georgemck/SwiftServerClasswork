# 7.4 Passing testCreatePollSuccess

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 4

## Updating APIHandler with database support

Now comes the satisfying part—transforming your failing test into a passing one. Update the APIHandler with a real
`createPoll` function that works. Run the test from the last section again with `swift test` and watch it turn green.

```swift
import Fluent
import Foundation
import OpenAPIRuntime
import OpenAPIVapor
import Vapor

struct APIHandler: APIProtocol {
    ...
    func createPoll(_ input: Operations.CreatePoll.Input) async throws -> Operations.CreatePoll.Output {
        do {
            switch input.body {
            case .json(let createRequest):
                // Create new poll model
                let newPoll = Models.Poll()
                newPoll.question = createRequest.question

                // Save to database
                try await newPoll.save(on: self.database)

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

    func listPolls(_ input: Operations.ListPolls.Input) async throws -> Operations.ListPolls.Output {
        // Keep the placeholder implementation for now
        let emptyPolls: [Components.Schemas.Poll] = []
        let pageOfPolls = Components.Schemas.PageOfPolls(polls: emptyPolls)

        return .ok(.init(body: .json(pageOfPolls)))
    }

    func getPollDetail(_ input: Operations.GetPollDetail.Input) async throws -> Operations.GetPollDetail.Output {
        // Keep the placeholder implementation for now
        return .notFound(.init())
    }
}
```

## Understanding the implementation

Walk through what you have built. The updated `createPoll` method performs a complete workflow that takes you from HTTP
request to database persistence:

- Creates a model instance by instantiating a new `Models.Poll` object with no persisted data.
- Assigns the question from the request. Fluent automatically sets the timestamp when save() executes, capturing the
  creation time.
- Uses Fluent's `save()` method to persist the poll to the database, making it permanent.
- Transforms the saved model to the OpenAPI schema format, adapting your internal representation to the API contract.
- Provides HTTP 201 Created with the poll data, signaling success to the client.

## Running the test

Execute `swift test` to verify that your implementation works. The test passes—and not just superficially. It succeeds
because you have built something real: the implementation saves polls to the database and returns the correct HTTP status
code. It provides the poll data with a valid database-generated ID, proving that the entire flow works end to end.

## TDD green phase complete

You have reached a milestone. The test is now passing, completing the green phase of test-driven development. You have
created the minimal functionality needed to satisfy the test requirements—nothing more, nothing less. This is the ideal
balance between functionality and simplicity.

Continue your test-driven journey in the next step by adding another test. Verify how your system handles duplicate
poll questions, which drives you to implement conflict detection and proper error responses. Each test teaches your
system a new skill.
