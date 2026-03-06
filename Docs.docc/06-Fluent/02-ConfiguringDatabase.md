# 6.2 Configuring the database

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 2

## Creating the database configuration

Now you are ready to set up the database. This is where Fluent connects your application to persistent storage and
transforms the application from a stateless request handler into a system that remembers. Create a new file called
`Database.swift` in the `Sources/PollsApp` directory:

```swift
import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

enum DatabaseError: Error, LocalizedError {
    case migrationFailed(String)
    case configurationFailed(String)

    var errorDescription: String? {
        switch self {
        case .migrationFailed(let message):
            return "Database migration failed: \(message)"
        case .configurationFailed(let message):
            return "Database configuration failed: \(message)"
        }
    }
}

func configureDatabase(_ application: Application) async throws {
    do {
        // Configure SQLite database
        application.databases.use(.sqlite(.memory), as: .sqlite)

        // Add migrations (you will create these in a later step)
        application.migrations.add([
            // Migrations will be added here
        ])

        // Run migrations automatically
        try await application.autoMigrate()
    } catch {
        let errorMessage = error.localizedDescription
        if errorMessage.contains("migration") || errorMessage.contains("Migration") {
            throw DatabaseError.migrationFailed(errorMessage)
        } else {
            throw DatabaseError.configurationFailed(errorMessage)
        }
    }
}
```

## Integrating database configuration

With your database configuration ready, integrate it into your server's startup sequence. In the `ServerService.swift`
file, update the `configureServer` function to call `configureDatabase` at the very top. This ensures your database is
ready before anything else tries to use it.

```swift
func configureServer(_ application: Application) async throws -> Service {
    // Configure the database
    try await configureDatabase(application) // add the call here

    // Keep existing route configuration
    routes(application)

    // Create API handler for request processing
    let handler = APIHandler()

    ... // other existing code
```

This setup uses SQLite for development simplicity. SQLite is perfect for getting started because everything runs in memory
without needing external database servers. Later, when you are ready for production, swap SQLite with PostgreSQL by
changing the database driver dependency and configuration. Fluent keeps your code consistent regardless of which database
you choose.

Create the `Poll` model in the next step. Fluent uses this model to interact with the database. This is where you define
what a poll actually looks like in your system.
