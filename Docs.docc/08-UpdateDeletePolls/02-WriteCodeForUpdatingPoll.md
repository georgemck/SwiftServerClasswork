# 8.2 Write code to update a Poll

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

## Adding the updatePoll method

Add this method to your `APIHandler` struct in `APIHandler.swift`, then execute `swift test`.

```swift
func updatePoll(_ input: Operations.UpdatePoll.Input) async throws -> Operations.UpdatePoll.Output {
    do {
        let pollId = input.path.pollId

        switch input.body {
        case .json(let updateRequest):
            // Find the existing poll
            guard let existingPoll = try await Models.Poll.find(Int32(pollId), on: database) else {
                return .notFound(.init())
            }

            // Check if another poll already has this question (excluding current poll)
            if try await Models.Poll.query(on: database)
                .filter(\.$question == updateRequest.question)
                .filter(\.$id != existingPoll.id!)
                .first() != nil
            {
                let conflictResponse = Components.Schemas.ConflictError(
                    error: true,
                    reason: "A poll with the question '\(updateRequest.question)' already exists"
                )
                return .conflict(.init(body: .json(conflictResponse)))
            }

            // Update the poll
            existingPoll.question = updateRequest.question

            try await existingPoll.save(on: database)

            // Convert to API response format
            let pollResponse = Components.Schemas.Poll(
                id: Int(existingPoll.id!),
                question: existingPoll.question,
            )

            return .ok(.init(body: .json(pollResponse)))
        }
    } catch {
        throw error
    }
}
```

## Understanding the implementation

The `updatePoll` method implements comprehensive update logic:

- Extracts the poll ID from the URL path parameter.
- Uses Fluent's `find()` to locate the poll to update.
- Returns HTTP 404 when the poll does not exist.
- Checks that no other poll has the same question, excluding the current poll from that uniqueness check.
- Modifies the question and updates the timestamp.
- Persists the updated poll to the database.
- Provides HTTP 200 OK with the updated poll data.

## Duplicate question validation

The uniqueness validation is more complex for updates:

- The filter `.filter(\.$question == updateRequest.question)` finds polls with matching questions.
- The additional filter `.filter(\.$id != existingPoll.id!)` ensures no other poll has the same question.
- This allows the current poll to keep its existing question if unchanged.
- This prevents false positives when updating other fields.

## Fluent update operations

The update process uses Fluent's model modification:

- Properties are modified directly on the model instance.
- Calling `save()` persists changes to the database.
- Fluent automatically updates the `updated_at` timestamp.

## Running the test

Execute `swift test --filter testUpdatePollSuccess` to verify that the test now passes. The implementation successfully
updates the poll question and returns the updated poll data. It handles the updated timestamp correctly and maintains
proper validation for duplicate questions.

The next step adds tests for poll deletion functionality.
