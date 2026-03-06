# 7.2 Creating a withApplication test helper

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

## Creating the TestHelpers file

Before you can test your polling system, you need to build the infrastructure that makes testing possible. Think of this
as constructing a test laboratory where each experiment starts with a fresh database state and runs in complete isolation.

Create a new file named `TestHelpers.swift` in the `Tests/PollsAppTests` directory. You use the same `configureServer`
function that configures the application itself, ensuring your tests mirror the real production environment.

```swift
import Fluent
import FluentSQLiteDriver
import Foundation
import OpenAPIVapor
import Testing
import Vapor
import VaporTesting

@testable import PollsApp

struct TestHelpers {
    static func withApplication<T>(_ testBody: (Application) async throws -> T) async throws -> T {
        let application = try await Application.make(.testing)

        do {
            application.databases.use(.sqlite(.memory), as: .sqlite)
            let _ = try await configureServer(application)

            let result = try await testBody(application)

            try await application.autoRevert()
            try await application.asyncShutdown()

            return result
        } catch {
            try? await application.autoRevert()
            try await application.asyncShutdown()

            throw error
        }
    }
}

extension Application {
    func sendRequest<Body: Encodable>(
        _ method: HTTPMethod,
        _ path: String,
        body: Body
    ) async throws -> TestingHTTPResponse {
        try await sendRequest(method, path) { req in
            req.headers.contentType = .json
            try req.content.encode(body, as: .json)
        }
    }

    func sendRequest(_ method: HTTPMethod, _ path: String, body: Data) async throws -> TestingHTTPResponse {
        try await sendRequest(method, path) { req in
            req.headers.contentType = .json
            req.body = .init(data: body)
        }
    }

    func sendRequest(_ method: HTTPMethod, _ path: String) async throws -> TestingHTTPResponse {
        try await sendRequest(method, path) { _ in }
    }
}
```

## Understanding the test helper

Now that you have built your test laboratory, examine what makes it work. The `withApplication` helper is not just
convenient—it is essential for reliable testing. This helper provides the following:

- Isolated testing with a fresh in-memory SQLite database for each test, preventing tests from interfering with each
  other.
- Automatic configuration of the database, migrations, and routes, eliminating repetitive setup code.
- Proper shutdown of the application when testing completes, preventing resource leaks.
- Connection between the APIHandler and HTTP routes, ensuring you test the complete request flow.

## Extension for HTTP requests

You also add extension methods that make sending HTTP requests feel natural in your tests. The `Application` extension
transforms what could be verbose HTTP setup into clean, readable test code. It automatically converts Swift objects to JSON
request bodies and supports both typed objects and raw data. The extension automatically sets `Content-Type` to
`application/json`. It also works seamlessly with Swift concurrency, allowing you to use `async` and `await` directly.

## Benefits of in-memory testing

In-memory databases excel in testing scenarios. Using `.sqlite(.memory)` for tests is not just about convenience—it
fundamentally changes how you approach testing:

- Creates extremely fast in-memory databases that run at RAM speed rather than disk speed.
- Each test starts with a clean database state that disappears automatically when testing completes, eliminating cleanup
  concerns.
- Provides parallel safety where each test gets its own database instance without interference, enabling you to run tests
  concurrently.

Move into test-driven development territory in the next section, where you write your first test for creating polls
successfully. This is where your testing infrastructure proves its worth.
